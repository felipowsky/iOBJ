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
#import "Material.h"

@interface ProgressiveMesh ()

@property (nonatomic, strong) Mesh *originalMesh;
@property (nonatomic, strong) NSMutableArray *vertices;
@property (nonatomic, strong) NSMutableArray *triangles;

@end

@implementation ProgressiveMesh

- (void)initialize
{
    self.vertices = nil;
    self.triangles = nil;
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
    Mesh *originalMesh = self.originalMesh;
    
    self.vertices = [NSMutableArray arrayWithCapacity:originalMesh.points.count];
    
    for (NSUInteger i = 0; i < originalMesh.points.count; i++) {
        NSValue *value = [self.originalMesh.points objectAtIndex:i];
        GLKVector3 point;
        [value getValue:&point];
        
        Vertex *vertex = [[Vertex alloc] init];
        vertex.point = point;
        vertex.pointIndex = i;
        
        [self.vertices addObject:vertex];
    }
    
    self.triangles = [NSMutableArray arrayWithCapacity:originalMesh.faces.count];
    
    for (Face3 *face in originalMesh.faces) {
        Vertex *vertex0 = [face.vertices objectAtIndex:0];
        Vertex *vertex1 = [face.vertices objectAtIndex:1];
        Vertex *vertex2 = [face.vertices objectAtIndex:2];
        
        Vertex *newVertex0 = [self.vertices objectAtIndex:vertex0.pointIndex];
        newVertex0.texture = vertex0.texture;
        newVertex0.normal = vertex0.normal;
        
        Vertex *newVertex1 = [self.vertices objectAtIndex:vertex1.pointIndex];
        newVertex1.texture = vertex1.texture;
        newVertex1.normal = vertex1.normal;
        
        Vertex *newVertex2 = [self.vertices objectAtIndex:vertex2.pointIndex];
        newVertex2.texture = vertex2.texture;
        newVertex2.normal = vertex2.normal;
        
        Face3 *newFace = [[Face3 alloc] init];
        newFace.vertices = [NSMutableArray arrayWithObjects:newVertex0, newVertex1, newVertex2, nil];
        newFace.material = [face.material copy];
        
        [self.triangles addObject:newFace];
    }
    
    for (Vertex *vertex in self.vertices) {
        [vertex computeEdgeCost];
    }
    
    while (self.vertices.count > vertices) {
        Vertex *mn = [self minimumCostEdge];
        [self collapse:mn v:mn.collapse];
    }
    
    Mesh *newMesh = [[Mesh alloc] init];
    
    for (Face3 *face in self.triangles) {
        [newMesh addFace:face];
    }
    
    return newMesh;
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
        for (NSValue *vertexValue in u.neighbors) {
            [tmp addObject:vertexValue];
        }
        
        // delete triangles on edge uv:
        for (int i = u.facesLength - 1; i >= 0; i--) {
            Face3 *face = (__bridge Face3 *)(u.faces[i]);
            
            if ([face hasVertex:v]) {
                [self.triangles removeObject:face];
                [face cleanFaceFromVertices];
            }
        }
        
        // update remaining triangles to have v instead of u
        for (int i = u.facesLength - 1; i >= 0; i--) {
            Face3 *face = (__bridge Face3 *)(u.faces[i]);
            [face replaceVertex:u newVertex:v];
        }
        
        [u cleanNeighbors];
        [self.vertices removeObject:u];
        
        // recompute the edge collapse costs for neighboring vertices
        for (NSValue *vertexValue in tmp) {
            [[vertexValue nonretainedObjectValue] computeEdgeCost];
        }
    }
}

@end
