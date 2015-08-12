//
//  Shaders.h
//  iOBJ
//
//  Created by felipowsky on 20/01/13.
//
//

const char *vertexShaderSource =
"attribute vec4 position;"
"attribute vec2 texture2d;"
"attribute vec4 color;"
"attribute vec3 normal;"
"varying mediump vec2 v_texture2d;"
"varying lowp float v_texture2dEnabled;"
"varying lowp vec4 v_color;"
"uniform mat4 modelViewProjectionMatrix;"
"uniform mat4 lookAtMatrix;"
"uniform mat4 perspectiveMatrix;"
"uniform bool texture2dEnabled;"
"uniform mat3 normalMatrix;"
"uniform bool lightEnabled;"
"uniform vec3 lightPosition;"
""
"void main()"
"{"
"   v_texture2dEnabled = float(texture2dEnabled);"
"   v_texture2d = texture2d;"
"   if (lightEnabled) {"
"       vec3 eyeNormal = normalize(normalMatrix * normal);"
"       float intensity = max(0.0, dot(eyeNormal, normalize(lightPosition)));"
"       v_color = color * intensity;"
"   } else {"
"       v_color = color;"
"   }"
"   gl_PointSize = 5.0;"
"   gl_Position = perspectiveMatrix * lookAtMatrix * modelViewProjectionMatrix * position;"
"}";

const char *fragmentShaderSource =
"varying mediump vec2 v_texture2d;"
"varying lowp float v_texture2dEnabled;"
"varying lowp vec4 v_color;"
"uniform sampler2D s_texture2d;"
""
"void main()"
"{"
"   if (bool(v_texture2dEnabled)) {"
"       gl_FragColor = texture2D(s_texture2d, v_texture2d);"
"   } else {"
"       gl_FragColor = v_color;"
"   }"
"}";