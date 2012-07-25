//
//  Camera.m
//  iOBJ
//
//  Created by felipowsky on 22/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"

@implementation Camera

@synthesize perspectiveMatrix = _perspectiveMatrix, lookAtMatrix = _lookAtMatrix, eyeX = _eyeX, eyeY = _eyeY, eyeZ = _eyeZ, centerX = _centerX, centerY = _centerY, centerZ = _centerZ, upX = _upX, upY = _upY, upZ = _upZ, fovyDegrees = _fovyDegrees, aspect = _aspect, nearZ = _nearZ, farZ = _farZ;

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
    if (_fovyDegrees != fovyDegrees) {
        _fovyDegrees = fovyDegrees;
        [self updatePerspectiveMatrix];
    }
}

- (void)setAspect:(float)aspect
{
    if (_aspect != aspect) {
        _aspect = aspect;
        [self updatePerspectiveMatrix];
    }
}

- (void)setNearZ:(float)nearZ
{
    if (_nearZ != nearZ) {
        _nearZ = nearZ;
        [self updatePerspectiveMatrix];
    }
}

- (void)setFarZ:(float)farZ
{
    if (_farZ != farZ) {
        _farZ = farZ;
        [self updatePerspectiveMatrix];
    }
}

- (void)setEyeX:(float)eyeX
{
    if (_eyeX != eyeX) {
        _eyeX = eyeX;
        [self updateLookAtMatrix];
    }
}

- (void)setEyeY:(float)eyeY
{
    if (_eyeY != eyeY) {
        _eyeY = eyeY;
        [self updateLookAtMatrix];
    }
}

- (void)setEyeZ:(float)eyeZ
{
    if (_eyeZ != eyeZ) {
        _eyeZ = eyeZ;
        [self updateLookAtMatrix];
    }
}

- (void)setCenterX:(float)centerX
{
    if (_centerX != centerX) {
        _centerX = centerX;
        [self updateLookAtMatrix];
    }
}

- (void)setCenterY:(float)centerY
{
    if (_centerY != centerY) {
        _centerY = centerY;
        [self updateLookAtMatrix];
    }
}

- (void)setCenterZ:(float)centerZ
{
    if (_centerZ != centerZ) {
        _centerZ = centerZ;
        [self updateLookAtMatrix];
    }
}

- (void)setUpX:(float)upX
{
    if (_upX != upX) {
        _upX = upX;
        [self updateLookAtMatrix];
    }
}

- (void)setUpY:(float)upY
{
    if (_upY != upY) {
        _upY = upY;
        [self updateLookAtMatrix];
    }
}

- (void)setUpZ:(float)upZ
{
    if (_upZ != upZ) {
        _upZ = upZ;
        [self updateLookAtMatrix];
    }
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
