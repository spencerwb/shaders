#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec3 fs_Nor;
in vec3 fs_LightVec;

layout(location = 0) out vec3 out_Col;

vec3 palette(vec3 a, vec3 b, vec3 c, vec3 d, float t) {
    return a + b * cos( 6.28318 * (c * t + d) );
}

void main()
{
    // TODO Homework 4
    vec3 a = vec3(0.5f);
    vec3 b = vec3(0.5f);
    vec3 c = vec3(1.f);
    vec3 d = vec3(0.f, 0.33f, 0.67f);

    // Calculate the diffuse term (a.k.a. Lambertian dot product)
    // this code was taken directly from teh Lambert Fragment Shader
    float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
    // Avoid negative lighting values
    diffuseTerm = clamp(diffuseTerm, 0, 1);

    out_Col = palette(a, b, c, d, diffuseTerm);
}
