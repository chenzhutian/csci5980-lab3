Shader "Custom/CameraMappedWater"
{
    Properties
    {
        _Albedo ("Albedo Texture", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _WaterSpeed ("Water Speed", Float) = 0.05
        _NormalIntensity ("Normal Intensity", Range(0, 1)) = 0.025
        _ColorTint ("Color Tint", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            Name "Camera Mapped Water"

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            float4 _MainTex_TexelSize;

            sampler2D _Albedo;
            SAMPLER(sampler_Albedo);
            TEXTURE2D(_NormalMap);
            SAMPLER(sampler_NormalMap);

            float _WaterSpeed;
            float _NormalIntensity;
            float _ColorTint;

            // Controller-updated uniforms:
            float3 _CameraPos;
            float2 _FocalLength;       // In pixels.
            float2 _PrincipalPoint;    // In pixels (from top-left).
            float2 _IntrinsicResolution; // Calibration resolution.
            float4x4 _CameraRotationMatrix;

            struct Attributes
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float2 uv : TEXCOORD0;
                float4 clipPos : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.clipPos = TransformObjectToHClip(IN.vertex);
                float4 worldPos = mul(unity_ObjectToWorld, IN.vertex);
                OUT.worldPos = worldPos.xyz;
                OUT.uv = IN.uv;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float3 diff = IN.worldPos - _CameraPos;
                float3 localPos = mul(_CameraRotationMatrix, float4(diff, 1.0)).xyz;
                if (localPos.z < 0.001)
                    discard;

                // Compute image-plane coordinates (in intrinsic sensor pixels)
                float uImage = _FocalLength.x * (localPos.x / localPos.z) + _PrincipalPoint.x;
                float vImage = _FocalLength.y * (localPos.y / localPos.z) + _PrincipalPoint.y;
                
                // Scale from intrinsic resolution to actual texture resolution.
                float scaleX = _MainTex_TexelSize.z / _IntrinsicResolution.x;
                float scaleY = _MainTex_TexelSize.w / _IntrinsicResolution.y;
                uImage *= scaleX;
                vImage *= scaleY;

                // Normalize to [0,1] UVs.
                float u = uImage / _MainTex_TexelSize.z;
                float v = vImage / _MainTex_TexelSize.w;
                float2 computedUV = float2(u, v);

                //Calculate combined water normals
                float time = _Time.y * _WaterSpeed;

                float2 offset1 = float2(time, time);
                float2 offset2 = -offset1;

                float3 normal1 = SAMPLE_TEXTURE2D(_NormalMap, sampler_NormalMap, IN.uv + offset1).rgb * _NormalIntensity;
                float3 normal2 = SAMPLE_TEXTURE2D(_NormalMap, sampler_NormalMap, IN.uv + offset2).rgb * _NormalIntensity;

                float3 combinedNormals = normal1 + normal2;

                //Combine normals with calculated UVs
                half4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, computedUV + combinedNormals.xy);

                //Apply albedo tint
                float4 albedo = tex2D(_Albedo, IN.uv);
                float4 tintedColor = lerp(float4(1, 1, 1, 1), albedo, _ColorTint);

                float4 finalColor = tintedColor * col;
                return finalColor;
            }
            ENDHLSL
        }
    }
    FallBack "Hidden/InternalErrorShader"
}
