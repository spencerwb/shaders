#version 150

uniform mat4 u_Model;
uniform mat3 u_ModelInvTr;
uniform mat4 u_View;
uniform mat4 u_Proj;

in vec4 vs_Pos;
in vec4 vs_Nor;

out vec3 fs_Nor;
out vec3 fs_LightVec;

void main()
{
    // TODO Homework 4
    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));

    fs_LightVec = vec3(0, 0, 1);

    vec4 modelposition = u_Model * vs_Pos;

    gl_Position = u_Proj * u_View * modelposition;
}
