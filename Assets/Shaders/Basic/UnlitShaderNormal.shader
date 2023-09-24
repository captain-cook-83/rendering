Shader "Cc83/Unlit/UnlitShaderNormal"
{
    Properties {}

    SubShader
    {
        Tags { "RenderType"="Opaque"}
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                half3 normal : NORMAL;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                half3 normal : TEXCOORD0;
            };
            
            Varyings vert (Attributes i)
            {
                Varyings o = (Varyings) 0;
                o.positionCS = TransformObjectToHClip(i.positionOS.xyz);
                
                // Use the TransformObjectToWorldNormal function to transform the
                // normals from object to world space. This function is from the
                // SpaceTransforms.hlsl file, which is referenced in Core.hlsl.
                o.normal = TransformObjectToWorldNormal(i.normal);
                return o;
            }

            half4 frag (Varyings i) : SV_Target
            {
                half4 color = 0;

                // IN.normal is a 3D vector. Each vector component has the range
                // -1..1. To show all vector elements as color, including the
                // negative values, compress each value into the range 0..1.
                color.rgb = i.normal * 0.5 + 0.5;
                return color;
            }
            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags { "LightMode"="DepthOnly" }
            
            ColorMask 0
            
            HLSLPROGRAM
            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment
            
            #include "Assets/Shaders/Includes/DepthOnly.hlsl"
            ENDHLSL
        }
    }
}