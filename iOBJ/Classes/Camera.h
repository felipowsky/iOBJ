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

@property (nonatomic, readonly) GLKMatrix4 perspectiveMatrix;
@property (nonatomic, readonly) GLKMatrix4 lookAtMatrix;
@property (nonatomic) GLfloat eyeX;
@property (nonatomic) GLfloat eyeY;
@property (nonatomic) GLfloat eyeZ;
@property (nonatomic) GLfloat centerX;
@property (nonatomic) GLfloat centerY;
@property (nonatomic) GLfloat centerZ;
@property (nonatomic) GLfloat upX;
@property (nonatomic) GLfloat upY;
@property (nonatomic) GLfloat upZ;
@property (nonatomic) GLfloat fovyDegrees;
@property (nonatomic) GLfloat aspect;
@property (nonatomic) GLfloat nearZ;
@property (nonatomic) GLfloat farZ;

@end
