//
//  iOBJShader.h
//  iOBJ
//
//  Created by Silvio Fragnani da Silva on 07/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface Shader : NSObject

@property (nonatomic, readwrite) GLuint program;

- (BOOL)loadShaders;

- (void)useProgram;
- (void)deleteShaderProgram;

@end
