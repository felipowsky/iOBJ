//
//  Face3.m
//  iOBJ
//
//  Created by felipowsky on 09/08/12.
//
//

#import "Face3.h"
#import "Vertex.h"
#import "Material.h"
#import "Mesh.h"

@implementation Face3

- (id)init
{
    self = [super init];
    
    if (self) {
        _vertices = [NSMutableArray arrayWithObjects:[[Vertex alloc] init], [[Vertex alloc] init], [[Vertex alloc] init], nil];
        self.material = nil;
    }
    
    return self;
}

- (void)setVertices:(NSMutableArray *)vertices
{
    _vertices = vertices;
    
    _normal = [Mesh flatNormalsWithFace:self];
    
    for (NSUInteger i = 0; i < 3; i++) {
        Vertex *vertex = [vertices objectAtIndex:i];
        [vertex addFaceUnique:self];
        
        for (NSUInteger j = 0; j < 3; j++) {
            if (i != j) {
                Vertex *neighbor = [vertices objectAtIndex:j];
                [vertex addNeighborUnique:neighbor];
            }
        }
    }
}

- (BOOL)hasVertex:(Vertex *)vertex
{
    for (Vertex *aVertex in self.vertices) {
        if (vertex == aVertex) {
            return  YES;
        }
    }
    
    return NO;
}

- (void)cleanFaceFromVertices
{
	for (Vertex *vertex in self.vertices) {
        if (vertex) {
            [vertex.faces removeObject:self];
        }
	}
    
	for (NSUInteger i = 0; i < 3; i++) {
        Vertex *vi = [self.vertices objectAtIndex:i];
        Vertex *vi2 = [self.vertices objectAtIndex:(i + 1) % 3];
        
        if (vi && vi2) {
            [vi removeIfNonNeighbor:vi2];
            [vi2 removeIfNonNeighbor:vi];
        }
	}
}

- (void)replaceVertex:(Vertex *)oldVertex newVertex:(Vertex *)newVertex
{
    Vertex *v0 = [self.vertices objectAtIndex:0];
    Vertex *v1 = [self.vertices objectAtIndex:1];
    Vertex *v2 = [self.vertices objectAtIndex:2];
    
	if (oldVertex == v0) {
        [self.vertices replaceObjectAtIndex:0 withObject:newVertex];
	
    } else if (oldVertex == v1){
		[self.vertices replaceObjectAtIndex:1 withObject:newVertex];
	
    } else if (oldVertex == v2) {
        [self.vertices replaceObjectAtIndex:2 withObject:newVertex];
	}
    
    [oldVertex.faces removeObject:self];
    
	[newVertex.faces addObject:self];
	
    for (Vertex *vertex in self.vertices) {
		[oldVertex removeIfNonNeighbor:vertex];
        [vertex removeIfNonNeighbor:oldVertex];
	}
    
	for (NSUInteger i = 0; i < 3; i++) {
        Vertex *vertex = [self.vertices objectAtIndex:i];
        
        for (NSUInteger j = 0; j < 3; j++) {
            if (i != j) {
                Vertex *neighbor = [self.vertices objectAtIndex:j];
                [vertex addNeighborUnique:neighbor];
            }
        }
    }
    
	_normal = [Mesh flatNormalsWithFace:self];
}

@end
