#version 120

// ---- Лучи солнца (god rays), лайт ----
#define RAY_SAMPLES 10
#define RAY_STRENGTH 0.45
#define RAY_DENSITY 0.85
#define RAY_DECAY 0.93

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform mat4 gbufferProjection;
uniform vec3 sunPosition;
uniform float sunAngle;
uniform float rainStrength;

varying vec2 texcoord;

void main() {
    vec3 color = texture2D(colortex0, texcoord).rgb;

    // лучи только днём и когда солнце впереди камеры
    bool day = sunAngle < 0.5;
    vec3 sunDir = normalize(sunPosition);

    if (day && sunDir.z < 0.0) {
        vec4 sp = gbufferProjection * vec4(sunPosition, 1.0);
        vec2 sunScreen = sp.xy / sp.w * 0.5 + 0.5;

        vec2 delta = (sunScreen - texcoord) * (RAY_DENSITY / float(RAY_SAMPLES));
        float jitter = fract(sin(dot(gl_FragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453);
        vec2 uv = texcoord + delta * jitter;

        float sum = 0.0;
        float weight = 1.0;
        for (int i = 0; i < RAY_SAMPLES; i++) {
            uv += delta;
            // свет проходит только через небо (глубина = 1.0), блоки и облака его перекрывают
            sum += step(1.0, texture2D(depthtex0, uv).r) * weight;
            weight *= RAY_DECAY;
        }
        sum /= float(RAY_SAMPLES);

        float facing = pow(clamp(-sunDir.z, 0.0, 1.0), 3.0); // сильнее, когда смотришь на солнце
        float rays = sum * facing * RAY_STRENGTH * (1.0 - rainStrength);

        color += vec3(1.0, 0.86, 0.6) * rays;
    }

    gl_FragData[0] = vec4(color, 1.0);
}
