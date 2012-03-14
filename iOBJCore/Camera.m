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
    GLKMatrix4 _lookAtMatrix;
    
    // perspective
    float _fovyDegrees;
    float _aspect;
    float _nearZ;
    float _farZ;
    
    // look at
    float _eyeX;
    float _eyeY;
    float _eyeZ;
    float _centerX;
    float _centerY;
    float _centerZ;
    float _upX;
    float _upY;
    float _upZ;
}

- (void)updatePerspectiveMatrix;
- (void)updateLookAtMatrix;

@end

@implementation Camera

@synthesize perspectiveMatrix = _perspectiveMatrix;
@synthesize lookAtMatrix = _lookAtMatrix;
@synthesize eyeX = _eyeX;
@synthesize eyeY = _eyeY;
@synthesize eyeZ = _eyeZ;
@synthesize centerX = _centerX;
@synthesize centerY = _centerY;
@synthesize centerZ = _centerZ;
@synthesize upX = _upX;
@synthesize upY = _upY;
@synthesize upZ = _upZ;
@synthesize fovyDegrees = _fovyDegrees;
@synthesize aspect = _aspect;
@synthesize nearZ = _nearZ;
@synthesize farZ = _farZ;

- (id)init
{
    self = [super init];
    
    if (self) {
        _fovyDegrees = 60;
        _aspect = 1;
        _nearZ = 1;
        _farZ = -1;
        
        _eyeX = 0;
        _eyeY = 0;
        _eyeZ = 0;
        _centerX = 0;
        _centerY = 0;
        _centerZ = 0;
        _upX = 0;
        _upY = 1;
        _upZ = 0;
        
        _perspectiveMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(_fovyDegrees), _aspect, _nearZ, _farZ);;
        _lookAtMatrix = GLKMatrix4MakeLookAt(_eyeY, _eyeY, _eyeZ, _centerX, _centerY, _centerZ, _upX, _upY, _upZ);
    }
    
    return self;
}

- (void)setFovyDegrees:(float)fovyDegrees
{
    _fovyDegrees = fovyDegrees;
    [self updatePerspectiveMatrix];
}

- (void)setAspect:(float)aspect
{
    _aspect = aspect;
    [self updatePerspectiveMatrix];
}

- (void)setNearZ:(float)nearZ
{
    _nearZ = nearZ;
    [self updatePerspectiveMatrix];
}

- (void)setFarZ:(float)farZ
{
    _farZ = farZ;
    [self updatePerspectiveMatrix];
}

- (void)setEyeX:(float)eyeX
{
    _eyeX = eyeX;
    [self updateLookAtMatrix];
}

- (void)setEyeY:(float)eyeY
{
    _eyeY = eyeY;
    [self updateLookAtMatrix];
}

- (void)setEyeZ:(float)eyeZ
{
    _eyeZ = eyeZ;
    [self updateLookAtMatrix];
}

- (void)setCenterX:(float)centerX
{
    _centerX = centerX;
    [self updateLookAtMatrix];
}

- (void)setCenterY:(float)centerY
{
    _centerY = centerY;
    [self updateLookAtMatrix];
}

- (void)setCenterZ:(float)centerZ
{
    _centerZ = centerZ;
    [self updateLookAtMatrix];
}

- (void)setUpX:(float)upX
{
    _upX = upX;
    [self updateLookAtMatrix];
}

- (void)setUpY:(float)upY
{
    _upY = upY;
    [self updateLookAtMatrix];
}

- (void)setUpZ:(float)upZ
{
    _upZ = upZ;
    [self updateLookAtMatrix];
}

- (void)updatePerspectiveMatrix
{
    _perspectiveMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(self.fovyDegrees), self.aspect, self.nearZ, self.farZ);
}

- (void)updateLookAtMatrix
{
    _lookAtMatrix = GLKMatrix4MakeLookAt(self.eyeX, self.eyeY, self.eyeZ, self.centerX, self.centerY, self.centerZ, self.upX, self.upY, self.upZ);
}

@end
