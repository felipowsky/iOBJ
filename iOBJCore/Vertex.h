//
//  Vertex.h
//  iOBJ
//
//  Created by felipowsky on 09/08/12.
//
//

#import <GLKit/GLKit.h>

@class Face3;

@interface Vertex : NSObject

@property (nonatomic) GLKVector3 point;
@property (nonatomic) int pointIndex;
@property (nonatomic) GLKVector2 texture;
@property (nonatomic) int textureIndex;
@property (nonatomic) GLKVector3 normal;
@property (nonatomic) int normalIndex;
@property (nonatomic, strong) NSMutableArray *neighbors;
@property (nonatomic, strong) NSMutableArray *faces;
@property (nonatomic, weak) Vertex *collapse;
@property (nonatomic) float objdist;

- (void)addFaceUnique:(Face3 *)face;
- (void)addNeighborUnique:(Vertex *)vertex;
- (void)computeEdgeCost;
- (void)cleanNeighbors;
- (void)removeIfNonNeighbor:(Vertex *)vertex;

@end;
