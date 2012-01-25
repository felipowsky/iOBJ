//
//  Mesh.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Mesh.h"

@interface Mesh ()
{
    NSMutableArray *_vertices;
    NSMutableArray *_normals;
    NSMutableArray *_faces;
}

@end

@implementation Mesh

@synthesize vertices = _vertices;
@synthesize normals = _normals;
@synthesize faces = _faces;

- (id)init
{
    self = [super init];
    
    if (self) {
        self.vertices = [[NSMutableArray alloc] init];
        self.normals = [[NSMutableArray alloc] init];
        self.faces = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
