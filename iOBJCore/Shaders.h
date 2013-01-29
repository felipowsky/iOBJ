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
"varying mediump vec2 v_texture2d;"
"varying lowp float v_texture2dEnabled;"
"varying lowp vec4 v_color;"
"uniform mat4 modelViewProjectionMatrix;"
"uniform mat4 lookAtMatrix;"
"uniform mat4 perspectiveMatrix;"
"uniform bool texture2dEnabled;"
""
"void main()"
"{"
"   v_texture2dEnabled = float(texture2dEnabled);"
"   v_texture2d = texture2d;"
"   v_color = color;"
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