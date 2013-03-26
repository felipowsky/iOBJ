//
//  ViewDependentMesh.m
//  iOBJ
//
//  Created by felipowsky on 19/03/13.
//
//

#import "ViewDependentMesh.h"
#import "Mesh.h"
#import "Camera.h"
#import "Face3.h"

@implementation ViewDependentBinaryTree

- (BOOL)isActive
{
    // condicoes
    // 1. indice nao sofreu colapso e o left e o right sao ambos colapsados ou nao existem
    // 2. ou indice sofreu colapso, o seu parent nao sofreu colapso e o seu irmao (left ou right) no parent existe e nao sofreu colapso
    
    return YES;
}

@end

@implementation ViewDependentList

@end

@implementation ViewDependentHalfEdge

@end

@implementation ViewDependentFace

- (id)initWithFace:(Face3 *)face
{
    self = [super init];
    
    if (self) {
        self.face = face;
    }
    
    return self;
}

@end

@interface ViewDependentMesh ()

@property (nonatomic, weak) Mesh *originalMesh;
@property (nonatomic, strong) NSMutableArray *halfEdges;
@property (nonatomic, strong) NSMutableArray *faces;

@end

@implementation ViewDependentMesh

- (id)initWithMesh:(Mesh *)mesh
{
    self = [super init];
    
    if (self) {
        self.originalMesh = mesh;
        self.halfEdges = nil;
    }
    
    return self;
}

- (Mesh *)generateMeshWithCamera:(Camera *)camera
{
    NSUInteger halfEdgesCapacity = self.originalMesh.faces.count * 3;
    
    self.halfEdges = [NSMutableArray arrayWithCapacity:halfEdgesCapacity];
    
    for (NSUInteger i = 0; i < halfEdgesCapacity; i++) {
        [self.halfEdges addObject:[[ViewDependentHalfEdge alloc] init]];
    }
    
    NSUInteger facesCapacity = self.originalMesh.faces.count;
    
    self.faces = [NSMutableArray arrayWithCapacity:facesCapacity];
    
    for (NSUInteger i = 0; i < facesCapacity; i++) {
        [self.faces addObject:[[ViewDependentFace alloc] initWithFace:[self.originalMesh.faces objectAtIndex:i]]];
    }
    
    return nil;
}

@end
