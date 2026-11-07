#version 120

// Покрывает блоки, воду, сущности и руку (через fallback в Iris/OptiFine)

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 glcolor;
varying vec3 normal;
varying vec3 shadowPos;

void main() {
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glcolor  = gl_Color;
    normal   = normalize(gl_NormalMatrix * gl_Normal);

    vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
    vec4 feetPos = gbufferModelViewInverse * viewPos;

    // небольшой сдвиг вдоль нормали, чтобы не было «акне» на гранях
    feetPos.xyz += mat3(gbufferModelViewInverse) * normal * 0.06;

    vec4 sp = shadowProjection * (shadowModelView * feetPos);
    sp.xy /= length(sp.xy) * 0.9 + 0.1; // то же искажение, что в shadow.vsh
    shadowPos = sp.xyz * 0.5 + 0.5;

    gl_Position = ftransform();
}
