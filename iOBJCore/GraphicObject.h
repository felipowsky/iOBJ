//
//  GraphicObject.h
//  iOBJ
//
//  Created by Silvio Fragnani da Silva on 08/01/12.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Mesh.h"
#import "Transform.h"
#import "Camera.h"

typedef enum {
    GraphicObjectDisplayModeTexture,
    GraphicObjectDisplayModeSolid,
    GraphicObjectDisplayModeWireframe,
    GraphicObjectDisplayModePoint,
} GraphicObjectDisplayMode;

@interface GraphicObject : NSObject

@property (nonatomic, strong) Mesh *mesh;
@property (nonatomic, strong, readonly) Transform *transform;
@property (nonatomic, readonly) BOOL haveTextures;
@property (nonatomic, readonly) GLfloat width;
@property (nonatomic, readonly) GLfloat height;
@property (nonatomic, readonly) GLfloat depth;

- (id)initWithMesh:(Mesh *)mesh;
- (void)update:(NSTimeInterval)deltaTime camera:(Camera *)camera;
- (void)drawWithDisplayMode:(GraphicObjectDisplayMode)displayMode;

@end
