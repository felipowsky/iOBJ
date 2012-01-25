//
//  Face.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Face.h"

@interface Face ()
{
    NSArray *_vertices;
}

@end

@implementation Face

@synthesize vertices = _vertices;

- (id)initWithVertices:(NSArray *)vertices
{
    self = [super init];
    
    if (self) {
        self.vertices = vertices;
    }
    
    return self;
}

@end
