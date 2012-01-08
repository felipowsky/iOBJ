//
//  GraphicObject.m
//  iOBJ
//
//  Created by Silvio Fragnani da Silva on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphicObject.h"

@implementation GraphicObject

@synthesize shader = _shader;
@synthesize mesh   = _mesh;

- (id)init {
    self = [super init];
    
    if (self) {
        self.shader = [[Shader alloc] init];
        self.mesh   = [[Mesh alloc] init];
        
        [self.shader loadShaders];
    }
    
    return self;
}

- (void)update
{
    //TODO future implementation
}

- (void)draw
{    
    glUseProgram([self.shader program]);
    
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
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
