#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

void main()
{
    // TODO Homework 5
    vec3 imageSample = vec3(texture(u_RenderedTexture, fs_UV));
    // illuminence calculation
    float grey = 0.21 * imageSample.r + 0.72 * imageSample.g + 0.07 * imageSample.b;
    // translate the origin to the center of the image with the top right corner
    // now being (0.5, 0.5) and the bottom left corner being (-0.5, -0.5)
    // take the length of the new uv vector; the farther a fragment is from the
    // image's center, the greater the uv vector becomes
    // this relationship is uniform
    // therefore the longer the vector the darker the fragment should be
    // conveniently, the smaller the grey value, the darker the fragment becomes
    // so I will just subtract the length of the vector from the illuminence so
    // that illuminence becomes darker the farther from the center the fragment
    // becomes
    grey -= length(fs_UV - 0.5);
    // clamp the new illuminence in between 0 and 1
    grey = clamp(grey, 0, 1);

    color = vec3(grey);
}
