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

@property (nonatomic, weak) Mesh *originalMesh;
@property (nonatomic, strong) NSMutableArray *vertices;
@property (nonatomic, strong) NSMutableArray *triangles;
@property (nonatomic, strong) NSMutableArray *collapseMap;
@property (nonatomic, strong) NSMutableArray *permutation;
@property (nonatomic, strong) NSMutableArray *cachedTriangles;

@end

@implementation ProgressiveMesh

- (id)initWithMesh:(Mesh *)mesh
{
    self = [super init];
    
    if (self) {
        self.originalMesh = mesh;
        self.vertices = nil;
        self.triangles = nil;
        self.collapseMap = nil;
        self.permutation = nil;
        self.cachedTriangles = nil;
    }
    
    return self;
}

- (Mesh *)generateMeshWithVertices:(NSUInteger)vertices cache:(BOOL)cache
{
    Mesh *mesh = nil;
    
    if (cache) {
        mesh = [self generateMeshWithCacheWithVertices:vertices];
    
    } else {
        // clean cache
        self.collapseMap = nil;
        self.permutation = nil;
        self.cachedTriangles = nil;
        
        mesh = [self generateMeshWithoutCacheWithVertices:vertices];        
    }
    
    return mesh;
}

- (Mesh *)generateMeshWithoutCacheWithVertices:(NSUInteger)vertices
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

- (Mesh *)generateMeshWithCacheWithVertices:(NSUInteger)vertices
{
    if (self.collapseMap.count < 1 || self.cachedTriangles.count < 1) {
        [self generateCache];
    }
    
    Mesh *newMesh = [[Mesh alloc] init];
    
    int i = -1;
    
    for (Face3 *face in self.cachedTriangles) {
        i++;
        
        Vertex *vt0 = [face.vertices objectAtIndex:0];
        Vertex *vt1 = [face.vertices objectAtIndex:1];
        Vertex *vt2 = [face.vertices objectAtIndex:2];
        
        int p0 = [self map:vt0.pointIndex mx:vertices];
        int p1 = [self map:vt1.pointIndex mx:vertices];
        int p2 = [self map:vt2.pointIndex mx:vertices];
        
        // note: serious optimization opportunity here,
        // by sorting the triangles the following "continue"
        // could have been made into a "break" statement
        if (p0 == p1 || p1 == p2 || p2 == p0) {
            continue;
        }
        
        Vertex *v0 = [self.vertices objectAtIndex:p0];
        Vertex *v1 = [self.vertices objectAtIndex:p1];
        Vertex *v2 = [self.vertices objectAtIndex:p2];
        
        GLKVector3 normal = GLKVector3CrossProduct(GLKVector3Subtract(v1.point, v0.point), GLKVector3Subtract(v2.point, v1.point));
        
        Face3 *newFace = [[Face3 alloc] init];
        
        Vertex *vertex0 = [[Vertex alloc] init];
        vertex0.point = v0.point;
        vertex0.normal = normal;
        vertex0.texture = vt0.texture;
        
        Vertex *vertex1 = [[Vertex alloc] init];
        vertex1.point = v1.point;
        vertex1.normal = normal;
        vertex1.texture = vt1.texture;
        
        Vertex *vertex2 = [[Vertex alloc] init];
        vertex2.point = v2.point;
        vertex2.normal = normal;
        vertex2.texture = vt2.texture;
        
        newFace.vertices = [NSMutableArray arrayWithObjects:vertex0, vertex1, vertex2, nil];
        newFace.material = face.material;
        
        [newMesh addFace:newFace];
    }
    
    return newMesh;
}

- (void)generateCache
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
    self.cachedTriangles = [NSMutableArray arrayWithCapacity:originalMesh.faces.count];
    
    for (Face3 *face in originalMesh.faces) {
        Face3 *newFace = [[Face3 alloc] init];
        
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
        
        newFace.vertices = [NSMutableArray arrayWithObjects:newVertex0, newVertex1, newVertex2, nil];
        
        [self.triangles addObject:newFace];
        
        Face3 *data = [newFace copy];
        data.material = face.material;
        
        [self.cachedTriangles addObject:data];
    }
    
    for (Vertex *vertex in self.vertices) {
        [vertex computeEdgeCost];
    }
    
    self.permutation = [NSMutableArray arrayWithCapacity:self.vertices.count];
    
    for (NSUInteger i = 0; i < self.vertices.count; i++) {
        [self.permutation addObject:[NSNull null]];
    }
    
    self.collapseMap = [NSMutableArray arrayWithCapacity:self.vertices.count];
    
    for (NSUInteger i = 0; i < self.vertices.count; i++) {
        [self.collapseMap addObject:[NSNull null]];
    }
    
    NSMutableArray *verticesCopy = [NSMutableArray arrayWithArray:[self.vertices copy]];
    NSMutableArray *trianglesCopy = [NSMutableArray arrayWithArray:[self.triangles copy]];
    
    // reduce the object down to nothing:
    while (self.vertices.count > 0) {
        // get the next vertex to collapse
        Vertex *mn = [self minimumCostEdge];
        
        // keep track of this vertex, i.e. the collapse ordering
        [self.permutation replaceObjectAtIndex:mn.pointIndex withObject:[NSNumber numberWithInt:self.vertices.count-1]];
        
        // keep track of vertex to which we collapse to
        int mapIndex = mn.collapse ? mn.collapse.pointIndex : -1;
        
        [self.collapseMap replaceObjectAtIndex:self.vertices.count-1 withObject:[NSNumber numberWithInt:mapIndex]];
        
        // collapse this edge
        [self collapse:mn v:mn.collapse];
    }
    
    self.vertices = verticesCopy;
    self.triangles = trianglesCopy;
    
    // reorder the map list based on the collapse ordering
    for (NSUInteger i = 0; i < self.collapseMap.count; i++) {
        int mapIndex = [[self.collapseMap objectAtIndex:i] intValue];
        int value = mapIndex == -1 ? 0 : [[self.permutation objectAtIndex:mapIndex] intValue];
        
        [self.collapseMap replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:value]];
    }
    
    // The caller of this function should reorder their vertices
    // according to the returned "permutation".
    [self permuteVertices];
    
    self.permutation = nil;
}

- (void)permuteVertices
{
	// rearrange the vertex list
	NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    for (Vertex *vertex in self.vertices) {
		[tempList addObject:vertex];
	}
    
	for (int i = 0; i < self.vertices.count; i++) {
        int index = [[self.permutation objectAtIndex:i] intValue];
        [self.vertices replaceObjectAtIndex:index withObject:[tempList objectAtIndex:i]];
	}
	
    // update the changes in the entries in the triangle list
	for (int i = 0; i < self.cachedTriangles.count; i++) {
        Face3 *face = [self.cachedTriangles objectAtIndex:i];
        
		for (int j = 0; j < 3; j++) {
            Vertex *vertex = [face.vertices objectAtIndex:j];
            
            int index = [[self.permutation objectAtIndex:vertex.pointIndex] intValue];
            vertex.pointIndex = index;
		}
	}
}

- (int)map:(int)a mx:(int)mx
{
	if (mx <= 0) {
        return 0;
    }
    
    while (a >= mx) {
		a = [[self.collapseMap objectAtIndex:a] intValue];
	}
    
	return a;
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
