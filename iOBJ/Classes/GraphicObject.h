//
//  GraphicObject.h
//  iOBJ
//
//  Created by felipowsky on 08/01/12.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Mesh.h"
#import "Transform.h"

@class Camera;

typedef enum {
    GraphicObjectDisplayModeTexture,
    GraphicObjectDisplayModeSolid,
    GraphicObjectDisplayModeWireframe,
    GraphicObjectDisplayModePoint,
} GraphicObjectDisplayMode;

@interface GraphicObject : NSObject

@property (nonatomic, strong) Mesh *mesh;
@property (nonatomic, strong) Transform *transform;
@property (nonatomic, readonly) BOOL haveTextures;
@property (nonatomic, readonly) GLfloat width;
@property (nonatomic, readonly) GLfloat height;
@property (nonatomic, readonly) GLfloat depth;

- (id)initWithMesh:(Mesh *)mesh;
- (void)update;
- (void)drawWithDisplayMode:(GraphicObjectDisplayMode)displayMode camera:(Camera *)camera;

@end
