#version 120

// ---- Настройки (лайт-версия) ----
const int   shadowMapResolution = 512;   // меньше = быстрее
const float shadowDistance      = 40.0;
const float sunPathRotation     = -20.0; // наклон солнца, чтобы тени были не строго вниз

#define SHADOW_STRENGTH 0.35 // 0.0 = без теней, 1.0 = очень тёмные

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform sampler2D shadowtex0;
uniform vec3 shadowLightPosition;
uniform vec4 entityColor;

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 glcolor;
varying vec3 normal;
varying vec3 shadowPos;

float lit(vec2 uv, float z) {
    return step(z, texture2D(shadowtex0, uv).r);
}

void main() {
    vec4 albedo = texture2D(texture, texcoord) * glcolor;
    albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);

    vec3 n = normalize(normal);
    float ndl = dot(n, normalize(shadowLightPosition));

    float shadow = 1.0;
    vec3 sc = shadowPos;

    // тени считаем только там, где есть небесный свет и грань смотрит на солнце
    if (ndl > 0.0 && lmcoord.y > 0.3 && sc.x > 0.0 && sc.x < 1.0 && sc.y > 0.0 && sc.y < 1.0 && sc.z < 1.0) {
        float z = sc.z - 0.001;
        float t = 1.0 / float(shadowMapResolution);
        // всего 2 выборки по диагонали — мягкие края почти бесплатно
        shadow = 0.5 * (lit(sc.xy + vec2( t,  t), z)
                      + lit(sc.xy + vec2(-t, -t), z));
    }

    // грани, повёрнутые от солнца, тоже слегка затеняются
    float sunLight = shadow * smoothstep(0.0, 0.25, ndl);
    sunLight = mix(1.0, sunLight, lmcoord.y); // в пещерах тени не нужны

    float shade = 1.0 - SHADOW_STRENGTH * (1.0 - sunLight);
    vec3 shadeColor = mix(vec3(0.80, 0.85, 1.0), vec3(1.0), sunLight); // чуть холоднее в тени

    vec3 lm = texture2D(lightmap, lmcoord).rgb;

    gl_FragData[0] = vec4(albedo.rgb * lm * shade * shadeColor, albedo.a);
}
