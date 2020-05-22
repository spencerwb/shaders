#version 150
// ^ Change this to version 130 if you have compatibility issues

//This is a vertex shader. While it is called a "shader" due to outdated conventions, this file
//is used to apply matrix transformations to the arrays of vertex data passed to it.
//Since this code is run on your GPU, each vertex is transformed simultaneously.
//If it were run on your CPU, each vertex would have to be processed in a FOR loop, one at a time.
//This simultaneous transformation allows your program to run much faster, especially when rendering
//geometry with millions of vertices.

uniform mat4 u_Model;       // The matrix that defines the transformation of the
                            // object we're rendering. In this assignment,
                            // this will be the result of traversing your scene graph.

uniform mat3 u_ModelInvTr;  // The inverse transpose of the model matrix.
                            // This allows us to transform the object's normals properly
                            // if the object has been non-uniformly scaled.

uniform mat4 u_View;        // The matrix that defines the camera's transformation.
uniform mat4 u_Proj;        // The matrix that defines the camera's projection.

uniform vec3 u_CamPos;

in vec4 vs_Pos;             // The array of vertex positions passed to the shader

in vec4 vs_Nor;             // The array of vertex normals passed to the shader

in vec2 vs_UV;              // The array of vertex texture coordinates passed to the shader

out vec4 fs_Nor;            // The array of normals that has been transformed by u_ModelInvTr. This is implicitly passed to the fragment shader.
out vec4 fs_LightVec;       // The direction in which our virtual light lies, relative to each vertex. This is implicitly passed to the fragment shader.
out vec2 fs_UV;             // The UV of each vertex. This is implicitly passed to the fragment shader.

out vec3 fs_CamPos;
out vec4 fs_Pos;

void main()
{
    // TODO Homework 4
    fs_UV = vs_UV;    // Pass the vertex UVs to the fragment shader for interpolation

    fs_Nor = normalize(vec4(u_ModelInvTr * vec3(vs_Nor), 0)); // Pass the vertex normals to the fragment shader for interpolation.
                                                              // Transform the geometry's normals by the inverse transpose of the
                                                              // model matrix. This is necessary to ensure the normals remain
                                                              // perpendicular to the surface after the surface is transformed by
                                                              // the model matrix.


    vec4 modelposition = u_Model * vs_Pos;   // Temporarily store the transformed vertex positions for use below

    // fs_CameraPos = inverse(u_View) * vec4(0,0,0,1);
    // the above code was th eoriginal way of calculating the fs_CameraPos;
    // however, the inverse function is a very costly operation so we are just
    // going to always pass the camera position as a uniform from the CPU.

    // u_View is the view matrix from lecture. This matrix can transform
    // coordiantes from world space to camera space when applied on a vector.
    // However, we want the opposite to happen; we want the camera's position in
    // world space. To perform this task, we will use the inverse of the view
    // matrix since that will transform coordinates from camera space to world
    // space. In camera space, the camera is at the origin; this is why we apply
    // the inverse of the view vector onto (0, 0, 0, 1) i.e. the origin of the
    // camera.

    // I'm going to make the final component of the fs_CameraPos vector 1
    // because if it were 0, then translations would have no affect on the
    // vector. This propoerty would be more appropriate for vectors that solely
    // represent directions.
    fs_CamPos = vec3(vec4(u_CamPos,1) - modelposition);

    fs_Pos = modelposition;

    fs_LightVec = vec4(fs_CamPos, 1) - modelposition;  // Compute the direction in which the light source lies

    gl_Position = u_Proj * u_View * modelposition; // gl_Position is a built-in variable of OpenGL which is
                                                   // used to render the final positions of the geometry's vertices
}
