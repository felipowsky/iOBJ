//
//  Mesh.h
//  iOBJ
//
//  Created by Felipe Imianowsky on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef struct {
    double x;
    double y;
    double z;
} Point3D;

typedef struct {
    double x;
    double y;
    double z;
} Vector3D;

typedef struct {
	Point3D point;
	Vector3D normal;
} Vertex;

typedef struct {
	Vertex vertices[3];
} Face;

@interface Mesh : NSObject

@property (nonatomic, readonly) Point3D *vertices;
@property (nonatomic, readonly) unsigned int verticesLength;
@property (nonatomic, readonly) Vector3D *normals;
@property (nonatomic, readonly) unsigned int normalsLength;
@property (nonatomic, readonly) Face *faces;
@property (nonatomic, readonly) unsigned int facesLength;
@property (nonatomic, readonly) GLKVector3 *triangleVertices;
@property (nonatomic, readonly) unsigned int triangleVerticesLength;

- (id)init;
- (void)addVertex:(Point3D)vertex;
- (void)addNormal:(Vector3D)normal;
- (void)addFace:(Face)face;

@end
