float kSaturate(float value) {
    return clamp(value, 0.0, 1.0);
}

vec3 kSaturate3(vec3 value) {
    return clamp(value, vec3(0.0), vec3(1.0));
}

float kLuma(vec3 color) {
    return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

vec3 kRgb2Hsv(vec3 color) {
    vec4 k = vec4(0.0, -0.3333333, 0.6666667, -1.0);
    vec4 p = mix(vec4(color.bg, k.wz), vec4(color.gb, k.xy), step(color.b, color.g));
    vec4 q = mix(vec4(p.xyw, color.r), vec4(color.r, p.yzx), step(p.x, color.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 kHsv2Rgb(vec3 color) {
    vec4 k = vec4(1.0, 0.6666667, 0.3333333, 3.0);
    vec3 p = abs(fract(color.xxx + k.xyz) * 6.0 - k.www);
    return color.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), color.y);
}

vec3 kBoostSaturation(vec3 color, float amount) {
    vec3 hsv = kRgb2Hsv(max(color, vec3(0.0)));
    hsv.y = clamp(hsv.y * amount, 0.0, 1.0);
    return kHsv2Rgb(hsv);
}

float kCelBands(float diffuse, float bands) {
    float safeBands = max(bands, 2.0);
    float scaled = floor(kSaturate(diffuse) * (safeBands - 1.0) + 0.5);
    return scaled / (safeBands - 1.0);
}

vec3 kAnimeRamp(float value) {
    vec3 dark = vec3(0.102, 0.000, 0.200);
    vec3 mid = vec3(1.000, 0.600, 0.200);
    vec3 bright = vec3(1.000, 1.000, 0.600);
    float lower = smoothstep(0.0, 0.56, value);
    float upper = smoothstep(0.42, 1.0, value);
    return mix(mix(dark, mid, lower), bright, upper);
}

vec3 kCelLight(vec3 color, float cel, float shadowDepth) {
    vec3 coolShadow = color * vec3(0.48, 0.43, 0.68);
    vec3 midTone = color * vec3(0.92, 0.78, 0.68);
    vec3 warmLight = color * vec3(1.14, 1.06, 0.88);
    vec3 ramped = mix(coolShadow, midTone, smoothstep(0.0, 0.62, cel));
    ramped = mix(ramped, warmLight, smoothstep(0.48, 1.0, cel));
    return mix(color, ramped, clamp(shadowDepth, 0.0, 1.0));
}

float kRimFactor(vec3 normal, vec3 viewDirection) {
    float rim = 1.0 - max(dot(normalize(normal), normalize(viewDirection)), 0.0);
    return smoothstep(0.46, 0.94, rim);
}

vec3 kWarmGrade(vec3 color, float warmth) {
    float w = clamp(warmth, 0.0, 1.0);
    vec3 graded = color * vec3(1.0 + 0.25 * w, 1.0 + 0.11 * w, 1.0 - 0.10 * w);
    graded += vec3(0.020, 0.010, 0.000) * w;
    return max(graded, vec3(0.0));
}

vec3 kFinalGrade(vec3 color, float saturation, float warmth) {
    color = kBoostSaturation(color, saturation);
    color = kWarmGrade(color, warmth);
    color = pow(max(color, vec3(0.0)), vec3(0.96));
    return kSaturate3(color);
}
