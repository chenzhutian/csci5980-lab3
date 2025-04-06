Shader "Unlit/GaussianBlur_Vertical"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
        _KernelSize ("Kernel Size", Integer) = 1
        _KernelStep ("Kernel Step Size", Integer) = 1
    }
    SubShader
    {
        Tags 
        { 
            "RenderType" = "Transparent" 
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
        }

        Pass
        {
            Name "Gaussian Blur - Vertical"

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareOpaqueTexture.hlsl"

            #define E 2.71828f

            inline float gaussianWeight(int y, float constant, float exponent)
            {
                return constant * pow(E, -(y * y) * exponent);
            }

            struct appdata
            {
                float4 positionOS : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float3 positionWS : TEXCOORD0;
                float fogFactor : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor;
                int _KernelSize;
                int _KernelStep;
            CBUFFER_END

            v2f vert (appdata v, out float4 positionCS : SV_Position)
            {
                v2f o;

                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                positionCS = TransformObjectToHClip(v.positionOS.xyz);
                o.positionWS = mul(UNITY_MATRIX_M, v.positionOS);
                o.fogFactor = ComputeFogFactor(positionCS.z);
                return o;
            }

            float4 frag (v2f i, float4 positionSS : VPOS) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(i);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                // Calculate UVs and pixel-width offsets.
                float2 pixelSize = _ScreenParams.zw - 1.0f;
                float2 screenUV = positionSS.xy * pixelSize;

                float3 col = 0.0f;
                float weightSum = 0.0f;

                // Calculate part of gaussian weight expression.
                float spreadSqu = _KernelSize * 0.1666f;
                spreadSqu *= spreadSqu;
                float constant = 1.0f / sqrt(TWO_PI * spreadSqu);
                float exponent = 1.0f / (2 * spreadSqu);

                // Loop over kernel vertically.
                for(int y = -_KernelSize; y <= _KernelSize; y += _KernelStep)
                {
                    float2 uv = screenUV + float2(0.0f, y * pixelSize.y);
                    float gaussian = gaussianWeight(y, constant, exponent);

                    col += SampleSceneColor(uv) * gaussian;
                    weightSum += gaussian;
                }

                col /= weightSum;

                // Apply fog.
                float fogCoord = InitializeInputDataFog(float4(i.positionWS, 1.0), i.fogFactor);
                col.rgb = MixFog(col.rgb, fogCoord);

                // Multiply by _BaseColor to get final color.
                return float4(col, 1.0f) * _BaseColor;
            }
            ENDHLSL
        }
    }
}
