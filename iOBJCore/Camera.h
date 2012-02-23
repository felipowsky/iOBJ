//
//  Camera.h
//  iOBJ
//
//  Created by felipowsky on 22/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Camera : NSObject
{
}

@property (nonatomic, readonly) GLKMatrix4 perspectiveMatrix;
@property (nonatomic, readonly) GLKMatrix4 lookAtMatrix;

- (id)initWithPerspective:(GLKMatrix4)perspectiveMatrix lookAt:(GLKMatrix4)lookAtMatrix;

@end
