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
    Mesh *_mesh;
    GLKBaseEffect *_effect;
    GLKVector4 *_colors;
    Transform *_transform;
}

@property (strong, nonatomic) GLKBaseEffect *effect;
@property (nonatomic) GLKVector4 *colors;

@end

@implementation GraphicObject

@synthesize mesh = _mesh;
@synthesize effect = _effect;
@synthesize colors = _colors;
@synthesize transform = _transform;

- (id)initWithMesh:(Mesh *)mesh
{
    self = [super init];
    
    if (self) {
        self.mesh = mesh;
        self.effect = [[GLKBaseEffect alloc] init];
        _transform = [[Transform alloc] init];
        
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
    GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(self.transform.rotation.x);
    GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(self.transform.rotation.y);
    GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(self.transform.rotation.z);
    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(self.transform.scale.x, self.transform.scale.y, self.transform.scale.z);
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(self.transform.position.x, self.transform.position.y, -10);
    
    GLKMatrix4 modelMatrix = GLKMatrix4Multiply(translateMatrix,GLKMatrix4Multiply(scaleMatrix,GLKMatrix4Multiply(zRotationMatrix, GLKMatrix4Multiply(yRotationMatrix, xRotationMatrix))));
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 10, 0, 0, 0, 0, 1, 0);
    
    self.effect.transform.modelviewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
    self.effect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60), 2.0/3.0, 1, 100);
}

- (void)draw
{
    [self.effect prepareToDraw];
    
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
