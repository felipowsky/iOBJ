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
@property (nonatomic, strong) NSMutableArray *trianglesData;

@end

@implementation ProgressiveMesh

- (void)initialize
{
    self.collapseMap = [[NSMutableArray alloc] init];
    self.permutation = [[NSMutableArray alloc] init];
    self.vertices = [[NSMutableArray alloc] init];
    self.triangles = [[NSMutableArray alloc] init];
    self.trianglesData = [[NSMutableArray alloc] init];
}

- (id)initWithMesh:(Mesh *)mesh
{
    self = [super init];
    
    if (self) {
        self.originalMesh = mesh;
    }
    
    return self;
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

- (Mesh *)generateMeshWithVertices:(NSUInteger)vertices
{
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
    
    Mesh *newMesh = [[Mesh alloc] init];
    
    for (Face3 *face in self.trianglesData) {
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
        
        // if we are not currenly morphing between 2 levels of detail
        // (i.e. if morph=1.0) then q0,q1, and q2 are not necessary.
        float lodbase = 0.5f;
        float morph = 1.0f;
        
        int mx = (int) vertices * lodbase;
        
        int q0 = [self map:p0 mx:mx];
        int q1 = [self map:p1 mx:mx];
        int q2 = [self map:p2 mx:mx];
        
        Vertex *vp0 = [self.vertices objectAtIndex:p0];
        Vertex *vp1 = [self.vertices objectAtIndex:p1];
        Vertex *vp2 = [self.vertices objectAtIndex:p2];
        
        Vertex *vq0 = [self.vertices objectAtIndex:q0];
        Vertex *vq1 = [self.vertices objectAtIndex:q1];
        Vertex *vq2 = [self.vertices objectAtIndex:q2];
        
        GLKVector3 vp0m = GLKVector3MultiplyScalar(vp0.point, morph);
        GLKVector3 vp1m = GLKVector3MultiplyScalar(vp1.point, morph);
        GLKVector3 vp2m = GLKVector3MultiplyScalar(vp2.point, morph);
        
        GLKVector3 vq0m = GLKVector3MultiplyScalar(vq0.point, 1 - morph);
        GLKVector3 vq1m = GLKVector3MultiplyScalar(vq1.point, 1 - morph);
        GLKVector3 vq2m = GLKVector3MultiplyScalar(vq2.point, 1 - morph);
        
        GLKVector3 v0 = GLKVector3Add(vp0m, vq0m);
        GLKVector3 v1 = GLKVector3Add(vp1m, vq1m);
        GLKVector3 v2 = GLKVector3Add(vp2m, vq2m);
        
        // the purpose of the demo is to show polygons
        // therefore just use 1 face normal (flat shading)
        GLKVector3 normal = GLKVector3CrossProduct(GLKVector3Subtract(v1, v0), GLKVector3Subtract(v2, v1));
        
        GLKVector3 point0 = GLKVector3Make(v0.x, v0.y, v0.z);
        GLKVector3 point1 = GLKVector3Make(v1.x, v1.y, v1.z);
        GLKVector3 point2 = GLKVector3Make(v2.x, v2.y, v2.z);
        
        Face3 *newFace = [[Face3 alloc] init];
        
        Vertex *vertex0 = [[Vertex alloc] init];
        vertex0.point = point0;
        vertex0.normal = normal;
        vertex0.texture = vt0.texture;
        
        Vertex *vertex1 = [[Vertex alloc] init];
        vertex1.point = point1;
        vertex1.normal = normal;
        vertex1.texture = vt1.texture;
        
        Vertex *vertex2 = [[Vertex alloc] init];
        vertex2.point = point2;
        vertex2.normal = normal;
        vertex2.texture = vt2.texture;
        
        newFace.vertices = [NSMutableArray arrayWithObjects:vertex0, vertex1, vertex2, nil];
        newFace.material = face.material;
        
        [newMesh addFace:newFace];
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
    self.trianglesData = [[NSMutableArray alloc] init];
    
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
        
        [self.trianglesData addObject:data];
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
	for (int i = 0; i < self.trianglesData.count; i++) {
        Face3 *face = [self.trianglesData objectAtIndex:i];
        
		for (int j = 0; j < 3; j++) {
            Vertex *vertex = [face.vertices objectAtIndex:j];
            int index = [[self.permutation objectAtIndex:vertex.pointIndex] intValue];
            
			vertex.pointIndex = index;
		}
	}
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