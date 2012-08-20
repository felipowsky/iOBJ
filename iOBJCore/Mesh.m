//
//  Mesh.m
//  iOBJ
//
//  Created by felipowsky on 03/01/12.
//
//

#import "Mesh.h"

@implementation Mesh

- (id)init
{
    self = [super init];
    
    if (self) {
        _vertices = nil;
        _verticesLength = 0;
        _normals = nil;
        _normalsLength = 0;
        _textureCoordinates = nil;
        _textureCoordinatesLength = 0;
        _faces = [[NSMutableArray alloc] init];
        _triangleVertices = nil;
        _triangleVerticesLength = 0;
        _triangleTextures = nil;
        _triangleTexturesLength = 0;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Mesh *copy = [[Mesh allocWithZone:zone] init];
    
    if (self.verticesLength > 0) {
        for (int i = 0; i < self.verticesLength; i++) {
            [copy addVertex:self.vertices[i]];
        }
    }
    
    if (self.normalsLength > 0) {
        for (int i = 0; i < self.normalsLength; i++) {
            [copy addNormal:self.normals[i]];
        }
    }
    
    if (self.textureCoordinatesLength > 0) {
        for (int i = 0; i < self.textureCoordinatesLength; i++) {
            [copy addTextureCoordinate:self.textureCoordinates[i]];
        }
    }
    
    if (self.facesLength > 0) {
        for (Face3 *face in self.faces) {
            [copy addFace:face];
        }
    }
    
    if (self.triangleVerticesLength > 0) {
        for (int i = 0; i < self.triangleVerticesLength; i += 3) {
            GLKVector3 triangleVertex[3];
            
            triangleVertex[0] = self.triangleVertices[i];
            triangleVertex[1] = self.triangleVertices[i+1];
            triangleVertex[2] = self.triangleVertices[i+2];
            
            [copy addTriangleVerticesWithVector3:triangleVertex];
        }
    }
    
    if (self.triangleTexturesLength > 0) {
        for (int i = 0; i < self.triangleTexturesLength; i += 3) {
            GLKVector2 triangleTexture[3];
            
            triangleTexture[0] = self.triangleTextures[i];
            triangleTexture[1] = self.triangleTextures[i+1];
            triangleTexture[2] = self.triangleTextures[i+2];
            
            [copy addTriangleTextures:triangleTexture];
        }
    }
    
    return copy;
}

- (void)addVertex:(GLKVector3)vertex
{
    void *newVertices = nil;
    
    if (!self.vertices) {
        newVertices = malloc(sizeof(GLKVector3));
    
    } else {
        newVertices = realloc(self.vertices, (self.verticesLength+1) * sizeof(GLKVector3));
    }
    
    if (newVertices) {
        _vertices = (GLKVector3*)newVertices;
        self.vertices[self.verticesLength] = vertex;
        _verticesLength++;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to vertices");  
    }
#endif
    
}

- (void)addNormal:(GLKVector3)normal
{
    void *newNormals = nil;
    
    if (!self.normals) {
        newNormals = malloc(sizeof(GLKVector3));
        
    } else {
        newNormals = realloc(self.normals, (self.normalsLength+1) * sizeof(GLKVector3));
    }
    
    if (newNormals) {
        _normals = (GLKVector3*)newNormals;
        self.normals[self.normalsLength] = normal;
        _normalsLength++;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to normals");  
    }
#endif
}

- (void)addTextureCoordinate:(GLKVector2)textureCoordinate
{
    void *newTextureCoordinates = nil;
    
    if (!self.textureCoordinates) {
        newTextureCoordinates = malloc(sizeof(GLKVector2));
        
    } else {
        newTextureCoordinates = realloc(self.textureCoordinates, (self.textureCoordinatesLength+1) * sizeof(GLKVector2));
    }
    
    if (newTextureCoordinates) {
        _textureCoordinates = (GLKVector2*)newTextureCoordinates;
        self.textureCoordinates[self.textureCoordinatesLength] = textureCoordinate;
        _textureCoordinatesLength++;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to texture coordinates");
    }
#endif
}

- (void)addFace:(Face3 *)face
{
    [self.faces addObject:face];
    [self addTriangleVertices:face.vertices];
    
    if (face.textures) {
        [self addTriangleTextures:face.textures];
    }
}

- (void)addTriangleVertices:(Vertex[3])vertices
{
    void *newTriangleVertices = nil;
    
    if (!self.triangleVertices) {
        newTriangleVertices = malloc(sizeof(GLKVector3) * 3);
        
    } else {
        newTriangleVertices = realloc(self.triangleVertices, (self.triangleVerticesLength+3) * sizeof(GLKVector3));
    }
    
    if (newTriangleVertices) {
        _triangleVertices = (GLKVector3*)newTriangleVertices;
        
        GLKVector3 point = vertices[0].point;
        self.triangleVertices[self.triangleVerticesLength] = GLKVector3Make(point.x, point.y, point.z);
        
        point = vertices[1].point;
        self.triangleVertices[self.triangleVerticesLength+1] = GLKVector3Make(point.x, point.y, point.z);
        
        point = vertices[2].point;
        self.triangleVertices[self.triangleVerticesLength+2] = GLKVector3Make(point.x, point.y, point.z);
        
        _triangleVerticesLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle vertices");  
    }
#endif
}

- (void)addTriangleVerticesWithVector3:(GLKVector3[3])vertices
{
    void *newTriangleVertices = nil;
    
    if (!self.triangleVertices) {
        newTriangleVertices = malloc(sizeof(GLKVector3) * 3);
        
    } else {
        newTriangleVertices = realloc(self.triangleVertices, (self.triangleVerticesLength+3) * sizeof(GLKVector3));
    }
    
    if (newTriangleVertices) {
        _triangleVertices = (GLKVector3*)newTriangleVertices;
        self.triangleVertices[self.triangleVerticesLength] = vertices[0];
        self.triangleVertices[self.triangleVerticesLength+1] = vertices[1];
        self.triangleVertices[self.triangleVerticesLength+2] = vertices[2];
        _triangleVerticesLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle vertices");  
    }
#endif
}

- (void)addTriangleTextures:(GLKVector2[3])textures
{
    void *newTriangleTextures = nil;
    
    if (!self.triangleTextures) {
        newTriangleTextures = malloc(sizeof(GLKVector2) * 3);
        
    } else {
        newTriangleTextures = realloc(self.triangleTextures, (self.triangleTexturesLength+3) * sizeof(GLKVector2));
    }
    
    if (newTriangleTextures) {
        _triangleTextures = (GLKVector2*)newTriangleTextures;
        
        GLKVector2 texture = textures[0];
        
        self.triangleTextures[self.triangleTexturesLength] = GLKVector2Make(texture.x, texture.y);
        
        texture = textures[1];
        
        self.triangleTextures[self.triangleTexturesLength+1] = GLKVector2Make(texture.x, texture.y);
        
        texture = textures[2];
        
        self.triangleTextures[self.triangleTexturesLength+2] = GLKVector2Make(texture.x, texture.y);
        
        _triangleTexturesLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle textures");
    }
#endif
}

+ (GLKVector3)flatNormalsWithFace:(Face3 *)face
{
    GLKVector3 side1 = {
        face.vertices[1].point.x - face.vertices[0].point.x,
        face.vertices[1].point.y - face.vertices[0].point.y,
        face.vertices[1].point.z - face.vertices[0].point.z
    };
    
    GLKVector3 side2 = {
        face.vertices[2].point.x - face.vertices[0].point.x,
        face.vertices[2].point.y - face.vertices[0].point.y,
        face.vertices[2].point.z - face.vertices[0].point.z
    };
    
    GLKVector3 normal = {
        side1.y * side2.z - side2.y * side1.z,
        side1.z * side2.x - side2.z * side1.x,
        side1.x * side2.y - side2.x * side1.y
    };
    
    return normal;
}

- (GLuint)getFacesLength
{
    return self.faces.count;
}

- (void)dealloc
{
    if (self.vertices) {
        free(self.vertices);
    }
    
    if (self.normals) {
        free(self.normals);
    }
    
    if (self.textureCoordinates) {
        free(self.textureCoordinates);
    }
    
    if (self.triangleVertices) {
        free(self.triangleVertices);
    }
    
    if (self.triangleTextures) {
        free(self.triangleTextures);
    }
}

@end
