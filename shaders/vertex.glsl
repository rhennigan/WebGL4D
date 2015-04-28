attribute vec4 aVertexPosition;
attribute vec4 aVertexNormal;
attribute vec4 aVertexColor;
attribute vec2 aTextureCoord;

uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;
uniform vec4 uTVector;
uniform vec4 uLightDirection;
uniform vec4 uPVector;

// 4D rotation angles
uniform float uR1Float;  // xy
uniform float uR2Float;  // xz
uniform float uR3Float;  // xw
uniform float uR4Float;  // yz
uniform float uR5Float;  // yw
uniform float uR6Float;  // zw

uniform bool uMeshBool;
uniform vec4 uMeshColor;

varying vec2 vTextureCoord;
varying vec4 vColor;

////////////////////////////////////////////////////////////////////////////////
// Generated from Mathematica with https://github.com/rhennigan/FactorExpression
vec4 perspective_proj(vec4 per, vec4 pos, float angle) {
  float v1 = per[3] + pos[3];
  float v2 = 1.0 / v1;
  float v3 = angle / 2.0;
  float v4 = 1.0 / tan(v3);
  return vec4(v2*(per[0] + v4*pos[0]), v2*(per[1] + v4*pos[1]), v2*(per[2] + v4*pos[2]), 1.0);
}

////////////////////////////////////////////////////////////////////////////////
// Generated from Mathematica with https://github.com/rhennigan/FactorExpression
vec4 rotation(float t1, float t2, float t3, float t4, float t5, float t6, vec4 pos) {
  float x = pos[0];
  float y = pos[1];
  float z = pos[2];
  float w = pos[3];
  float v1 = cos(t1);
  float v2 = sin(t1);
  float v3 = sin(t2);
  float v4 = cos(t2);
  float v5 = sin(t4);
  float v6 = -v3;
  float v7 = cos(t4);
  float v8 = cos(t5);
  float v9 = sin(t3);
  float v10 = sin(t5);
  float v11 = -v4;
  float v12 = cos(t6);
  float v13 = sin(t6);
  float v14 = v5*v6;
  float v15 = v11*v9;
  float v16 = cos(t3);
  float v17 = v1*v7;
  float v18 = v2*v7;
  float v19 = -v10;
  float v20 = v15*v8;
  float v21 = v1*v14;
  float v22 = -v18;
  float v23 = v21 + v22;
  float v24 = v16*x;
  float v25 = v14*v2;
  float v26 = v17 + v25;
  float v27 = v6*v9;
  float v28 = v24*v4;
  float v29 = v1*v20;
  float v30 = v19*v23;
  float v31 = v29 + v30;
  float v32 = v2*v5;
  float v33 = v17*v6;
  float v34 = v32 + v33;
  float v35 = -v13;
  float v36 = v10*v15;
  float v37 = v2*v20;
  float v38 = v19*v26;
  float v39 = v37 + v38;
  float v40 = -v1;
  float v41 = v40*v5;
  float v42 = v18*v6;
  float v43 = v41 + v42;
  float v44 = v10*v11;
  float v45 = v44*v5;
  float v46 = v27*v8;
  float v47 = v45 + v46;
  float v48 = v16*v8;
  float v49 = v1*v28 + (v12*v31 + v34*v35)*w + (v1*v36 + v23*v8)*y + (v13*v31 + v12*v34)*z;
  float v50 = v2*v28 + (v12*v39 + v35*v43)*w + (v2*v36 + v26*v8)*y + (v13*v39 + v12*v43)*z;
  float v51 = v24*v3 + (v12*v47 + v11*v13*v7)*w + (v10*v27 + v4*v5*v8)*y + (v13*v47 + v12*v4*v7)*z;
  float v52 = v12*v48*w + v9*x + v10*v16*y + v13*v48*z;
  return vec4(v49, v50, v51, v52);
}

////////////////////////////////////////////////////////////////////////////////

vec4 rescale(vec4 v) {
  float n = 1.0 / sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]+ v[3]*v[3]);
  return vec4(n*v[0], n*v[1], n*v[2], n*v[3]);
}

////////////////////////////////////////////////////////////////////////////////

float mag(vec4 v) {
  return sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]+ v[3]*v[3]);
}

////////////////////////////////////////////////////////////////////////////////


void main(void) {

  vTextureCoord = aTextureCoord;

  vec4 normal = rotation(uR1Float, uR2Float, uR3Float, uR4Float, uR5Float, uR6Float, aVertexNormal);
  float intensity = sqrt(max(dot(normal, uLightDirection), 0.0));
  vec4 translated = aVertexPosition + uTVector;
  
  vec4 rotated = rotation(uR1Float, uR2Float, uR3Float, uR4Float, uR5Float, uR6Float, translated);
  vec4 relativeToCamera = rotated - uPVector;

  vec4 p = perspective_proj(vec4(0.0, 0.0, 0.0, -1.0), relativeToCamera, 3.0);
  vec4 homogenous3 = vec4(p[0], p[1], p[2], 1.0);

  gl_Position = uPMatrix * uMVMatrix * homogenous3;

  //intensity = 1.0;
  if (uMeshBool) {
    vColor = vec4(uMeshColor[0]/255.0, uMeshColor[1]/255.0, uMeshColor[2]/255.0, 1.0);
  } else {
    vColor = 0.25*aVertexColor + 0.75*intensity*aVertexColor;
    vColor[3] = intensity;
  }
  
}
