//
//  Mesh.h
//  iOBJ
//
//  Created by felipowsky on 03/01/12.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Material.h"
#import "Face.h"
#import "Vertex.h"

@interface Mesh : NSObject

@property (nonatomic, readonly) Point3D *vertices;
@property (nonatomic, readonly) unsigned int verticesLength;
@property (nonatomic, readonly) Vector3D *normals;
@property (nonatomic, readonly) unsigned int normalsLength;
@property (nonatomic, readonly) NSMutableArray *faces;
@property (nonatomic, readonly) unsigned int facesLength;
@property (nonatomic, readonly) GLKVector3 *triangleVertices;
@property (nonatomic, readonly) unsigned int triangleVerticesLength;

- (id)init;
- (void)addVertex:(Point3D)vertex;
- (void)addNormal:(Vector3D)normal;
- (void)addFace:(Face *)face;
+ (Vector3D)flatNormalsWithFace:(Face *)face;

@end
