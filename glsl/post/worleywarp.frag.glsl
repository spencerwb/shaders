#version 150

uniform ivec2 u_Dimensions;
uniform int u_Time;

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

float sideLength = 50.f;

// returns a pseudo-random vec2 with each component in between 0 and 1
vec2 random2(vec2 p)
{
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)),
                dot(p, vec2(269.5,183.3))))
                * 43758.5453);
}

vec3 WorleyNoise(vec2 uv)
{
    uv *= sideLength;
    vec2 uvInt = floor(uv) + vec2(cos(u_Time * 0.000001), sin(u_Time * 0.000001));
    vec2 uvFract = fract(uv);
    float minDist = 1.0;
    vec3 color = vec3(0, 0, 0);
    for (int j = -1; j <= 1; j++)
    {
        for (int i = -1; i <= 1; i++)
        {
            vec2 neighbor = vec2(float(i), float(j));
            // the random point inside the corresponding neighbor's cell
            // every fragment that passes in this cell index will get the same
            // random point inside of the cell
            vec2 point = random2(uvInt + neighbor);
            // neighbor + point moves the rando point into its correct position
            // relative to the uv of the fragment
            vec2 diff = neighbor + point - uvFract;
            float dist = length(diff);
            if (dist < minDist) {
                color = vec3(texture(u_RenderedTexture,
                                     (neighbor + point + uvInt) / sideLength));
            }
            minDist = min(minDist, dist);
        }
    }
    return color;
}



void main()
{
    // TODO Homework 5
    vec3 sampledCol = WorleyNoise(fs_UV);
    color = sampledCol;
}
