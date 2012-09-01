// This file is generated from text files from GLEW.
// See copyright in src/lib/gl/gl.d (BSD/MIT like).
module lib.gl.core.gl13;

import lib.gl.types;


bool GL_VERSION_1_3;

const GL_TEXTURE0 = 0x84C0;
const GL_TEXTURE1 = 0x84C1;
const GL_TEXTURE2 = 0x84C2;
const GL_TEXTURE3 = 0x84C3;
const GL_TEXTURE4 = 0x84C4;
const GL_TEXTURE5 = 0x84C5;
const GL_TEXTURE6 = 0x84C6;
const GL_TEXTURE7 = 0x84C7;
const GL_TEXTURE8 = 0x84C8;
const GL_TEXTURE9 = 0x84C9;
const GL_TEXTURE10 = 0x84CA;
const GL_TEXTURE11 = 0x84CB;
const GL_TEXTURE12 = 0x84CC;
const GL_TEXTURE13 = 0x84CD;
const GL_TEXTURE14 = 0x84CE;
const GL_TEXTURE15 = 0x84CF;
const GL_TEXTURE16 = 0x84D0;
const GL_TEXTURE17 = 0x84D1;
const GL_TEXTURE18 = 0x84D2;
const GL_TEXTURE19 = 0x84D3;
const GL_TEXTURE20 = 0x84D4;
const GL_TEXTURE21 = 0x84D5;
const GL_TEXTURE22 = 0x84D6;
const GL_TEXTURE23 = 0x84D7;
const GL_TEXTURE24 = 0x84D8;
const GL_TEXTURE25 = 0x84D9;
const GL_TEXTURE26 = 0x84DA;
const GL_TEXTURE27 = 0x84DB;
const GL_TEXTURE28 = 0x84DC;
const GL_TEXTURE29 = 0x84DD;
const GL_TEXTURE30 = 0x84DE;
const GL_TEXTURE31 = 0x84DF;
const GL_ACTIVE_TEXTURE = 0x84E0;
const GL_CLIENT_ACTIVE_TEXTURE = 0x84E1;
const GL_MAX_TEXTURE_UNITS = 0x84E2;
const GL_NORMAL_MAP = 0x8511;
const GL_REFLECTION_MAP = 0x8512;
const GL_TEXTURE_CUBE_MAP = 0x8513;
const GL_TEXTURE_BINDING_CUBE_MAP = 0x8514;
const GL_TEXTURE_CUBE_MAP_POSITIVE_X = 0x8515;
const GL_TEXTURE_CUBE_MAP_NEGATIVE_X = 0x8516;
const GL_TEXTURE_CUBE_MAP_POSITIVE_Y = 0x8517;
const GL_TEXTURE_CUBE_MAP_NEGATIVE_Y = 0x8518;
const GL_TEXTURE_CUBE_MAP_POSITIVE_Z = 0x8519;
const GL_TEXTURE_CUBE_MAP_NEGATIVE_Z = 0x851A;
const GL_PROXY_TEXTURE_CUBE_MAP = 0x851B;
const GL_MAX_CUBE_MAP_TEXTURE_SIZE = 0x851C;
const GL_COMPRESSED_ALPHA = 0x84E9;
const GL_COMPRESSED_LUMINANCE = 0x84EA;
const GL_COMPRESSED_LUMINANCE_ALPHA = 0x84EB;
const GL_COMPRESSED_INTENSITY = 0x84EC;
const GL_COMPRESSED_RGB = 0x84ED;
const GL_COMPRESSED_RGBA = 0x84EE;
const GL_TEXTURE_COMPRESSION_HINT = 0x84EF;
const GL_TEXTURE_COMPRESSED_IMAGE_SIZE = 0x86A0;
const GL_TEXTURE_COMPRESSED = 0x86A1;
const GL_NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2;
const GL_COMPRESSED_TEXTURE_FORMATS = 0x86A3;
const GL_MULTISAMPLE = 0x809D;
const GL_SAMPLE_ALPHA_TO_COVERAGE = 0x809E;
const GL_SAMPLE_ALPHA_TO_ONE = 0x809F;
const GL_SAMPLE_COVERAGE = 0x80A0;
const GL_SAMPLE_BUFFERS = 0x80A8;
const GL_SAMPLES = 0x80A9;
const GL_SAMPLE_COVERAGE_VALUE = 0x80AA;
const GL_SAMPLE_COVERAGE_INVERT = 0x80AB;
const GL_MULTISAMPLE_BIT = 0x20000000;
const GL_TRANSPOSE_MODELVIEW_MATRIX = 0x84E3;
const GL_TRANSPOSE_PROJECTION_MATRIX = 0x84E4;
const GL_TRANSPOSE_TEXTURE_MATRIX = 0x84E5;
const GL_TRANSPOSE_COLOR_MATRIX = 0x84E6;
const GL_COMBINE = 0x8570;
const GL_COMBINE_RGB = 0x8571;
const GL_COMBINE_ALPHA = 0x8572;
const GL_SOURCE0_RGB = 0x8580;
const GL_SOURCE1_RGB = 0x8581;
const GL_SOURCE2_RGB = 0x8582;
const GL_SOURCE0_ALPHA = 0x8588;
const GL_SOURCE1_ALPHA = 0x8589;
const GL_SOURCE2_ALPHA = 0x858A;
const GL_OPERAND0_RGB = 0x8590;
const GL_OPERAND1_RGB = 0x8591;
const GL_OPERAND2_RGB = 0x8592;
const GL_OPERAND0_ALPHA = 0x8598;
const GL_OPERAND1_ALPHA = 0x8599;
const GL_OPERAND2_ALPHA = 0x859A;
const GL_RGB_SCALE = 0x8573;
const GL_ADD_SIGNED = 0x8574;
const GL_INTERPOLATE = 0x8575;
const GL_SUBTRACT = 0x84E7;
const GL_CONSTANT = 0x8576;
const GL_PRIMARY_COLOR = 0x8577;
const GL_PREVIOUS = 0x8578;
const GL_DOT3_RGB = 0x86AE;
const GL_DOT3_RGBA = 0x86AF;
const GL_CLAMP_TO_BORDER = 0x812D;

extern(System):

void function(GLenum texture) glActiveTexture;
void function(GLenum texture) glClientActiveTexture;
void function(GLenum target, GLint level, GLenum initernalformat, GLsizei width, GLint border, GLsizei imageSize, GLvoid *data) glCompressedTexImage1D;
void function(GLenum target, GLint level, GLenum initernalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, GLvoid *data) glCompressedTexImage2D;
void function(GLenum target, GLint level, GLenum initernalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, GLvoid *data) glCompressedTexImage3D;
void function(GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, GLvoid *data) glCompressedTexSubImage1D;
void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, GLvoid *data) glCompressedTexSubImage2D;
void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, GLvoid *data) glCompressedTexSubImage3D;
void function(GLenum target, GLint lod, GLvoid *img) glGetCompressedTexImage;
void function(GLdouble m[16]) glLoadTransposeMatrixd;
void function(GLfloat m[16]) glLoadTransposeMatrixf;
void function(GLdouble m[16]) glMultTransposeMatrixd;
void function(GLfloat m[16]) glMultTransposeMatrixf;
void function(GLenum target, GLdouble s) glMultiTexCoord1d;
void function(GLenum target, GLdouble *v) glMultiTexCoord1dv;
void function(GLenum target, GLfloat s) glMultiTexCoord1f;
void function(GLenum target, GLfloat *v) glMultiTexCoord1fv;
void function(GLenum target, GLint s) glMultiTexCoord1i;
void function(GLenum target, GLint *v) glMultiTexCoord1iv;
void function(GLenum target, GLshort s) glMultiTexCoord1s;
void function(GLenum target, GLshort *v) glMultiTexCoord1sv;
void function(GLenum target, GLdouble s, GLdouble t) glMultiTexCoord2d;
void function(GLenum target, GLdouble *v) glMultiTexCoord2dv;
void function(GLenum target, GLfloat s, GLfloat t) glMultiTexCoord2f;
void function(GLenum target, GLfloat *v) glMultiTexCoord2fv;
void function(GLenum target, GLint s, GLint t) glMultiTexCoord2i;
void function(GLenum target, GLint *v) glMultiTexCoord2iv;
void function(GLenum target, GLshort s, GLshort t) glMultiTexCoord2s;
void function(GLenum target, GLshort *v) glMultiTexCoord2sv;
void function(GLenum target, GLdouble s, GLdouble t, GLdouble r) glMultiTexCoord3d;
void function(GLenum target, GLdouble *v) glMultiTexCoord3dv;
void function(GLenum target, GLfloat s, GLfloat t, GLfloat r) glMultiTexCoord3f;
void function(GLenum target, GLfloat *v) glMultiTexCoord3fv;
void function(GLenum target, GLint s, GLint t, GLint r) glMultiTexCoord3i;
void function(GLenum target, GLint *v) glMultiTexCoord3iv;
void function(GLenum target, GLshort s, GLshort t, GLshort r) glMultiTexCoord3s;
void function(GLenum target, GLshort *v) glMultiTexCoord3sv;
void function(GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q) glMultiTexCoord4d;
void function(GLenum target, GLdouble *v) glMultiTexCoord4dv;
void function(GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q) glMultiTexCoord4f;
void function(GLenum target, GLfloat *v) glMultiTexCoord4fv;
void function(GLenum target, GLint s, GLint t, GLint r, GLint q) glMultiTexCoord4i;
void function(GLenum target, GLint *v) glMultiTexCoord4iv;
void function(GLenum target, GLshort s, GLshort t, GLshort r, GLshort q) glMultiTexCoord4s;
void function(GLenum target, GLshort *v) glMultiTexCoord4sv;
void function(GLclampf value, GLboolean inivert) glSampleCoverage;
