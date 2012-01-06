//
//  Mesh.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Mesh.h"

@implementation Mesh

@synthesize vertices = _vertices;

- (id)init
{
    self = [super init];
    
    if (self) {
        self.vertices = [[NSMutableSet alloc] init];
    }
    
    return self;
}

@end
