// The Matrix Shader
// the numbers will be of size 5 by 7

#version 150

uniform ivec2 u_Dimensions;
uniform int u_Time;

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

float sideX = u_Dimensions.x / 5.0;
float sideY = u_Dimensions.y / 7.0;

float pixIncX = 1.f / u_Dimensions.x;
float pixIncY = 1.f / u_Dimensions.y;

// determines the density of the  0 / 1
// I like a density of 2
int activity = 5;
// The clarity should be in between 0 and 1
// I like a clarity of 0.1
float clarity = 0.4f;

// truncated 7x7 Gaussian kernel, sigma = 9
float[] kernel = float[](0.000363, 0.001446, 0.002291, 0.001446, 0.000363,
                         0.003676, 0.014662, 0.023226, 0.014662, 0.003676,
                         0.014662, 0.058488, 0.092651, 0.058488, 0.014662,
                         0.023226, 0.092651, 0.146768, 0.092651, 0.023226,
                         0.014662, 0.058488, 0.092651, 0.058488, 0.014662,
                         0.003676, 0.014662, 0.023226, 0.014662, 0.003676,
                         0.000363, 0.001446, 0.002291, 0.001446, 0.000363);

// 0 / 1 bitmap
uint binary[70] = uint[](0, 0, 1, 0, 0,
                         1, 1, 1, 0, 0,
                         0, 0, 1, 0, 0,
                         0, 0, 1, 0, 0,
                         0, 0, 1, 0, 0,
                         0, 0, 1, 0, 0,
                         1, 1, 1, 1, 1,
                         0, 1, 1, 1, 0,
                         1, 1, 0, 0, 1,
                         1, 1, 1, 0, 1,
                         1, 0, 1, 0, 1,
                         1, 0, 1, 1, 1,
                         1, 0, 0, 1, 1,
                         0, 1, 1, 1, 0);


// returns a pseudo-random vec2 with each component in between 0 and 1
vec2 random2(vec2 p)
{
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)),
                dot(p, vec2(269.5,183.3))))
                * 43758.5453);
}

// the matrix shader
vec3 theMatrix(vec2 uv)
{
    vec3 color = vec3(0);
    float lum = 0;

    // uv scaled so that the uv is in the range of [0, number of 0 / 1 that can fit in the x-direx)
    // and [0, number of 0 / 1 that can fit in the y-direx)
    vec2 pixUV = vec2(uv.x * sideX, uv.y * sideY);
    vec2 uvInt = floor(pixUV);
    vec2 uvFract = fract(pixUV);

    // calculating what the illuminance of the 0 / 1 should be based on the
    // fragments encompassed by the 0 / 1
    for (int j = 0; j < 7; j++)
    {
        for (int i = 0; i < 5; i++)
        {
            // perform a gaussian weighted average of all 35 of the fragments
            // within the 0 / 1 cell
            vec2 uvLum = vec2((uvInt.x / sideX) + ((4 - i) * pixIncX), (uvInt.y / sideY) + ((6 - j) * pixIncY));
            vec4 sampledCol = texture(u_RenderedTexture, uvLum);
            float sampledLum = 0.21 * sampledCol.r + 0.72 * sampledCol.g + 0.07 * sampledCol.b;
            lum += (kernel[i + j * 5] * sampledLum);
        }
    }

    lum = clamp(lum, 0, 1);

    // randomly determines if all of the encompassing pixels should become a 0 or 1
    // and handles th eraining binary effect
    vec2 uvVel = random2(vec2(uvInt.x));
    float vel = (uvVel.x + uvVel.y) / 4.f;
    vec2 uvRain = vec2(uvInt.x, uvInt.y + floor(vel * u_Time));
    vec2 randVec2 = random2(uvRain);
    // vec2 randVec2 = random2(uvInt);
    int polarity = int(floor(randVec2.x + randVec2.y));

    // the offset changes as a function of time
    // this offset is supposed to represent the start of a trail
    // randVec2 = random2(randVec2);
    float offset = (randVec2.x + randVec2.y) * sideY * 0.75;
    ivec2 uvBitMask = ivec2(uvFract.x * 5, 7 - uvFract.y * 7);
    // the additional contsant term makes it so that the true illuminence of
    // mario is more evident so that th eimage appears clearer
    float cascading = activity / (pixUV.y - offset) + clarity;

    // another method of creating cascades using exponentials
    // the smaller the contrast the clearer the image
    // float contrast = 0.3;
    // for some reason if you do not scale the pixUV.y by the same amount
    // as the offset parameter in the modulo operator, the cascading effect
    // becomes out of phase
    // cascading = pow(0.5, mod(contrast * pixUV.y - offset, contrast * offset));

    // combine the calculated values to create the correct shade of green
    float green = binary[35 * polarity + (uvBitMask.x + (uvBitMask.y * 5))]
            * lum * cascading;
    green = clamp(green, 0, 1);
    color = vec3(green * 0.459, green, green * 0.620);
    return color;
    // to get the trailing effect randomly apply abs(cos())
}



void main()
{
    // TODO Homework 5
    vec3 matCol = theMatrix(fs_UV);
    color = matCol;
    // to visualize how big the binary numbers will be on the screen
    // color = vec3(abs((floor(mod(fs_UV.y * u_Dimensions.y, 14) / 7)) - (floor(mod(fs_UV.x * u_Dimensions.x, 10) / 5))));
}
