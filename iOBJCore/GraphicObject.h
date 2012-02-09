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

@interface GraphicObject : NSObject
{
    Mesh *_mesh;
}

@property (strong, nonatomic) Mesh *mesh;

- (id)initWithMesh:(Mesh *)mesh;
- (void)update;
- (void)draw;

@end
