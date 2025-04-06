Shader "Custom/CameraMappedGaussianBlur"
{
    Properties
    {
        [IntRange] _BlurIntensity ("Blur Intensity", Range(1, 25)) = 15
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            Name "Camera Mapped Gaussian Blur"

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            float4 _MainTex_TexelSize;
            float _BlurIntensity;


            // Controller-updated uniforms:
            float3 _CameraPos;
            float2 _FocalLength;       // In pixels.
            float2 _PrincipalPoint;    // In pixels (from top-left).
            float2 _IntrinsicResolution; // Calibration resolution.
            float4x4 _CameraRotationMatrix;

            struct Attributes { float4 vertex : POSITION; };

            struct Varyings
            {
                float4 clipPos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.clipPos = TransformObjectToHClip(IN.vertex);
                float4 worldPos = mul(unity_ObjectToWorld, IN.vertex);
                OUT.worldPos = worldPos.xyz;
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


                // Calculate kernel size based on _BlurIntensity (odd number)
                int kernelSize = int(_BlurIntensity * 2.0 + 1.0);
                float sigma = _BlurIntensity;

                // Generate Gaussian kernel
                float kernel[26]; // Pre-allocate for max kernel size
                float kernelSum = 0.0f;

                for (int i = 0; i < kernelSize; i++)
                {
                    float x = float(i) - float(kernelSize - 1) / 2.0f;
                    kernel[i] = exp(-0.5 * (x * x) / (sigma * sigma));
                    kernelSum += kernel[i];
                }

                // Normalize kernel weights
                for (int i = 0; i < kernelSize; i++)
                {
                    kernel[i] /= kernelSum;
                }

                float2 texelSize = float2(1.0 / _ScreenParams.x, 1.0 / _ScreenParams.y);
                float4 color = float4(0.0, 0.0, 0.0, 0.0);

                // Half size of the kernel for sampling offsets
                int halfKernel = kernelSize / 2;

                // Perform horizontal and vertical blur
                for (int y = -halfKernel; y <= halfKernel; y++)
                {
                    for (int x = -halfKernel; x <= halfKernel; x++)
                    {
                        float weight = kernel[abs(x)] * kernel[abs(y)];
                        float2 offset = float2(x * texelSize.x, y * texelSize.y);

                        color += weight * SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, computedUV + offset);
                    }
                }

                return color;
            }
            ENDHLSL
        }
    }
    FallBack "Hidden/InternalErrorShader"
}
