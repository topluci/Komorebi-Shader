#ifndef KOMOREBI_COLOR_POST_GLSL
#define KOMOREBI_COLOR_POST_GLSL

const vec3 KOMOREBI_GRADE_S = vec3(0.010, 0.008, 0.018);
const vec3 KOMOREBI_GRADE_M = vec3(0.008, 0.005, -0.002);
const vec3 KOMOREBI_GRADE_H = vec3(-0.004, 0.000, 0.010);

float komorebi_luma_post(vec3 c) {
    return dot(c, vec3(0.2126, 0.7152, 0.0722));
}

void komorebi_zones_post(float lum, out float shadowW, out float midW, out float highlightW) {
    shadowW    = (1.0 - smoothstep(0.0, 0.5, lum));
    highlightW = smoothstep(0.5, 1.0, lum);
    midW       = 1.0 - abs(shadowW - highlightW);
    float total = shadowW + midW + highlightW + 0.001;
    shadowW /= total; midW /= total; highlightW /= total;
}

vec3 komorebi_grade_post(vec3 color) {
    float lum = komorebi_luma_post(color);
    float sw, mw, hw;
    komorebi_zones_post(lum, sw, mw, hw);
    color += KOMOREBI_GRADE_S * sw;
    color += KOMOREBI_GRADE_M * mw;
    color += KOMOREBI_GRADE_H * hw;
    return max(color, vec3(0.0));
}

vec3 komorebi_vibrance_post(vec3 color, float amount) {
    float lum     = komorebi_luma_post(color);
    float maxC    = max(color.r, max(color.g, color.b));
    float minC    = min(color.r, min(color.g, color.b));
    float satProxy = maxC - minC;
    float boost = amount * (1.0 - satProxy);
    return mix(vec3(lum), color, 1.0 + boost);
}

vec3 komorebi_finalGradeNoVignette(vec3 color, vec2 texcoord) {
    color = komorebi_grade_post(color);
    color = komorebi_vibrance_post(color, KOMOREBI_VIBRANCE);
    color = pow(max(color, vec3(0.0)), vec3(KOMOREBI_FINAL_GAMMA));
    return clamp(color, 0.0, 1.0);
}

#endif
