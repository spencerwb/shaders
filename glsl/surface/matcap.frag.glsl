#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec3 fs_Nor;
in vec2 fs_UV;

layout(location = 0) out vec3 out_Col;

void main()
{
    // TODO Homework 4
    // Each normal vector component falls into the range of -1 and 1 inclusive.
    // However, the UV texture components fall into the range of 0 and 1.
    // In order to fit the normal space into the UV space, we perform the
    // following calculations.
    out_Col = vec3(texture(u_Texture, (fs_Nor.xy + 1.f) / 2.f));
}
