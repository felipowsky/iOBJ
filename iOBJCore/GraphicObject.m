//
//  GraphicObject.m
//  iOBJ
//
//  Created by Silvio Fragnani da Silva on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphicObject.h"

@implementation GraphicObject

@synthesize mesh = _mesh;
@synthesize programShader = _programShader;

- (id)init 
{
    self = [super init];
    
    if (self) {
        self.mesh = [[Mesh alloc] init];
    }
    
    return self;
}

- (void)update
{
    //TODO future implementation
}

- (void)draw
{    
    glUseProgram(_programShader);
    
    static const GLfloat vertex[] = {
        0.1f,  0.1f, 0.1f,
        0.1f,  0.2f, 0.1f,
        0.2f,  0.2f, 0.1f,
        0.2f,  0.1f, 0.1f,
    };
    
    static const GLubyte color[] = {
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
    };
    
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0, 0, vertex);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, 1, 0, color);
    glEnableVertexAttribArray(ATTRIB_COLOR);
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}

@end
