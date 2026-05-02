#define SATURATION 1.25 //[1.00 1.10 1.15 1.25 1.32 1.40]
#define WARMTH 0.28 //[0.00 0.12 0.18 0.28 0.34 0.45]
#define OUTLINE_WIDTH 1.15 //[0.00 0.75 1.15 1.60 2.10]
#define OUTLINE_STRENGTH 0.70 //[0.00 0.35 0.50 0.70 0.86 1.00]
#define EDGE_DEPTH_SENSITIVITY 70.0 //[35.0 45.0 60.0 70.0 95.0 125.0]

#include "/lib/komorebi_common.glsl"

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform float viewWidth;
uniform float viewHeight;

varying vec2 texcoord;

float kDepthAt(vec2 uv) {
    return texture2D(depthtex0, clamp(uv, vec2(0.0), vec2(1.0))).r;
}

vec3 kColorAt(vec2 uv) {
    return texture2D(colortex0, clamp(uv, vec2(0.0), vec2(1.0))).rgb;
}

float kOutlineEdge(vec2 uv, vec3 centerColor) {
    vec2 pixel = vec2(1.0 / max(viewWidth, 1.0), 1.0 / max(viewHeight, 1.0)) * max(OUTLINE_WIDTH, 0.0);
    float centerDepth = kDepthAt(uv);

    vec2 right = vec2(pixel.x, 0.0);
    vec2 up = vec2(0.0, pixel.y);

    float dRight = abs(centerDepth - kDepthAt(uv + right));
    float dLeft = abs(centerDepth - kDepthAt(uv - right));
    float dUp = abs(centerDepth - kDepthAt(uv + up));
    float dDown = abs(centerDepth - kDepthAt(uv - up));
    float depthDelta = max(max(dRight, dLeft), max(dUp, dDown));

    float depthScale = max(1.0 - centerDepth, 0.018);
    float depthEdge = smoothstep(0.00008, 0.00180, depthDelta * EDGE_DEPTH_SENSITIVITY / depthScale);

    float centerLuma = kLuma(centerColor);
    float lRight = abs(centerLuma - kLuma(kColorAt(uv + right)));
    float lLeft = abs(centerLuma - kLuma(kColorAt(uv - right)));
    float lUp = abs(centerLuma - kLuma(kColorAt(uv + up)));
    float lDown = abs(centerLuma - kLuma(kColorAt(uv - up)));
    float colorDelta = max(max(lRight, lLeft), max(lUp, lDown));
    float colorEdge = smoothstep(0.13, 0.34, colorDelta) * 0.42;

    float skyMask = step(centerDepth, 0.9999);
    return max(depthEdge, colorEdge) * skyMask;
}

void main() {
    vec3 sourceColor = texture2D(colortex0, texcoord).rgb;
    vec3 graded = kFinalGrade(sourceColor, SATURATION, WARMTH);

    float edge = kOutlineEdge(texcoord, sourceColor);
    vec3 ink = vec3(0.034, 0.028, 0.054);
    graded = mix(graded, ink, edge * OUTLINE_STRENGTH);

    gl_FragData[0] = vec4(kSaturate3(graded), 1.0);
}
