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
        _materials = [[NSDictionary alloc] init];
        _haveTextures = NO;
    }
    
    return self;
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
    
    [self addTrianglesWithFace:face];
}

- (void)addTrianglesWithFace:(Face3 *)face
{
    // default key
    NSString *key = @"";
    
    if (face.material) {
        key = face.material.name;
    }
    
    MeshMaterial *meshMaterial = [self.materials objectForKey:key];
    
    if (!meshMaterial) {
        meshMaterial = [[MeshMaterial alloc] initWithMaterial:face.material];
        
        NSMutableDictionary *newMaterials = [NSMutableDictionary dictionaryWithDictionary:self.materials];
        [newMaterials setObject:meshMaterial forKey:key];
        
        _materials = [NSDictionary dictionaryWithDictionary:newMaterials];
        
        if (face.material.haveTexture) {
            _haveTextures = YES;
        }
    }
    
    [meshMaterial addTrianglesWithFace:face];
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
}

@end
