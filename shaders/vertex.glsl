attribute vec4 aVertexPosition;
attribute vec4 aVertexNormal;
attribute vec4 aVertexColor;

uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;
uniform vec4 uTVector;
uniform vec4 uLightDirection;
uniform vec4 uPVector;

uniform float uR1Float;
uniform float uR2Float;
uniform float uR3Float;
uniform float uR4Float;
uniform float uR5Float;
uniform float uR6Float;

uniform bool uMeshBool;
uniform vec4 uMeshColor;

varying vec4 vColor;

////////////////////////////////////////////////////////////////////////////////

vec4 perspective_proj(vec4 per, vec4 pos, float angle) {
  float v1 = per[3] + pos[3];
  float v2 = 1.0 / v1;
  float v3 = angle / 2.0;
  float v4 = 1.0 / tan(v3);
  return vec4(v2*(per[0] + v4*pos[0]), v2*(per[1] + v4*pos[1]), v2*(per[2] + v4*pos[2]), 1.0);
}

////////////////////////////////////////////////////////////////////////////////

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

vec4 mod289(vec4 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0; }

float mod289(float x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0; }

vec4 permute(vec4 x) {
     return mod289(((x*34.0)+1.0)*x);
}

float permute(float x) {
     return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

float taylorInvSqrt(float r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec4 grad4(float j, vec4 ip)
  {
  const vec4 ones = vec4(1.0, 1.0, 1.0, -1.0);
  vec4 p,s;

  p.xyz = floor( fract (vec3(j) * ip.xyz) * 7.0) * ip.z - 1.0;
  p.w = 1.5 - dot(abs(p.xyz), ones.xyz);
  s = vec4(lessThan(p, vec4(0.0)));
  p.xyz = p.xyz + (s.xyz*2.0 - 1.0) * s.www; 

  return p;
  }
            
// (sqrt(5) - 1)/4 = F4, used once below
#define F4 0.309016994374947451

float snoise(vec4 v)
  {
  const vec4  C = vec4( 0.138196601125011,  // (5 - sqrt(5))/20  G4
                        0.276393202250021,  // 2 * G4
                        0.414589803375032,  // 3 * G4
                       -0.447213595499958); // -1 + 4 * G4

// First corner
  vec4 i  = floor(v + dot(v, vec4(F4)) );
  vec4 x0 = v -   i + dot(i, C.xxxx);

// Other corners

// Rank sorting originally contributed by Bill Licea-Kane, AMD (formerly ATI)
  vec4 i0;
  vec3 isX = step( x0.yzw, x0.xxx );
  vec3 isYZ = step( x0.zww, x0.yyz );
//  i0.x = dot( isX, vec3( 1.0 ) );
  i0.x = isX.x + isX.y + isX.z;
  i0.yzw = 1.0 - isX;
//  i0.y += dot( isYZ.xy, vec2( 1.0 ) );
  i0.y += isYZ.x + isYZ.y;
  i0.zw += 1.0 - isYZ.xy;
  i0.z += isYZ.z;
  i0.w += 1.0 - isYZ.z;

  // i0 now contains the unique values 0,1,2,3 in each channel
  vec4 i3 = clamp( i0, 0.0, 1.0 );
  vec4 i2 = clamp( i0-1.0, 0.0, 1.0 );
  vec4 i1 = clamp( i0-2.0, 0.0, 1.0 );

  //  x0 = x0 - 0.0 + 0.0 * C.xxxx
  //  x1 = x0 - i1  + 1.0 * C.xxxx
  //  x2 = x0 - i2  + 2.0 * C.xxxx
  //  x3 = x0 - i3  + 3.0 * C.xxxx
  //  x4 = x0 - 1.0 + 4.0 * C.xxxx
  vec4 x1 = x0 - i1 + C.xxxx;
  vec4 x2 = x0 - i2 + C.yyyy;
  vec4 x3 = x0 - i3 + C.zzzz;
  vec4 x4 = x0 + C.wwww;

// Permutations
  i = mod289(i); 
  float j0 = permute( permute( permute( permute(i.w) + i.z) + i.y) + i.x);
  vec4 j1 = permute( permute( permute( permute (
             i.w + vec4(i1.w, i2.w, i3.w, 1.0 ))
           + i.z + vec4(i1.z, i2.z, i3.z, 1.0 ))
           + i.y + vec4(i1.y, i2.y, i3.y, 1.0 ))
           + i.x + vec4(i1.x, i2.x, i3.x, 1.0 ));

// Gradients: 7x7x6 points over a cube, mapped onto a 4-cross polytope
// 7*7*6 = 294, which is close to the ring size 17*17 = 289.
  vec4 ip = vec4(1.0/294.0, 1.0/49.0, 1.0/7.0, 0.0) ;

  vec4 p0 = grad4(j0,   ip);
  vec4 p1 = grad4(j1.x, ip);
  vec4 p2 = grad4(j1.y, ip);
  vec4 p3 = grad4(j1.z, ip);
  vec4 p4 = grad4(j1.w, ip);

// Normalise gradients
  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;
  p4 *= taylorInvSqrt(dot(p4,p4));

// Mix contributions from the five corners
  vec3 m0 = max(0.6 - vec3(dot(x0,x0), dot(x1,x1), dot(x2,x2)), 0.0);
  vec2 m1 = max(0.6 - vec2(dot(x3,x3), dot(x4,x4)            ), 0.0);
  m0 = m0 * m0;
  m1 = m1 * m1;
  return 49.0 * ( dot(m0*m0, vec3( dot( p0, x0 ), dot( p1, x1 ), dot( p2, x2 )))
               + dot(m1*m1, vec2( dot( p3, x3 ), dot( p4, x4 ) ) ) ) ;

  }

////////////////////////////////////////////////////////////////////////////////

void main(void) {
  


  vec4 normal = rotation(uR1Float, uR2Float, uR3Float, uR4Float, uR5Float, uR6Float, aVertexNormal);

  float intensity1 = max(dot(normal, uLightDirection), 0.0);
  vec4 translated = aVertexPosition + uTVector;
  float intensity2 = max(dot(normal, rescale(uTVector)), 0.0) * mag(uTVector) * 0.1;
  float intensity = intensity1 + intensity2;
  
  vec4 rotated = rotation(uR1Float, uR2Float, uR3Float, uR4Float, uR5Float, uR6Float, translated);
  vec4 relativeToCamera = rotated - uPVector;
  vec4 p = perspective_proj(vec4(0.0, 0.0, 0.0, -1.0), relativeToCamera, 3.0);
  vec4 homogenous3 = vec4(p[0], p[1], p[2], p[3]);

  gl_Position = uPMatrix * uMVMatrix * homogenous3;

  float noise_sample = snoise(20.0*aVertexPosition);

  if (uMeshBool) {
    // vColor = vec4(1.0, 1.0, 1.0, 1.0);
    vColor = vec4(uMeshColor[0]/255.0, uMeshColor[1]/255.0, uMeshColor[2]/255.0, uMeshColor[3]);
  } else {
    // vColor = 0.05*aVertexColor + 0.95*intensity*intensity*aVertexColor;
    vColor = vec4(noise_sample);
    //vColor[3] = 0.75;
  }
  
}
