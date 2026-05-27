Shader "Custom/TextureScroll Unlit Transparent Mask"
{
    Properties
    {
        [MainColor]   _BaseColor("Base Color", Color)       = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D)              = "white" {}
        [MainScroll]  _BaseScroll("Base Scroll UV", Vector) = (1, 1, 0, 0)
        [Mask]        _Mask("Mask", 2D)                     = "white" {}
        [MaskScroll]  _MaskScroll("Mask Scroll UV", Vector) = (0, 0, 0, 0)
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent" 
            "Queue" = "Transparent"
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

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
            
            TEXTURE2D(_Mask);
            SAMPLER(sampler_Mask);

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
                float2 _BaseScroll;
                float4 _Mask_ST;
                float2 _MaskScroll;
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
                // Calculate scroll offsets
                float2 scroll_uv = IN.uv + _Time.y * _BaseScroll.xy;
                float2 mask_scroll_uv = IN.uv + _Time.y * _MaskScroll.xy;
                // Compute pixel in map
                half4 mask  = SAMPLE_TEXTURE2D(_Mask, sampler_Mask, mask_scroll_uv);
                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, scroll_uv) * _BaseColor;
                // Mask color before output
                color = color * mask;
                return color;
            }
            ENDHLSL
        }
    }
}
