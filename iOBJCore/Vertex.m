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
        self.faces = nil;
        _facesLength = 0;
    }
    
    return self;
}

- (void)dealloc
{
    free(self.faces);
}

- (id)copyWithZone:(NSZone *)zone
{
    Vertex *copy = [[Vertex allocWithZone:zone] init];
    
    copy.point = self.point;
    copy.pointIndex = self.pointIndex;
    copy.texture = self.texture;
    copy.textureIndex = self.textureIndex;
    copy.normal = self.normal;
    copy.normalIndex = self.normalIndex;
    
    return copy;
}

- (void)addFaceUnique:(Face3 *)face
{
    BOOL found = NO;
    
    for (NSUInteger i = 0; i < self.facesLength && !found; i++) {
        Face3 *other = (__bridge Face3 *)(self.faces[i]);
        
        if (face == other) {
            found = YES;
        }
    }
    
    if (!found) {
        [self addFace:face];
    }
}

- (void)addFace:(Face3 *)face
{
    if (self.faces == nil) {
        self.faces = malloc(sizeof(Face3 *));
    } else {
        self.faces = realloc(self.faces, (self.facesLength + 1) * sizeof(Face3 *));
    }
    
    self.faces[self.facesLength] = (__bridge void *)(face);
    
    _facesLength++;
}

- (void)removeFace:(Face3 *)face
{
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    
    for (NSUInteger i = 0; i < self.facesLength; i++) {
        Face3 *other = (__bridge Face3 *)(self.faces[i]);
        
        if (face != other) {
            [indexSet addIndex:i];
        }
    }
    
    void **newFaces = malloc(sizeof(Face3 *) * indexSet.count);
    
    NSUInteger i = 0;
    NSUInteger index = [indexSet firstIndex];
    
    while (index != NSNotFound) {
        newFaces[i] = self.faces[index];
        index = [indexSet indexGreaterThanIndex:index];
        i++;
    }
    
    free(self.faces);
    self.faces = newFaces;
    _facesLength = indexSet.count;
}

- (void)removeNeighbor:(Vertex *)neighbor
{
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    
    for (NSUInteger i = 0; i < self.neighbors.count; i++) {
        Vertex *other = [[self.neighbors objectAtIndex:i] nonretainedObjectValue];
        
        if (neighbor == other) {
            [indexSet addIndex:i];
        }
    }
    
    [self.neighbors removeObjectsAtIndexes:indexSet];
}

- (void)addNeighborUnique:(Vertex *)vertex
{
    [self.neighbors addUniqueObject:[NSValue valueWithNonretainedObject:vertex]];
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
        for (NSValue *neighborValue in self.neighbors) {
            Vertex *neighbor = [neighborValue nonretainedObjectValue];
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
    
    float edgelength = GLKVector3Distance(v.point, u.point);
    float curvature = 0;
    
	// find the "sides" triangles that are on the edge uv
    NSMutableArray *sides = [[NSMutableArray alloc] init];
    
	for (NSUInteger i = 0; i < self.facesLength; i++) {
        Face3 *face = (__bridge Face3 *)(self.faces[i]);
        if ([face hasVertex:v]) {
			[sides addObject:face];
		}
	}
    
	// use the triangle facing most away from the sides
	// to determine our curvature term
	for (NSUInteger i = 0; i < self.facesLength; i++) {
        Face3 *face = (__bridge Face3 *)(self.faces[i]);
        // curve for face i and closer side to it
		float mincurv = 1.0f;
		
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

- (void)cleanNeighbors
{
    while (self.neighbors.count > 0) {
        Vertex *neighbor = [[self.neighbors objectAtIndex:0] nonretainedObjectValue];
        [neighbor removeNeighbor:self];
    }
}

- (void)removeIfNonNeighbor:(Vertex *)vertex
{
	// removes vertex from neighbor list if vertex isn't a neighbor
    BOOL found = NO;
    
    for (NSUInteger i = 0; i < self.neighbors.count && !found; i++) {
        Vertex *other = [[self.neighbors objectAtIndex:i] nonretainedObjectValue];
        found = vertex == other;
    }
    
    if (found) {
        for (NSUInteger i = 0; i < self.facesLength; i++) {
            Face3 *face = (__bridge Face3 *)(self.faces[i]);
            if ([face hasVertex:vertex]) {
                return;
            }
        }
        
        [self removeNeighbor:vertex];
	}
}

@end
