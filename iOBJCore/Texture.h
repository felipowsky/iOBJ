//
//  Texture.h
//  iOBJ
//
//  Created by felipowsky on 09/09/12.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "MeshMaterial.h"

@interface Texture : NSObject

@property (nonatomic, strong, readonly) GLKTextureInfo *textureInfo;
@property (nonatomic, strong, readonly) MeshMaterial *meshMaterial;

- (id)initWithTextureInfo:(GLKTextureInfo *)textureInfo meshMaterial:(MeshMaterial *)meshMaterial;

@end
