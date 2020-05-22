#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

// The value 0.009322 was originally in index 5, 5 in the kernel array. This
// value was replaced with th evalue 0.0. It seemed like my bloom
// 11x11 Gaussian kernel, sigma = 9
float kernel[121] = float[](0.006849, 0.007239, 0.007559, 0.007795, 0.007941, 0.00799, 0.007941, 0.007795, 0.007559, 0.007239, 0.006849,
                            0.007239, 0.007653, 0.00799, 0.00824, 0.008394, 0.008446, 0.008394, 0.00824, 0.00799, 0.007653, 0.007239,
                            0.007559, 0.00799, 0.008342, 0.008604, 0.008764, 0.008819, 0.008764, 0.008604, 0.008342, 0.00799, 0.007559,
                            0.007795, 0.00824, 0.008604, 0.008873, 0.009039, 0.009095, 0.009039, 0.008873, 0.008604, 0.00824, 0.007795,
                            0.007941, 0.008394, 0.008764, 0.009039, 0.009208, 0.009265, 0.009208, 0.009039, 0.008764, 0.008394, 0.007941,
                            0.00799, 0.008446, 0.008819, 0.009095, 0.009265, 0.0, 0.009265, 0.009095, 0.008819, 0.008446, 0.00799,
                            0.007941, 0.008394, 0.008764, 0.009039, 0.009208, 0.009265, 0.009208, 0.009039, 0.008764, 0.008394, 0.007941,
                            0.007795, 0.00824, 0.008604, 0.008873, 0.009039, 0.009095, 0.009039, 0.008873, 0.008604, 0.00824, 0.007795,
                            0.007559, 0.00799, 0.008342, 0.008604, 0.008764, 0.008819, 0.008764, 0.008604, 0.008342, 0.00799, 0.007559,
                            0.007239, 0.007653, 0.00799, 0.00824, 0.008394, 0.008446, 0.008394, 0.00824, 0.00799, 0.007653, 0.007239,
                            0.006849, 0.007239, 0.007559, 0.007795, 0.007941, 0.00799, 0.007941, 0.007795, 0.007559, 0.007239, 0.006849);

float pixIncX = 1.f / u_Dimensions.x;
float pixIncY = 1.f / u_Dimensions.y;

float lumThreshold = 0.5;

void main()
{
    // TODO Homework 5
    vec4 bloomCol = vec4(0);
    for (int i = 0; i < 11; i++)
    {
        for (int j = 0; j < 11; j++)
        {
            vec2 pixUV = vec2(fs_UV.x + ((-5 + i) * pixIncX), fs_UV.y + ((-5 + j) * pixIncY));
            vec4 colorSample = texture(u_RenderedTexture, pixUV);
            float illuminance = 0.21 * colorSample.r + 0.72 * colorSample.g + 0.07 * colorSample.b;
            if (illuminance > lumThreshold)
            {
                bloomCol += kernel[i * 11 + j] * colorSample;
            }
        }
    }
    bloomCol += texture(u_RenderedTexture, fs_UV);
    color = vec3(bloomCol);
}
