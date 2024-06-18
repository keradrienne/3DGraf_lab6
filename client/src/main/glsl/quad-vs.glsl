#version 300 es

in vec4 vertexPosition;

uniform struct {
  mat4 rayDirMatrix;
  vec3 position;
} camera;

out vec4 rayDir;

void main(void) {
  rayDir = (vertexPosition * camera.rayDirMatrix).xyzw;
  gl_Position = vertexPosition;
  gl_Position.z = 0.999999f;
}