Shader "Custom/TextureScroll Unlit Opaque Distortion"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
        [MainMapScroll] _BaseMapScroll ("Base Map Scroll UV", Vector) = (0, 0, 0, 0)
        [DisplacementMap] _DisplacementMap("Displacement Map", 2D) = "white" {}
        [DisplacementSize] _DisplacementSize("Displacement Size", Vector) = (1, 1, 0, 0)
        [DisplacementStrength] _DisplacementStrength("Displacement Strength", Vector) = (0.5, 0.5, 0, 0)
        [DisplacementScroll] _DisplacementScroll ("Displacement Scroll UV", Vector) = (1, 1, 0, 0)
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

            TEXTURE2D(_DisplacementMap);
            SAMPLER(sampler_DisplacementMap);

            CBUFFER_START(UnityPerMaterial)
                half4  _BaseColor;
                float4 _BaseMap_ST;
                float2 _BaseMapScroll;
                float4 _DisplacementMap_ST;
                float4 _DisplacementSize;
                float4 _DisplacementStrength;
                float2 _DisplacementScroll;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv  = TRANSFORM_TEX(IN.uv, _BaseMap);
                OUT.uvd = TRANSFORM_TEX(IN.uv, _DisplacementMap);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                // scroll displacement map, -0.5 to centre effect relative to midtone grey
                float2 scroll_displace_uv = IN.uv + _Time.y * _DisplacementScroll.xy;
                half4  displacement = SAMPLE_TEXTURE2D(_DisplacementMap, sampler_DisplacementMap, scroll_displace_uv / _DisplacementSize) - 0.5;
                displacement = displacement * _DisplacementStrength;
                // scroll base map using displacement
                float2 scroll_basemap_uv = (IN.uv + displacement.xy) + _Time.y * _BaseMapScroll.xy;
                half4  color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, scroll_basemap_uv) * _BaseColor;
                // done
                return color;
            }
            ENDHLSL
        }
    }
}
