#version 150

uniform mat4 u_Model;
uniform mat3 u_ModelInvTr;
uniform mat4 u_View;
uniform mat4 u_Proj;

uniform int u_Time;

in vec4 vs_Pos;
in vec4 vs_Nor;

out vec3 fs_Pos;
out vec3 fs_Nor;
out float sphereRadius;

float mod289(float x){
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec4 mod289(vec4 x){
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec4 perm(vec4 x){
    return mod289(((x * 34.0) + 1.0) * x);
}


float noise(vec3 p) {
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

//roseate_ruin shader
void main()
{
    // set the radius for the spherical boundary that will limit
    // the vertices' positions
    sphereRadius = 2.f;

    // TODO Homework 4
    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));

    vec4 modelposition = u_Model * vs_Pos;
    fs_Pos = vec3(modelposition);
    float rand = noise(fs_Pos);

    // assuming that Mario is centered at the origin,
    // amplitude
    float a = (sphereRadius - length(modelposition)) / 2.f;
    // periodicity factor
    // the greater the scaling, float literal, the faster the
    // change in vertex position occurs
    float b = 2.f * rand;
    // horizontal offset
    float c = 0.f;
    // vertical offset
    float d = a + sphereRadius - length(modelposition);

    float offset = a * sin(b * (0.01 * u_Time + c)) + d;

    gl_Position = u_Proj * u_View * (modelposition + vec4(offset * fs_Nor, 0));
}

