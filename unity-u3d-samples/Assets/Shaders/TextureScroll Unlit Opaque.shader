Shader "Custom/TextureScroll Unlit Opaque"
{
    Properties
    {
        [MainColor]   _BaseColor("Base Color", Color)       = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D)              = "white" {}
        [MainScroll]  _BaseScroll("Base Scroll UV", Vector) = (1, 1, 0, 0)
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
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
                float2 _BaseScroll;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float2 scroll_uv = IN.uv + _Time.y * _BaseScroll.xy;
                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, scroll_uv) * _BaseColor;
                return color;
            }
            ENDHLSL
        }
    }
}
