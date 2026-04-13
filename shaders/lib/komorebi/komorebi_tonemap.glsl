#ifndef KOMOREBI_TONEMAP_COMP_GLSL
#define KOMOREBI_TONEMAP_COMP_GLSL

const vec3 KOMOREBI_BASE_WARM_TINT = vec3(0.012, 0.005, -0.008);

float komorebi_luma_tm(vec3 c) {
    return dot(c, vec3(0.2126, 0.7152, 0.0722));
}

vec3 komorebi_setSaturation_tm(vec3 c, float sat) {
    float lum = komorebi_luma_tm(c);
    return mix(vec3(lum), c, sat);
}

vec3 komorebi_liftMidtones_tm(vec3 c, float lift) {
    return c + lift * vec3(
        c.r * (1.0 - c.r),
        c.g * (1.0 - c.g),
        c.b * (1.0 - c.b)
    ) * 4.0;
}

vec3 komorebi_pastelCrush_tm(vec3 c, float amount) {
    float lum = komorebi_luma_tm(c);
    float t   = smoothstep(0.55, 1.0, lum) * amount;
    return mix(c, vec3(lum + 0.06), t);
}

vec3 komorebi_filmicCurve_tm(vec3 x) {
    const float a = 2.40;
    const float b = 0.06;
    const float c_ = 2.30;
    const float d = 0.55;
    const float e = 0.16;
    return clamp((x * (a * x + b)) / (x * (c_ * x + d) + e), 0.0, 1.0);
}

vec3 komorebi_tonemapWithTM(vec3 colorLinear, float tmExposure) {
    colorLinear *= tmExposure * (KOMOREBI_EXPOSURE / 1.08);
    colorLinear += KOMOREBI_BASE_WARM_TINT * KOMOREBI_COLOUR_WARMTH;
    colorLinear  = max(colorLinear, vec3(0.0));

    vec3 color = komorebi_filmicCurve_tm(colorLinear);
    color = komorebi_liftMidtones_tm(color, KOMOREBI_MIDLIFT);
    color = clamp(color, 0.0, 1.0);
    color = komorebi_setSaturation_tm(color, KOMOREBI_SATURATION);
    color = komorebi_pastelCrush_tm(color, KOMOREBI_PASTEL_CRUSH);
    return clamp(color, 0.0, 1.0);
}

#endif
