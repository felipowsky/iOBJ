//
//  ProgressiveMesh.m
//  iOBJ
//
//  Created by felipowsky on 10/02/13.
//
//

#import "ProgressiveMesh.h"
#import "NSMutableArray+Additions.h"

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
    if (self.collapseMap.count < 1 || self.permutation.count < 1) {
        [self generate];
    }
    
    return nil;
}

- (void)generate
{
}

@end
