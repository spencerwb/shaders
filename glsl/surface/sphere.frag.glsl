#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader
uniform int u_Time;

in vec3 fs_Pos;
in vec3 fs_Nor;
in float sphereRadius;

layout(location = 0) out vec3 out_Col;

void main()
{
    // TODO Homework 4
    float r = (sphereRadius - abs(fs_Pos.x)) / sphereRadius;
    float g = (sphereRadius - abs(fs_Pos.y)) / sphereRadius;
    float b = (sphereRadius - abs(fs_Pos.z)) / sphereRadius;

    out_Col = vec3(r, g, b);
}
