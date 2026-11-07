#version 120

varying vec2 texcoord;

void main() {
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    gl_Position = ftransform();

    // искажение карты теней: больше точности рядом с игроком
    gl_Position.xy /= length(gl_Position.xy) * 0.9 + 0.1;
}
