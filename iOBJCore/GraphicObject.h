//
//  GraphicObject.h
//  iOBJ
//
//  Created by Silvio Fragnani da Silva on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shader.h"
#import "Mesh.h"


@interface GraphicObject : NSObject
{
    Mesh *_mesh;
    GLuint _programShader;
}

@property (nonatomic, strong) Mesh *mesh;
@property (nonatomic) GLuint programShader;

- (void)update;
- (void)draw;

@end
