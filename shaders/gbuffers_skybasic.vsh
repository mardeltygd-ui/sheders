#version 120

varying vec4 starData;

void main() {
    gl_Position = ftransform();
    // звёзды — белые квадраты, у неба цвет не «серый»
    starData = vec4(gl_Color.rgb, float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0));
}
