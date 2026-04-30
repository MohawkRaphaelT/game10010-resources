Shader "Custom/TextureScroll Unlit Opaque Distortion"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
        [Displacement] _Displacement("Displacement Map", 2D) = "white" {}
        [DisplacementStrength] _DisplacementStrength("Displacement Strength", Vector) = (0.5, 0.5, 0, 0)
        [Scroll] _Scroll ("Scroll UV", Vector) = (1, 1, 0, 0)
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
                float2 uv  : TEXCOORD0;
                float2 uvd : TEXCOORD1;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            TEXTURE2D(_Displacement);
            SAMPLER(sampler_Displacement);

            CBUFFER_START(UnityPerMaterial)
                half4  _BaseColor;
                float4 _BaseMap_ST;
                float4 _Displacement_ST;
                float4 _DisplacementStrength;
                float2 _Scroll;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv  = TRANSFORM_TEX(IN.uv, _BaseMap);
                OUT.uvd = TRANSFORM_TEX(IN.uv, _Displacement);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4  displacement = SAMPLE_TEXTURE2D(_Displacement, sampler_BaseMap, IN.uv) * _DisplacementStrength;
                float2 scroll_uv = (IN.uv + displacement.xy) + _Time.y * _Scroll.xy;
                half4  color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, scroll_uv) * _BaseColor;
                return color;
            }
            ENDHLSL
        }
    }
}
