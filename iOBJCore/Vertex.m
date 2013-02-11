//
//  Vertex.m
//  iOBJ
//
//  Created by felipowsky on 10/02/13.
//
//

#import "Vertex.h"
#import "Face3.h"
#import "NSMutableArray+Additions.h"

@implementation Vertex

- (id)init
{
    self = [super init];
    
    if (self) {
        self.neighbors = [[NSMutableArray alloc] init];
        self.faces = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addFaceUnique:(Face3 *)face
{
    [self.faces addUniqueObject:face];
}

- (void)addNeighborUnique:(Vertex *)vertex
{
    [self.neighbors addUniqueObject:vertex];
}

- (void)computeEdgeCost
{
	// compute the edge collapse cost for all edges that start
	// from this vertex. Since we are only interested in reducing
	// the object by selecting the min cost edge at each step, we
	// only cache the cost of the least cost edge at this vertex
	// (in variable collapse) as well as the value of the
	// cost (in variable objdist).
	
    if (self.neighbors.count == 0) {
		// v doesn't have neighbors so it costs nothing to collapse
        self.collapse = nil;
		self.objdist = -0.01f;

	} else {
        self.objdist = 1000000.0f;
        self.collapse = nil;
        
        // search all neighboring edges for "least cost" edge
        for (Vertex *neighbor in self.neighbors) {
            float dist = [self computeEdgeCollapseCost:self v:neighbor];
            
            if (dist < self.objdist) {
                 // candidate for edge collapse
                self.collapse = neighbor;
                
                // cost of the collapse
                self.objdist = dist;
            }
        }
    }
}

- (float)computeEdgeCollapseCost:(Vertex *)u v:(Vertex *)v
{
	// if we collapse edge uv by moving u to v then how
	// much different will the model change, i.e. how much "error".
	// Texture, vertex normal, and border vertex code was removed
	// to keep this demo as simple as possible.
	// The method of determining cost was designed in order
	// to exploit small and coplanar regions for
	// effective polygon reduction.
	// Is is possible to add some checks here to see if "folds"
	// would be generated.  i.e. normal of a remaining face gets
	// flipped.  I never seemed to run into this problem and
	// therefore never added code to detect this case.
    GLKVector3 diff = GLKVector3Subtract(v.point, u.point);
    
	float edgelength = [self magnitudeWithGLKVector3:diff];
	float curvature = 0;
    
	// find the "sides" triangles that are on the edge uv
    NSMutableArray *sides = [[NSMutableArray alloc] init];
    
	for (Face3 *face in u.faces) {
		if ([face hasVertex:v]) {
			[sides addObject:face];
		}
	}
    
	// use the triangle facing most away from the sides
	// to determine our curvature term
	for (Face3 *face in u.faces) {
        // curve for face i and closer side to it
		float mincurv = 1;
		
        for (Face3 *side in sides) {
			// use dot product of face normals
			float dotprod = GLKVector3DotProduct(face.normal, side.normal);
			mincurv = fmin(mincurv, (1 - dotprod) / 2.0f);
		}
		
        curvature = fmax(curvature, mincurv);
	}
	
    // the more coplanar the lower the curvature term
	return edgelength * curvature;
}

- (float)magnitudeWithGLKVector3:(GLKVector3)vector
{
    return sqrtf(powf(vector.x, vector.x) + powf(vector.y, vector.y) + powf(vector.z, vector.z));
}

- (void)cleanNeighbors
{
    while (self.neighbors.count > 0) {
        Vertex *neighbor = [self.neighbors objectAtIndex:0];
        [neighbor.neighbors removeObject:self];
        [self.neighbors removeObject:neighbor];
    }
}

- (void)removeIfNonNeighbor:(Vertex *)vertex
{
	// removes vertex from neighbor list if vertex isn't a neighbor
    if ([self.neighbors containsObject:vertex]) {
        for (Face3 *face in self.faces) {
            if ([face hasVertex:vertex]) {
                return;
            }
        }
        
        [self.neighbors removeObject:vertex];
	}
}

@end
