//
//  Mesh.h
//  iOBJ
//
//  Created by felipowsky on 03/01/12.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Face3, Vertex;

@interface Mesh : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *points;
@property (nonatomic, strong, readonly) NSMutableArray *normals;
@property (nonatomic, strong, readonly) NSMutableArray *textures;
@property (nonatomic, strong, readonly) NSMutableArray *faces;
@property (nonatomic, strong, readonly) NSDictionary *materials;
@property (nonatomic, readonly) BOOL haveTextures;
@property (nonatomic, readonly) BOOL haveColors;

- (id)init;
- (void)addPoint:(GLKVector3)point;
- (void)addNormal:(GLKVector3)normal;
- (void)addTexture:(GLKVector2)texture;
- (void)addFace:(Face3 *)face;
+ (GLKVector3)flatNormalsWithFace:(Face3 *)face;

@end
