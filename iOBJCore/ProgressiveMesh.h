//
//  ProgressiveMesh.h
//  iOBJ
//
//  Created by felipowsky on 10/02/13.
//
//

#import <Foundation/Foundation.h>

@class Mesh;

@interface ProgressiveMesh : NSObject

- (id)initWithMesh:(Mesh *)mesh;
- (Mesh *)generateMeshWithVertices:(NSUInteger)vertices;

@end
