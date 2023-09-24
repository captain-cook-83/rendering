Shader "Cc83/Unlit/UnlitReconstructWorldPos"
{
    Properties
    {
        _MaxDepthDistance("Max Depth Distance", Range(10, 1000)) = 50
    }
    
    SubShader
    {
        Tags { "RenderType"="Oqaque" }
        
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

            CBUFFER_START(UnityPerMaterial)
                float _MaxDepthDistance;
            CBUFFER_END
            
            struct Attributes
            {
                float4 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
            };

            Varyings vert(Attributes i)
            {
                Varyings o = (Varyings)0;
                o.positionCS = TransformObjectToHClip(i.positionOS.xyz);
                return o;
            }

            half4 frag(Varyings i) : SV_Target
            {
                // To calculate the UV coordinates for sampling the depth buffer,
                // divide the pixel location by the render target resolution
                // _ScaledScreenParams.
                float2 uv = i.positionCS.xy / _ScaledScreenParams.xy;  // 向量没有除法运算，此语法糖表示：每个分量分别相除
                
                // Sample the depth from the Camera depth texture.
                #if UNITY_REVERSED_Z
                    float depth = SampleSceneDepth(uv);
                #else
                    // Adjust Z to match NDC for OpenGL ([-1, 1])
                    real depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, SampleSceneDepth(uv));
                #endif

                // const float distance = lerp(0, _ProjectionParams.z, Linear01Depth(depth, _ZBufferParams));
                const float distance = LinearEyeDepth(depth, _ZBufferParams);
                const float channel = saturate(distance / min(_ProjectionParams.z, _MaxDepthDistance));
                return half4(channel, channel, channel, 1.0);
            }
            ENDHLSL
        }
    }
}
