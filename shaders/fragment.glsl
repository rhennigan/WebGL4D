precision mediump float;

varying vec2 vTextureCoord;
varying vec4 vColor;

uniform sampler2D uSampler;

void main(void) {
  vec4 texelColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
  gl_FragColor = 0.5*vColor[3]*vec4(texelColor.rgb, texelColor.a) + 0.5*vColor[3]*vColor;
  gl_FragColor[3] = texelColor.a;
}