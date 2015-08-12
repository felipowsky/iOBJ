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
        
        GLKVector2 texture;
        _textures = [NSMutableArray arrayWithObjects:[NSValue valueWithBytes:&texture objCType:@encode(GLKVector2)], [NSValue valueWithBytes:&texture objCType:@encode(GLKVector2)], [NSValue valueWithBytes:&texture objCType:@encode(GLKVector2)], nil];
        self.material = nil;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Face3 *copy = [[Face3 allocWithZone:zone] init];
    
    NSMutableArray *copyVertices = [[NSMutableArray alloc] init];
    
    for (Vertex *vertex in self.vertices) {
        [copyVertices addObject:[vertex copy]];
    }
    
    copy.vertices = copyVertices;
    copy.material = [self.material copy];
    
    return copy;
}

- (void)setVertices:(NSMutableArray *)vertices
{
    _vertices = vertices;
    
    [self computeNormal];
    
    for (NSUInteger i = 0; i < 3; i++) {
        Vertex *vertex = [vertices objectAtIndex:i];
        
        GLKVector2 texture = vertex.texture;
        
        [self.textures insertObject:[NSValue valueWithBytes:&texture objCType:@encode(GLKVector2)] atIndex:i];
        
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
    return [self.vertices containsObject:vertex];
}

- (void)cleanFaceFromVertices
{
	for (Vertex *vertex in self.vertices) {
        if (vertex) {
            [vertex removeFace:self];
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
    
    [oldVertex removeFace:self];
    
	[newVertex addFaceUnique:self];
	
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
    
	[self computeNormal];
}

- (void)computeNormal
{
    GLKVector3 normal = [Mesh flatNormalsWithFace:self];
	
    if (GLKVector3Length(normal) != 0.0f) {
        normal = [self normalize:normal];
    }
    
    _normal = normal;
}

- (GLKVector3)normalize:(GLKVector3)vector
{
    float d = GLKVector3Length(vector);
    
    if (d == 0.0f) {
		d = 0.1f;
	}
    
    return GLKVector3Make(vector.x / d, vector.y / d, vector.z / d);
}

@end
