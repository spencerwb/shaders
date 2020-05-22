#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

// if looking at colors horizontally in the kernel,
//      if the colors are the same, then they'll cancel out with each other
//      if they are different, then they at least won't cancel
float[] horizKernel = float[](3,  0, -3,
                              10, 0, -10,
                              3,  0, -3);

float[] vertKernel = float[]( 3,  10,  3,
                              0,   0,  0,
                             -3, -10, -3);

float pixIncX = 1.f / u_Dimensions.x;
float pixIncY = 1.f / u_Dimensions.y;

void main()
{
    // TODO Homework 5
    vec4 horizGrad = vec4(0);
    vec4 vertGrad = vec4(0);

    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            vec2 pixUV = vec2(fs_UV.x - i * pixIncX, fs_UV.y - j * pixIncY);
            vec4 sampledCol = texture(u_RenderedTexture, pixUV);
            horizGrad += horizKernel[i * 3 + j] * sampledCol;
            vertGrad += vertKernel[i * 3 + j] * sampledCol;
        }
    }

    // the sign of the gradient tells you th epolarity of th edge, so combining
    // the gradients like this allows for the negative gradients to contribute
    // along with the horizontal gradient to the color of the edge
    color = vec3(sqrt(horizGrad * horizGrad + vertGrad * vertGrad));
}
