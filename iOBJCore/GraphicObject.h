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

@interface GraphicObject : NSObject

@property (nonatomic, strong) Mesh *mesh;
@property (nonatomic, strong, readonly) Transform *transform;
@property (nonatomic, strong) UIImage *textureImage;

- (id)initWithMesh:(const Mesh *)mesh;
- (void)update:(const NSTimeInterval)deltaTime camera:(const Camera *)camera;
- (void)draw;

@end
