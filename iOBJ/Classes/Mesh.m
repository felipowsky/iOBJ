//
//  Mesh.m
//  iOBJ
//
//  Created by felipowsky on 03/01/12.
//
//

#import "Mesh.h"
#import "Face3.h"
#import "Material.h"
#import "MeshMaterial.h"

@implementation Mesh

- (id)init
{
    self = [super init];
    
    if (self) {
        _points = [[NSMutableArray alloc] init];
        _normals = [[NSMutableArray alloc] init];
        _textures = [[NSMutableArray alloc] init];
        _faces = [[NSMutableArray alloc] init];
        _materials = [[NSDictionary alloc] init];
        _haveTextures = NO;
        _haveColors = NO;
    }
    
    return self;
}

- (void)addPoint:(GLKVector3)point
{
    NSValue *value = [NSValue value:&point withObjCType:@encode(GLKVector3)];
    [self.points addObject:value];
}

- (void)addNormal:(GLKVector3)normal
{
    NSValue *value = [NSValue value:&normal withObjCType:@encode(GLKVector3)];
    [self.normals addObject:value];
}

- (void)addTexture:(GLKVector2)texture
{
    NSValue *value = [NSValue value:&texture withObjCType:@encode(GLKVector2)];
    [self.textures addObject:value];
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
        
        _haveColors = YES;
        
        if (face.material.haveTexture) {
            _haveTextures = YES;
        }
    }
    
    [meshMaterial addTrianglesWithFace:face];
}

+ (GLKVector3)flatNormalsWithFace:(Face3 *)face
{
    Vertex *vertex0 = [face.vertices objectAtIndex:0];
    Vertex *vertex1 = [face.vertices objectAtIndex:1];
    Vertex *vertex2 = [face.vertices objectAtIndex:2];
    
    GLKVector3 side1 = GLKVector3Subtract(vertex1.point, vertex0.point);
    GLKVector3 side2 = GLKVector3Subtract(vertex2.point, vertex1.point);
    
    GLKVector3 normal = GLKVector3CrossProduct(side1, side2);
    
    return normal;
}

@end
