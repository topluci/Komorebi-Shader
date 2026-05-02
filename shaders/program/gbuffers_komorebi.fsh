#define CEL_BANDS 4.0 //[3.0 4.0 5.0]
#define SHADOW_DEPTH 0.62 //[0.35 0.48 0.62 0.70 0.82]
#define RIM_STRENGTH 0.24 //[0.00 0.12 0.24 0.32 0.45]
#define MIN_SHADOW_LIGHT 0.18 //[0.12 0.18 0.24 0.30]

#include "/lib/komorebi_common.glsl"

uniform sampler2D texture;
uniform vec3 sunPosition;
uniform float rainStrength;

varying vec2 texcoord;
varying vec4 vertexColor;
varying vec3 viewNormal;
varying vec3 viewPosition;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * vertexColor;

    if (albedo.a < 0.10) {
        discard;
    }

    vec3 normal = normalize(viewNormal);
    vec3 sunDir = normalize(sunPosition);

    float sunDiffuse = max(dot(normal, sunDir), 0.0);
    float bakedLight = clamp(kLuma(vertexColor.rgb) * 1.28, 0.0, 1.0);
    float shadeSource = max(sunDiffuse, bakedLight * 0.58);
    float cel = kCelBands(shadeSource, CEL_BANDS);

    vec3 color = kCelLight(albedo.rgb, cel, SHADOW_DEPTH);
    vec3 minimumTint = albedo.rgb * vec3(0.52, 0.48, 0.76) * MIN_SHADOW_LIGHT;
    color = max(color, minimumTint);

    vec3 viewDir = normalize(-viewPosition);
    float rim = kRimFactor(normal, viewDir);
    vec3 rimColor = mix(vec3(0.16, 0.24, 0.42), vec3(0.44, 0.56, 0.86), 1.0 - rainStrength);
    color += rim * RIM_STRENGTH * rimColor * (0.45 + 0.55 * cel);

    gl_FragData[0] = vec4(color, albedo.a);
}
