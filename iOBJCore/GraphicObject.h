//
//  GraphicObject.h
//  iOBJ
//
//  Created by Silvio Fragnani da Silva on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Mesh.h"
#import "Transform.h"
#import "Camera.h"

@interface GraphicObject : NSObject

@property (strong, nonatomic) Mesh *mesh;
@property (strong, nonatomic, readonly) Transform *transform;
@property (strong, nonatomic) UIImage *textureImage;

- (id)initWithMesh:(const Mesh *)mesh;
- (void)update:(const NSTimeInterval)deltaTime camera:(const Camera *)camera;
- (void)draw;

@end
