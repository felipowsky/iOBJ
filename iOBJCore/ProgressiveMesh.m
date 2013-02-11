//
//  ProgressiveMesh.m
//  iOBJ
//
//  Created by felipowsky on 10/02/13.
//
//

#import "ProgressiveMesh.h"
#import "Mesh.h"
#import "NSMutableArray+Additions.h"
#import "Vertex.h"
#import "Face3.h"

@interface ProgressiveMesh ()

@property (nonatomic, strong) Mesh *originalMesh;
@property (nonatomic, strong) NSMutableArray *collapseMap;
@property (nonatomic, strong) NSMutableArray *permutation;
@property (nonatomic, strong) NSMutableArray *vertices;
@property (nonatomic, strong) NSMutableArray *triangles;

@end

@implementation ProgressiveMesh

- (void)initialize
{
    self.collapseMap = [[NSMutableArray alloc] init];
    self.permutation = [[NSMutableArray alloc] init];
    self.vertices = [[NSMutableArray alloc] init];
    self.triangles = [[NSMutableArray alloc] init];
}

- (id)initWithMesh:(Mesh *)mesh
{
    self = [super init];
    
    if (self) {
        self.originalMesh = mesh;
    }
    
    return self;
}

- (Mesh *)generateMeshWithVertices:(NSUInteger)vertices
{
    Mesh *newMesh = nil;
    
    if (self.collapseMap.count < 1 || self.permutation.count < 1) {
        
        if (self.originalMesh) {
            [self generate];
        }
#ifdef DEBUG
        else {
            NSLog(@"Couldn't generate progressive mesh without original mesh");
        }
#endif
    }
    
    return newMesh;
}

- (void)generate
{
    self.vertices = [[NSMutableArray alloc] init];
    
    Mesh *originalMesh = self.originalMesh;
    
    for (NSUInteger i = 0; i < originalMesh.points.count; i++) {
        NSValue *value = [self.originalMesh.points objectAtIndex:i];
        GLKVector3 point;
        [value getValue:&point];
        
        Vertex *vertex = [[Vertex alloc] init];
        vertex.point = point;
        vertex.pointIndex = i;
        
        [self.vertices addObject:vertex];
    }
    
    self.triangles = [[NSMutableArray alloc] init];
    
    for (Face3 *face in originalMesh.faces) {
        Face3 *newFace = [[Face3 alloc] init];
        
        Vertex *vertex0 = [face.vertices objectAtIndex:0];
        Vertex *vertex1 = [face.vertices objectAtIndex:1];
        Vertex *vertex2 = [face.vertices objectAtIndex:2];
        
        Vertex *newVertex0 = [self.vertices objectAtIndex:vertex0.pointIndex];
        Vertex *newVertex1 = [self.vertices objectAtIndex:vertex1.pointIndex];
        Vertex *newVertex2 = [self.vertices objectAtIndex:vertex2.pointIndex];
        
        newFace.vertices = [NSMutableArray arrayWithObjects:newVertex0, newVertex1, newVertex2, nil];
    }
    
    for (Vertex *vertex in self.vertices) {
        [vertex computeEdgeCost];
    }
    
    self.permutation = [NSMutableArray arrayWithCapacity:self.vertices.count];
    self.collapseMap = [NSMutableArray arrayWithCapacity:self.vertices.count];
    
    // reduce the object down to nothing:
    while(self.vertices.count > 0) {
        // get the next vertex to collapse
        Vertex *mn = [self minimumCostEdge];
        
        // keep track of this vertex, i.e. the collapse ordering
        [self.permutation insertObject:[NSNumber numberWithInt:self.vertices.count-1] atIndex:mn.pointIndex];
        
        // keep track of vertex to which we collapse to
        int mapIndex = mn.collapse ? mn.collapse.pointIndex : -1;
        [self.collapseMap insertObject:[NSNumber numberWithInt:mapIndex] atIndex:self.vertices.count-1];
        
        // collapse this edge
        [self collapse:mn v:mn.collapse];
    }
    
    // reorder the map list based on the collapse ordering
    for (NSUInteger i = 0; i < self.collapseMap.count; i++) {
        int mapIndex = [[self.collapseMap objectAtIndex:i] intValue];
        int value = mapIndex == -1 ? 0 : [[self.permutation objectAtIndex:mapIndex] intValue];
        
        [self.collapseMap replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:value]];
    }
    
    // The caller of this function should reorder their vertices
    // according to the returned "permutation".
}

- (Vertex *)minimumCostEdge
{
	// Find the edge that when collapsed will affect model the least.
	// This funtion actually returns a Vertex, the second vertex
	// of the edge (collapse candidate) is stored in the vertex data.
	// Serious optimization opportunity here: this function currently
	// does a sequential search through an unsorted list :-(
	// Our algorithm could be O(n*lg(n)) instead of O(n*n)
	Vertex *mn = [self.vertices objectAtIndex:0];
	
    for (Vertex *vertex in self.vertices) {
		if (vertex.objdist < mn.objdist) {
			mn = vertex;
		}
	}
    
	return mn;
}

- (void)collapse:(Vertex *)u v:(Vertex *)v
{
	// Collapse the edge uv by moving vertex u onto v
	// Actually remove tris on uv, then update tris that
	// have u to have v, and then remove u.
	if (!v) {
		// u is a vertex all by itself so just delete it
        [u cleanNeighbors];
        [self.vertices removeObject:u];
	
    } else {
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        
        // make tmp a list of all the neighbors of u
        for (Vertex *vertex in u.neighbors) {
            [tmp addObject:vertex];
        }
        
        // delete triangles on edge uv:
        for (int i = u.faces.count - 1; i >= 0; i--) {
            Face3 *face = [u.faces objectAtIndex:i];
            
            if ([face hasVertex:v]) {
                [self.triangles removeObject:face];
                [face cleanFaceFromVertices];
            }
        }
        
        // update remaining triangles to have v instead of u
        for (int i = u.faces.count - 1; i >= 0; i--) {
            Face3 *face = [u.faces objectAtIndex:i];
            [face replaceVertex:u newVertex:v];
        }
        
        [u cleanNeighbors];
        [self.vertices removeObject:u];
        
        // recompute the edge collapse costs for neighboring vertices
        for (Vertex *vertex in tmp) {
            [vertex computeEdgeCost];
        }
    }
}

@end
