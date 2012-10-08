//
//  Transform.h
//  iOBJ
//
//  Created by felipowsky on 10/02/12.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Transform : NSObject

@property (nonatomic) GLKMatrix4 matrix;
@property (nonatomic) GLKVector3 position;
@property (nonatomic) GLKVector3 scale;
@property (nonatomic) GLKQuaternion rotation;
@property (nonatomic) GLKVector3 toOrigin;

- (id)initWithToOrigin:(GLKVector3)toOrigin;
- (void)update;
- (void)rotateWithDegrees:(GLfloat)angle axis:(GLKVector3)axis;
- (void)translateToOrigin;

@end
