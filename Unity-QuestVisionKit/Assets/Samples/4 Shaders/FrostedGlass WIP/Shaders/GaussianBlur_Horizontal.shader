Shader "Unlit/GaussianBlur_Horizontal"
{
    Properties
    {
        [MainTexture] _BaseMap ("Base Texture", 2D) = "white" {}
        _KernelSize ("Kernel Size", Integer) = 1
        _KernelStep ("Kernel Step Size", Integer) = 1
    }
    SubShader
    {
        Tags 
        { 
            "RenderType" = "Opaque" 
            "Queue" = "Geometry"
            "RenderPipeline" = "UniversalPipeline"
        }

        Pass
        {
            Name "Gaussian Blur - Horizontal"

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define E 2.71828f

            inline float gaussianWeight(int x, float constant, float exponent)
            {
                return constant * pow(E, -(x * x) * exponent);
            }

            struct appdata
            {
                float4 positionOS : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
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

                // Loop over kernel horizontally.
                for(int x = -_KernelSize; x <= _KernelSize; x += _KernelStep)
                {
                    float2 uv = screenUV + float2(x * pixelSize.x, 0.0f);
                    float gaussian = gaussianWeight(x, constant, exponent);

                    col += SAMPLE_TEXTURE2D_LOD(_BaseMap, sampler_BaseMap, uv, 0).rgb * gaussian;
                    weightSum += gaussian;
                }

                col /= weightSum;

                return float4(col, 1.0f);
            }
            ENDHLSL
        }
    }
}
