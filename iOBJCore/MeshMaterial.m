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
        _triangleTextures = nil;
        _triangleTexturesLength = 0;
    }
    
    return self;
}

- (id)initWithMaterial:(Material *)material
{
    self = [super init];
    
    if (self) {
        self.material = material;
        _triangleTextures = nil;
        _triangleTexturesLength = 0;
    }
    
    return self;
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

@end
