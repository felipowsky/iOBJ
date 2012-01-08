//
//  Vector3D.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Vector3D.h"

@implementation Vector3D

@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;

- (id)initWith:(double)x y:(double)y z:(double)z
{
    self = [super init];
    
    if (self) {
        self.x = x;
        self.y = y;
        self.z = z;
    }
    
    return self;
}

@end
