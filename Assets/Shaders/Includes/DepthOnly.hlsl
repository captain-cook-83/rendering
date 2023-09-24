#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

struct Attributes
{
    float4 position : POSITION;
};

struct Varyings
{
    float4 positionCS : SV_POSITION;
    // UNITY_VERTEX_OUTPUT_STEREO
};

Varyings DepthOnlyVertex(Attributes i)
{
    Varyings o = (Varyings)0;
    // UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    o.positionCS = TransformObjectToHClip(i.position);
    return o;
}

half DepthOnlyFragment(Varyings i) : SV_TARGET
{
    // UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
    return i.positionCS.z;
}