//
//  Camera.m
//  iOBJ
//
//  Created by felipowsky on 22/02/12.
//
//

#import "Camera.h"

@implementation Camera

- (id)init
{
    self = [super init];
    
    if (self) {
        _fovyDegrees = 60.0f;
        _aspect = 1.0f;
        _nearZ = 1.0f;
        _farZ = -1.0f;
        
        _eyeX = 0.0f;
        _eyeY = 0.0f;
        _eyeZ = 0.0f;
        _centerX = 0.0f;
        _centerY = 0.0f;
        _centerZ = 0.0f;
        _upX = 0.0f;
        _upY = 1.0f;
        _upZ = 0.0f;
        
        _perspectiveMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(_fovyDegrees), _aspect, _nearZ, _farZ);;
        _lookAtMatrix = GLKMatrix4MakeLookAt(_eyeX, _eyeY, _eyeZ, _centerX, _centerY, _centerZ, _upX, _upY, _upZ);
    }
    
    return self;
}

- (void)setFovyDegrees:(GLfloat)fovyDegrees
{
    if (_fovyDegrees != fovyDegrees) {
        _fovyDegrees = fovyDegrees;
        [self updatePerspectiveMatrix];
    }
}

- (void)setAspect:(GLfloat)aspect
{
    if (_aspect != aspect) {
        _aspect = aspect;
        [self updatePerspectiveMatrix];
    }
}

- (void)setNearZ:(GLfloat)nearZ
{
    if (_nearZ != nearZ) {
        _nearZ = nearZ;
        [self updatePerspectiveMatrix];
    }
}

- (void)setFarZ:(GLfloat)farZ
{
    if (_farZ != farZ) {
        _farZ = farZ;
        [self updatePerspectiveMatrix];
    }
}

- (void)setEyeX:(GLfloat)eyeX
{
    if (_eyeX != eyeX) {
        _eyeX = eyeX;
        [self updateLookAtMatrix];
    }
}

- (void)setEyeY:(GLfloat)eyeY
{
    if (_eyeY != eyeY) {
        _eyeY = eyeY;
        [self updateLookAtMatrix];
    }
}

- (void)setEyeZ:(GLfloat)eyeZ
{
    if (_eyeZ != eyeZ) {
        _eyeZ = eyeZ;
        [self updateLookAtMatrix];
    }
}

- (void)setCenterX:(GLfloat)centerX
{
    if (_centerX != centerX) {
        _centerX = centerX;
        [self updateLookAtMatrix];
    }
}

- (void)setCenterY:(GLfloat)centerY
{
    if (_centerY != centerY) {
        _centerY = centerY;
        [self updateLookAtMatrix];
    }
}

- (void)setCenterZ:(GLfloat)centerZ
{
    if (_centerZ != centerZ) {
        _centerZ = centerZ;
        [self updateLookAtMatrix];
    }
}

- (void)setUpX:(GLfloat)upX
{
    if (_upX != upX) {
        _upX = upX;
        [self updateLookAtMatrix];
    }
}

- (void)setUpY:(GLfloat)upY
{
    if (_upY != upY) {
        _upY = upY;
        [self updateLookAtMatrix];
    }
}

- (void)setUpZ:(GLfloat)upZ
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
