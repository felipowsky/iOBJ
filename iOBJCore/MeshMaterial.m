//
//  MeshMaterial.m
//  iOBJ
//
//  Created by felipowsky on 09/09/12.
//
//

#import "MeshMaterial.h"

@implementation MeshMaterial

- (id)init
{
    self = [super init];
    
    if (self) {
        self.material = nil;
        _trianglePoints = nil;
        _trianglePointsLength = 0;
        _triangleTextures = nil;
        _triangleTexturesLength = 0;
        _triangleNormals = nil;
        _triangleNormalsLength = 0;
    }
    
    return self;
}

- (id)initWithMaterial:(Material *)material
{
    self = [super init];
    
    if (self) {
        self.material = material;
        _trianglePoints = nil;
        _trianglePointsLength = 0;
        _triangleTextures = nil;
        _triangleTexturesLength = 0;
        _triangleNormals = nil;
        _triangleNormalsLength = 0;
    }
    
    return self;
}

- (void)addTrianglesWithFace:(Face3 *)face
{
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

- (void)dealloc
{
    if (self.trianglePoints) {
        free(self.trianglePoints);
    }
    
    if (self.triangleTextures) {
        free(self.triangleTextures);
    }
    
    if (self.triangleNormals) {
        free(self.triangleNormals);
    }
}

@end
