//
//  Face3.m
//  iOBJ
//
//  Created by felipowsky on 09/08/12.
//
//

#import "Face3.h"

@implementation Face3

- (id)init
{
    self = [super init];
    
    if (self) {
        self.vertices = malloc(sizeof(Vertex) * 3);
        self.material = nil;
        _textures = nil;
    }
    
    return self;
}

- (void)addTexture:(GLKVector3)texture atIndex:(GLuint)index
{
    if (!self.textures) {
        _textures = malloc(sizeof(GLKVector3) * 3);
    }
    
    _textures[index] = GLKVector3Make(texture.x, texture.y, texture.z);
}

- (void)dealloc
{
    if (self.vertices) {
        free(self.vertices);
    }
    
    if (self.textures) {
        free(self.textures);
    }
}

@end
