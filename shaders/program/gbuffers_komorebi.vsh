varying vec2 texcoord;
varying vec4 vertexColor;
varying vec3 viewNormal;
varying vec3 viewPosition;

void main() {
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    vertexColor = gl_Color;
    viewNormal = normalize(gl_NormalMatrix * gl_Normal);

    vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
    viewPosition = viewPos.xyz;
    gl_Position = gl_ProjectionMatrix * viewPos;
}
