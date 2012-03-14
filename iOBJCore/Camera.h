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
@property (nonatomic) float eyeX;
@property (nonatomic) float eyeY;
@property (nonatomic) float eyeZ;
@property (nonatomic) float centerX;
@property (nonatomic) float centerY;
@property (nonatomic) float centerZ;
@property (nonatomic) float upX;
@property (nonatomic) float upY;
@property (nonatomic) float upZ;
@property (nonatomic) float fovyDegrees;
@property (nonatomic) float aspect;
@property (nonatomic) float nearZ;
@property (nonatomic) float farZ;

@end
