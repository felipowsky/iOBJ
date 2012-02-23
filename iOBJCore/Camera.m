//
//  Camera.m
//  iOBJ
//
//  Created by felipowsky on 22/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"

@interface Camera ()
{
    GLKMatrix4 _perspectiveMatrix;
    GLKMatrix4 _lookAtmatrix;
}

@end

@implementation Camera

@synthesize perspectiveMatrix = _perspectiveMatrix;
@synthesize lookAtMatrix = _lookAtmatrix;

- (id)initWithPerspective:(GLKMatrix4)perspectiveMatrix lookAt:(GLKMatrix4)lookAtMatrix;
{
    self = [super init];
    
    if (self) {
        _perspectiveMatrix = perspectiveMatrix;
        _lookAtmatrix = lookAtMatrix;
    }
    
    return self;
}

@end
