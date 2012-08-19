//
//  Mesh.h
//  iOBJ
//
//  Created by felipowsky on 03/01/12.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Face3.h"
#import "Material.h"

@interface Mesh : NSObject

@property (nonatomic, readonly) GLKVector3 *vertices;
@property (nonatomic, readonly) GLuint verticesLength;
@property (nonatomic, readonly) GLKVector3 *normals;
@property (nonatomic, readonly) GLuint normalsLength;
@property (nonatomic, readonly) GLKVector3 *textureCoordinates;
@property (nonatomic, readonly) GLuint textureCoordinatesLength;
@property (nonatomic, readonly) NSMutableArray *faces;
@property (nonatomic, readonly) GLuint facesLength;
@property (nonatomic, readonly) GLKVector3 *triangleVertices;
@property (nonatomic, readonly) GLuint triangleVerticesLength;
@property (nonatomic, readonly) GLKVector3 *triangleTextures;
@property (nonatomic, readonly) GLuint triangleTexturesLength;

- (id)init;
- (void)addVertex:(GLKVector3)vertex;
- (void)addNormal:(GLKVector3)normal;
- (void)addTextureCoordinate:(GLKVector3)textureCoordinate;
- (void)addFace:(Face3 *)face;
+ (GLKVector3)flatNormalsWithFace:(Face3 *)face;

@end
