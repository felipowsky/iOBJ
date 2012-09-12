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
#import "MeshMaterial.h"

@interface Mesh : NSObject

@property (nonatomic, readonly) GLKVector3 *points;
@property (nonatomic, readonly) GLuint pointsLength;
@property (nonatomic, readonly) GLKVector3 *normals;
@property (nonatomic, readonly) GLuint normalsLength;
@property (nonatomic, readonly) GLKVector2 *textureCoordinates;
@property (nonatomic, readonly) GLuint textureCoordinatesLength;
@property (nonatomic, readonly) NSMutableArray *faces;
@property (nonatomic, readonly) GLuint facesLength;
@property (nonatomic, readonly) NSDictionary *materials;
@property (nonatomic, readonly) BOOL haveTextures;

- (id)init;
- (void)addPoint:(GLKVector3)point;
- (void)addNormal:(GLKVector3)normal;
- (void)addTextureCoordinate:(GLKVector2)textureCoordinate;
- (void)addFace:(Face3 *)face;
+ (GLKVector3)flatNormalsWithFace:(Face3 *)face;

@end
