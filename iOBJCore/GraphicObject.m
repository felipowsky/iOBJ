//
//  GraphicObject.m
//  iOBJ
//
//  Created by Silvio Fragnani da Silva on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphicObject.h"

@interface GraphicObject ()
{
    GLKBaseEffect *_effect;
    GLKVector4 *_colors;
}

@property (strong, nonatomic) GLKBaseEffect *effect;
@property (nonatomic) GLKVector4 *colors;

@end

@implementation GraphicObject

@synthesize mesh = _mesh;
@synthesize effect = _effect;
@synthesize colors = _colors;

- (id)initWithMesh:(Mesh *)mesh 
{
    self = [super init];
    
    if (self) {
        self.mesh = mesh;
        self.effect = [[GLKBaseEffect alloc] init];
        
        self.colors = (GLKVector4 *) malloc(self.mesh.triangleVerticesLength * sizeof(GLKVector4));
        
        // necessary to generate random numbers
        srand(time(NULL));
        
        for (int i = 0; i < self.mesh.triangleVerticesLength; i++) {
            double red = rand() % 9;
            double green = rand() % 9;
            double blue = rand() % 9;
            
            self.colors[i] = GLKVector4Make(red / 10.0, green / 10.0, blue / 10.0, 1.0);
        }
    }
    
    return self;
}

- (void)update
{
}

- (void)draw
{
    GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(1.0/8*(2*M_PI));
    GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(1.0/8*(2*M_PI));
    GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(1.0/8*(2*M_PI));
    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(1, 1, 1);
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(0, 0, 0);
    
    GLKMatrix4 modelMatrix = GLKMatrix4Multiply(translateMatrix,GLKMatrix4Multiply(scaleMatrix,GLKMatrix4Multiply(zRotationMatrix, GLKMatrix4Multiply(yRotationMatrix, xRotationMatrix))));
    
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 10, 0, 0, 0, 0, 1, 0);
    self.effect.transform.modelviewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
    
    self.effect.transform.projectionMatrix = GLKMatrix4MakePerspective(0.125*(2*M_PI), 2.0/3.0, 2, -1);
    
    [self.effect prepareToDraw];
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, self.mesh.triangleVertices);
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, self.colors);
    
    glDrawArrays(GL_TRIANGLES, 0, self.mesh.triangleVerticesLength);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
}

- (void)dealloc
{
    free(self.colors);
}

@end
