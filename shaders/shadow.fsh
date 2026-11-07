#version 120

uniform sampler2D texture;

varying vec2 texcoord;

void main() {
    vec4 c = texture2D(texture, texcoord);
    if (c.a < 0.1) discard; // листва и прозрачные блоки не дают сплошную тень
    gl_FragData[0] = c;
}
