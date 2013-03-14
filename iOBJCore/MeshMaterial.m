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
        _triangleColors = nil;
        _triangleColorsLength = 0;
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
    [self addTriangleTextures:face.textures];
    
    if (face.material) {
        [self addTriangleColors:face.material];
    }
}

- (void)addTrianglePoints:(NSArray *)vertices
{
    void *newTrianglePoints = nil;
    
    if (!self.trianglePoints) {
        newTrianglePoints = malloc(sizeof(GLKVector3) * 3);
        
    } else {
        newTrianglePoints = realloc(self.trianglePoints, (self.trianglePointsLength+3) * sizeof(GLKVector3));
    }
    
    if (newTrianglePoints) {
        _trianglePoints = (GLKVector3*)newTrianglePoints;
        
        Vertex *vertex0 = [vertices objectAtIndex:0];
        Vertex *vertex1 = [vertices objectAtIndex:1];
        Vertex *vertex2 = [vertices objectAtIndex:2];
        
        self.trianglePoints[self.trianglePointsLength] = vertex0.point;
        self.trianglePoints[self.trianglePointsLength+1] = vertex1.point;
        self.trianglePoints[self.trianglePointsLength+2] = vertex2.point;
        
        _trianglePointsLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle vertices");
    }
#endif
}

- (void)addTriangleTextures:(NSMutableArray *)vertices
{
    void *newTriangleTextures = nil;
    
    if (!self.triangleTextures) {
        newTriangleTextures = malloc(sizeof(GLKVector2) * 3);
        
    } else {
        newTriangleTextures = realloc(self.triangleTextures, (self.triangleTexturesLength+3) * sizeof(GLKVector2));
    }
    
    if (newTriangleTextures) {
        _triangleTextures = (GLKVector2*)newTriangleTextures;
        
        NSValue *textureValue0 = [vertices objectAtIndex:0];
        GLKVector2 texture0;
        [textureValue0 getValue:&texture0];
        
        NSValue *textureValue1 = [vertices objectAtIndex:1];
        GLKVector2 texture1;
        [textureValue1 getValue:&texture1];
        
        NSValue *textureValue2 = [vertices objectAtIndex:2];
        GLKVector2 texture2;
        [textureValue2 getValue:&texture2];
        
        self.triangleTextures[self.triangleTexturesLength] = texture0;
        self.triangleTextures[self.triangleTexturesLength+1] = texture1;
        self.triangleTextures[self.triangleTexturesLength+2] = texture2;
        
        _triangleTexturesLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle textures");
    }
#endif
}

- (void)addTriangleNormals:(NSMutableArray *)vertices
{
    void *newTriangleNormals = nil;
    
    if (!self.triangleNormals) {
        newTriangleNormals = malloc(sizeof(GLKVector3) * 3);
        
    } else {
        newTriangleNormals = realloc(self.triangleNormals, (self.triangleNormalsLength+3) * sizeof(GLKVector3));
    }
    
    if (newTriangleNormals) {
        _triangleNormals = (GLKVector3*)newTriangleNormals;
        
        Vertex *vertex0 = [vertices objectAtIndex:0];
        Vertex *vertex1 = [vertices objectAtIndex:1];
        Vertex *vertex2 = [vertices objectAtIndex:2];
        
        self.triangleNormals[self.triangleNormalsLength] = vertex0.normal;
        self.triangleNormals[self.triangleNormalsLength+1] = vertex1.normal;
        self.triangleNormals[self.triangleNormalsLength+2] = vertex2.normal;
        
        _triangleNormalsLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle normals");
    }
#endif
}

- (void)addTriangleColors:(Material *)material
{
    void *newTriangleColors = nil;
    
    if (!self.triangleColors) {
        newTriangleColors = malloc(sizeof(GLKVector4) * 3);
        
    } else {
        newTriangleColors = realloc(self.triangleColors, (self.triangleColorsLength+3) * sizeof(GLKVector4));
    }
    
    if (newTriangleColors) {
        _triangleColors = (GLKVector4*)newTriangleColors;
        
        for (int i = 0; i < 3; i++) {
            self.triangleColors[self.triangleColorsLength+i] = GLKVector4Make(material.diffuseColor.x, material.diffuseColor.y, material.diffuseColor.z, 1.0f);
        }
        
        _triangleColorsLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle colors");
    }
#endif
}

- (void)dealloc
{
    free(self.trianglePoints);
    free(self.triangleTextures);
    free(self.triangleNormals);
    free(self.triangleColors);
}

@end
