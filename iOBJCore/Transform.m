//
//  Transform.m
//  iOBJ
//
//  Created by felipowsky on 10/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Transform.h"

@interface Transform ()
{
    GLKVector3 _position;
    GLKVector3 _rotation;
    GLKVector3 _scale;
}

@end

@implementation Transform

@synthesize position = _position;
@synthesize rotation = _rotation;
@synthesize scale = _scale;

- (id)init
{
    self = [super self];
    
    if (self) {
        _position = GLKVector3Make(0,0,0);
        _rotation = GLKVector3Make(0,0,0);
        _scale = GLKVector3Make(1,1,1);
    }
    
    return self;
}

@end
