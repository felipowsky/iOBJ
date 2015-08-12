//
//  Transform.m
//  iOBJ
//
//  Created by felipowsky on 10/02/12.
//
//

#import "Transform.h"

@interface Transform ()

@property (nonatomic) GLKMatrix4 translateMatrix;
@property (nonatomic) GLKMatrix4 rotationMatrix;
@property (nonatomic) GLKMatrix4 scaleMatrix;
@property (nonatomic) GLKMatrix4 toOriginMatrix;

@end

@implementation Transform

- (id)init
{
    self = [super self];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithToOrigin:(GLKVector3)toOrigin
{
    self = [super self];
    
    if (self) {
        [self initialize];
        self.toOriginMatrix = GLKMatrix4Translate(GLKMatrix4Identity, toOrigin.x, toOrigin.y, toOrigin.z);
    }
    
    return self;
}

- (void)initialize
{
    self.translateMatrix = GLKMatrix4Identity;
    self.rotationMatrix = GLKMatrix4Identity;
    self.scaleMatrix = GLKMatrix4Identity;
    self.toOriginMatrix = GLKMatrix4Identity;
}

- (void)update
{
    self.matrix = [self transformedMatrix];
}

- (GLKMatrix4)transformedMatrix
{
    GLKMatrix4 resultMatrix = GLKMatrix4Identity;
    
    resultMatrix = GLKMatrix4Multiply(resultMatrix, self.translateMatrix);
    resultMatrix = GLKMatrix4Multiply(resultMatrix, GLKMatrix4Invert(self.toOriginMatrix, nil));
    resultMatrix = GLKMatrix4Multiply(resultMatrix, self.rotationMatrix);
    resultMatrix = GLKMatrix4Multiply(resultMatrix, self.toOriginMatrix);
    resultMatrix = GLKMatrix4Multiply(resultMatrix, self.scaleMatrix);
    
    return resultMatrix;
}

- (void)rotateWithDegrees:(GLfloat)angle axis:(GLKVector3)axis
{
    GLKQuaternion rotation = GLKQuaternionMakeWithAngleAndVector3Axis(GLKMathDegreesToRadians(angle), axis);
    
    GLKMatrix4 newRoationMatrix = GLKMatrix4MakeWithQuaternion(rotation);
    
    self.rotationMatrix = GLKMatrix4Multiply(newRoationMatrix, self.rotationMatrix);
}

- (void)translateToOrigin
{
    self.position = self.toOrigin;
}

- (GLKVector3)position
{
    return GLKVector3Make(self.translateMatrix.m30, self.translateMatrix.m31, self.translateMatrix.m32);
}

- (void)setPosition:(GLKVector3)position
{
    self.translateMatrix = GLKMatrix4Translate(GLKMatrix4Identity, position.x, position.y, position.z);
}

- (GLKVector3)scale
{
    return GLKVector3Make(self.scaleMatrix.m00, self.scaleMatrix.m11, self.scaleMatrix.m22);
}

- (void)setScale:(GLKVector3)scale
{
    self.scaleMatrix = GLKMatrix4Scale(GLKMatrix4Identity, scale.x, scale.y, scale.z);
}

- (void)setRotation:(GLKQuaternion)rotation
{
    self.rotationMatrix = GLKMatrix4MakeWithQuaternion(rotation);
}

- (GLKQuaternion)rotation
{
    return GLKQuaternionMakeWithMatrix4(self.rotationMatrix);
}

- (GLKVector3)toOrigin
{
    return GLKVector3Make(self.toOriginMatrix.m30, self.toOriginMatrix.m31, self.toOriginMatrix.m32);
}

- (void)setToOrigin:(GLKVector3)toOrigin
{
    self.toOriginMatrix = GLKMatrix4Translate(GLKMatrix4Identity, toOrigin.x, toOrigin.y, toOrigin.z);
}

@end
