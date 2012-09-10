//
//  MeshMaterial.h
//  iOBJ
//
//  Created by felipowsky on 09/09/12.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Material.h"
#import "Vertex.h"

@interface MeshMaterial : NSObject

@property (nonatomic, strong) Material *material;
@property (nonatomic, readonly) GLKVector2 *triangleTextures;
@property (nonatomic, readonly) GLuint triangleTexturesLength;

- (id)initWithMaterial:(Material *)material;
- (void)addTriangleTextures:(Vertex[3])textures;

@end
