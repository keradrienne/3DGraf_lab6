#version 300 es

precision highp float;

out vec4 fragmentColor;

uniform struct{
  samplerCube environment;
  sampler2D noiseTexture;
} material;

uniform struct {
  mat4 rayDirMatrix;
  vec3 position;
} camera;

in vec4 rayDir;

float noise(vec3 r) {
  uvec3 s = uvec3(
    0x1D4E1D4E,
    0x58F958F9,
    0x129F129F);
  float f = 0.0;
  for(int i=0; i<16; i++) {
    vec3 sf =
    vec3(s & uvec3(0xFFFF))
    / 65536.0 - vec3(0.5, 0.5, 0.5);

    f += sin(dot(sf, r));
    s = s >> 1;
  }
  return f / 32.0 + 0.5;
}

vec3 noiseGrad(vec3 r) {
  uvec3 s = uvec3(
    0x1D4E1D4E,
    0x58F958F9,
    0x129F129F);
  vec3 f = vec3(0, 0, 0);
  for(int i=0; i<16; i++) {
    vec3 sf =
    vec3(s & uvec3(0xFFFF))
    / 65536.0 - vec3(0.5, 0.5, 0.5);

    f += cos(dot(sf, r)) * sf;
    s = s >> 1;
  }
  return f;
}

float f(vec3 p){
  return p.y - noise(p * 50.0);
}

vec3 fGrad(vec3 p){
  return vec3(0, 1, 0) - noiseGrad(p * 50.0);
}

void main(void) {
  vec3 d = normalize(rayDir.xyz);
  //where does the radius intersect the y=1 plane?
  float t1 = (1.0 - camera.position.y) / d.y;
  //where does the radius intersect the y=0 plane?
  float t2 = -camera.position.y / d.y;
  float tstart = max(min(t1, t2), 0.0);
  float tend = max(t1, t2);
  bool found = false;
  vec3 p;
  vec3 color = vec3(1.0, 0.0, 1.0);
  vec3 prevStep;

  //mitigation
  float szigma = 0.3;
  //source
  float q = 0.3;
  //distance
  float dist;

  if(tstart < tend) {
    p = camera.position + d * tstart;
    vec3 step = d * min((tend - tstart)/580.0, 0.01);
    for (int i = 0; i < 128; i++) {
      step *= 1.02;
       p += step;
       if (f(p) < 0.0) {
         for (int j = 0; j < 16; j++) {
           step *= 0.5;
           if (f(p) > 0.0) {
             p += step;
           }
           else {
             p -= step;
           }
         }
         found = true;
         break;
       }
    }
  }

  if(found) {
    float dist = length(p - camera.position);
    color += fGrad(p) * exp(-szigma * dist) + (q * (1.0 - exp(-szigma * dist) / szigma));
  }
  else {
    color += fGrad(p) * exp(-szigma * 9999.0) + (q * (1.0 - exp(-szigma * 9999.0) / szigma));
  }

  fragmentColor = vec4(normalize(color), 1.0);
}
