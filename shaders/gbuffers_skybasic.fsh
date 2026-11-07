#version 120

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform float viewWidth;
uniform float viewHeight;
uniform vec3 skyColor;
uniform vec3 fogColor; // используем только как цвет горизонта, тумана нет

varying vec4 starData;

void main() {
    if (starData.a > 0.5) {
        gl_FragData[0] = vec4(starData.rgb, 1.0);
        return;
    }

    vec4 p = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
    p = gbufferProjectionInverse * p;
    vec3 dir = normalize(p.xyz / p.w);

    vec3 up = normalize(gbufferModelView[1].xyz);
    float h = clamp(dot(dir, up), 0.0, 1.0);

    // плавный градиент: горизонт -> зенит
    vec3 sky = mix(fogColor, skyColor, smoothstep(0.0, 0.45, h));
    gl_FragData[0] = vec4(sky, 1.0);
}
