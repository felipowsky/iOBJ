//
//  Texture.m
//  iOBJ
//
//  Created by felipowsky on 09/09/12.
//
//

#import "Texture.h"

@implementation Texture

- (id)initWithTextureInfo:(GLKTextureInfo *)textureInfo meshMaterial:(MeshMaterial *)meshMaterial
{
    self = [super init];
    
    if (self) {
        _textureInfo = textureInfo;
        _meshMaterial = meshMaterial;
    }
    
    return self;
}

@end
