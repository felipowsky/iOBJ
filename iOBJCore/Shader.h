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

@property (nonatomic) GLuint program;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

- (void)useProgram;
- (void)delProgram;

@end
