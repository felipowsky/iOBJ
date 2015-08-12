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
#import "Face3.h"

@interface MeshMaterial : NSObject

@property (nonatomic, strong) Material *material;
@property (nonatomic, readonly) GLKVector3 *trianglePoints;
@property (nonatomic, readonly) GLuint trianglePointsLength;
@property (nonatomic, readonly) GLKVector2 *triangleTextures;
@property (nonatomic, readonly) GLuint triangleTexturesLength;
@property (nonatomic, readonly) GLKVector3 *triangleNormals;
@property (nonatomic, readonly) GLuint triangleNormalsLength;
@property (nonatomic, readonly) GLKVector4 *triangleColors;
@property (nonatomic, readonly) GLuint triangleColorsLength;

- (id)initWithMaterial:(Material *)material;
- (void)addTrianglesWithFace:(Face3 *)face;

@end
