//
//  Vertex.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Vertex.h"

@implementation Vertex

@synthesize point = _point;
@synthesize normal = _normal;

- (id)initWithPoint:(Point3D *)point normal:(Vector3D *)normal
{
    self = [super init];
    
    if (self) {
        self.point = point;
        self.normal = normal;
    }
    
    return self;
}

@end
