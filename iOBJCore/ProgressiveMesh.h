//
//  ProgressiveMesh.h
//  iOBJ
//
//  Created by felipowsky on 10/02/13.
//
//

#import <Foundation/Foundation.h>
#import "Mesh.h"

@interface ProgressiveMesh : NSObject

- (id)initWithMesh:(Mesh *)mesh;
- (Mesh *)generateMeshWithVertices:(NSUInteger)vertices;

@end
