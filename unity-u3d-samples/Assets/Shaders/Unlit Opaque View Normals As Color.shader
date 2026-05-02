Shader "Custom/Unlit Opaque View Normals As Color"
{
    Properties
    {
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
        }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                half4 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                half3 normalWorldSpace : NORMAL;
            };

            CBUFFER_START(UnityPerMaterial)
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.normalWorldSpace = TransformObjectToWorldNormal(IN.normalOS.xyz);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = 0;
                color.rgb = IN.normalWorldSpace * 0.5 + 0.5;
                return color;
            }
            ENDHLSL
        }
    }
}
