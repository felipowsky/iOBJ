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
        _points = nil;
        _pointsLength = 0;
        _normals = nil;
        _normalsLength = 0;
        _textureCoordinates = nil;
        _textureCoordinatesLength = 0;
        _faces = [[NSMutableArray alloc] init];
        _trianglePoints = nil;
        _trianglePointsLength = 0;
        _triangleTextures = nil;
        _triangleTexturesLength = 0;
        _triangleNormals = nil;
        _triangleNormalsLength = 0;
        _materials = [[NSDictionary alloc] init];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Mesh *copy = [[Mesh allocWithZone:zone] init];
    
    if (self.pointsLength > 0) {
        for (int i = 0; i < self.pointsLength; i++) {
            [copy addPoint:self.points[i]];
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
    
    if (self.trianglePointsLength > 0) {
        for (int i = 0; i < self.trianglePointsLength; i += 3) {
            GLKVector3 trianglePoint[3];
            
            trianglePoint[0] = self.trianglePoints[i];
            trianglePoint[1] = self.trianglePoints[i+1];
            trianglePoint[2] = self.trianglePoints[i+2];
            
            [copy addTrianglePointsWithVector3:trianglePoint];
        }
    }
    
    if (self.triangleTexturesLength > 0) {
        for (int i = 0; i < self.triangleTexturesLength; i += 3) {
            GLKVector2 triangleTexture[3];
            
            triangleTexture[0] = self.triangleTextures[i];
            triangleTexture[1] = self.triangleTextures[i+1];
            triangleTexture[2] = self.triangleTextures[i+2];
            
            [copy addTriangleTexturesWithVector2:triangleTexture];
        }
    }
    
    if (self.triangleNormalsLength > 0) {
        for (int i = 0; i < self.triangleNormalsLength; i += 3) {
            GLKVector3 triangleNormal[3];
            
            triangleNormal[0] = self.triangleNormals[i];
            triangleNormal[1] = self.triangleNormals[i+1];
            triangleNormal[2] = self.triangleNormals[i+2];
            
            [copy addTriangleNormalsWithVector3:triangleNormal];
        }
    }
    
    copy.materials = [NSDictionary dictionaryWithDictionary:self.materials];
    
    return copy;
}

- (void)addPoint:(GLKVector3)point
{
    void *newPoints = nil;
    
    if (!self.points) {
        newPoints = malloc(sizeof(GLKVector3));
    
    } else {
        newPoints = realloc(self.points, (self.pointsLength+1) * sizeof(GLKVector3));
    }
    
    if (newPoints) {
        _points = (GLKVector3*)newPoints;
        self.points[self.pointsLength] = point;
        _pointsLength++;
        
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
    
    [self addTrianglePoints:face.vertices];
    [self addTriangleNormals:face.vertices];
    [self addTriangleTextures:face.vertices];
}

- (void)addTrianglePoints:(Vertex[3])vertices
{
    void *newTrianglePoints = nil;
    
    if (!self.trianglePoints) {
        newTrianglePoints = malloc(sizeof(GLKVector3) * 3);
        
    } else {
        newTrianglePoints = realloc(self.trianglePoints, (self.trianglePointsLength+3) * sizeof(GLKVector3));
    }
    
    if (newTrianglePoints) {
        _trianglePoints = (GLKVector3*)newTrianglePoints;
        
        GLKVector3 point = vertices[0].point;
        self.trianglePoints[self.trianglePointsLength] = GLKVector3Make(point.x, point.y, point.z);
        
        point = vertices[1].point;
        self.trianglePoints[self.trianglePointsLength+1] = GLKVector3Make(point.x, point.y, point.z);
        
        point = vertices[2].point;
        self.trianglePoints[self.trianglePointsLength+2] = GLKVector3Make(point.x, point.y, point.z);
        
        _trianglePointsLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle vertices");  
    }
#endif
}

- (void)addTrianglePointsWithVector3:(GLKVector3[3])points
{
    void *newTrianglePoints = nil;
    
    if (!self.trianglePoints) {
        newTrianglePoints = malloc(sizeof(GLKVector3) * 3);
        
    } else {
        newTrianglePoints = realloc(self.trianglePoints, (self.trianglePointsLength+3) * sizeof(GLKVector3));
    }
    
    if (newTrianglePoints) {
        _trianglePoints = (GLKVector3*)newTrianglePoints;
        self.trianglePoints[self.trianglePointsLength] = points[0];
        self.trianglePoints[self.trianglePointsLength+1] = points[1];
        self.trianglePoints[self.trianglePointsLength+2] = points[2];
        _trianglePointsLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle vertices");  
    }
#endif
}

- (void)addTriangleTextures:(Vertex[3])textures
{
    void *newTriangleTextures = nil;
    
    if (!self.triangleTextures) {
        newTriangleTextures = malloc(sizeof(GLKVector2) * 3);
        
    } else {
        newTriangleTextures = realloc(self.triangleTextures, (self.triangleTexturesLength+3) * sizeof(GLKVector2));
    }
    
    if (newTriangleTextures) {
        _triangleTextures = (GLKVector2*)newTriangleTextures;
        
        GLKVector2 texture = textures[0].texture;
        
        self.triangleTextures[self.triangleTexturesLength] = GLKVector2Make(texture.x, texture.y);
        
        texture = textures[1].texture;
        
        self.triangleTextures[self.triangleTexturesLength+1] = GLKVector2Make(texture.x, texture.y);
        
        texture = textures[2].texture;
        
        self.triangleTextures[self.triangleTexturesLength+2] = GLKVector2Make(texture.x, texture.y);
        
        _triangleTexturesLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle textures");
    }
#endif
}

- (void)addTriangleTexturesWithVector2:(GLKVector2[3])textures
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

- (void)addTriangleNormals:(Vertex[3])vertices
{
    void *newTriangleNormals = nil;
    
    if (!self.triangleNormals) {
        newTriangleNormals = malloc(sizeof(GLKVector3) * 3);
        
    } else {
        newTriangleNormals = realloc(self.triangleNormals, (self.triangleNormalsLength+3) * sizeof(GLKVector3));
    }
    
    if (newTriangleNormals) {
        _triangleNormals = (GLKVector3*)newTriangleNormals;
        
        GLKVector3 normal = vertices[0].normal;
        self.triangleNormals[self.triangleNormalsLength] = GLKVector3Make(normal.x, normal.y, normal.z);
        
        normal = vertices[1].normal;
        self.triangleNormals[self.triangleNormalsLength+1] = GLKVector3Make(normal.x, normal.y, normal.z);
        
        normal = vertices[2].normal;
        self.triangleNormals[self.triangleNormalsLength+2] = GLKVector3Make(normal.x, normal.y, normal.z);
        
        _triangleNormalsLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle normals");
    }
#endif
}

- (void)addTriangleNormalsWithVector3:(GLKVector3[3])normals
{
    void *newTriangleNormals = nil;
    
    if (!self.triangleNormals) {
        newTriangleNormals = malloc(sizeof(GLKVector3) * 3);
        
    } else {
        newTriangleNormals = realloc(self.triangleNormals, (self.triangleNormalsLength+3) * sizeof(GLKVector3));
    }
    
    if (newTriangleNormals) {
        _triangleNormals = (GLKVector3*)newTriangleNormals;
        self.triangleNormals[self.triangleNormalsLength] = normals[0];
        self.triangleNormals[self.triangleNormalsLength+1] = normals[1];
        self.triangleNormals[self.triangleNormalsLength+2] = normals[2];
        _triangleNormalsLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle normals");
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
    if (self.points) {
        free(self.points);
    }
    
    if (self.normals) {
        free(self.normals);
    }
    
    if (self.textureCoordinates) {
        free(self.textureCoordinates);
    }
    
    if (self.trianglePoints) {
        free(self.trianglePoints);
    }
    
    if (self.triangleTextures) {
        free(self.triangleTextures);
    }
}

@end
