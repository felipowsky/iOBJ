//
//  GraphicObject.m
//  iOBJ
//
//  Created by Silvio Fragnani da Silva on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphicObject.h"

@interface GraphicObject ()

@property (strong, nonatomic) GLKBaseEffect *effect;
@property (nonatomic) GLKVector4 *colors;
@property (strong, nonatomic) GLKTextureInfo *texture;
@property (strong, nonatomic) NSMutableData *textureCoordinateData;

@end

@implementation GraphicObject

- (id)initWithMesh:(const Mesh *)mesh
{
    self = [super init];
    
    if (self) {
        self.mesh = [mesh copy];
        self.effect = [[GLKBaseEffect alloc] init];
        self.texture = nil;
        _transform = [[Transform alloc] init];
        
        self.colors = (GLKVector4 *) malloc(self.mesh.triangleVerticesLength * sizeof(GLKVector4));
        
        // necessary to generate random numbers
        /*srand(time(NULL));
        
        for (int i = 0; i < self.mesh.triangleVerticesLength; i++) {
            double red = rand() % 9;
            double green = rand() % 9;
            double blue = rand() % 9;
            
            self.colors[i] = GLKVector4Make(red / 10.0, green / 10.0, blue / 10.0, 1.0);
        }*/
    }
    
    return self;
}

- (void)updateWithCamera:(const Camera *)camera
{
    GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(self.transform.rotation.x);
    GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(self.transform.rotation.y);
    GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(self.transform.rotation.z);
    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(self.transform.scale.x, self.transform.scale.y, self.transform.scale.z);
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(self.transform.position.x, self.transform.position.y, self.transform.position.z);
    
    GLKMatrix4 modelMatrix = GLKMatrix4Multiply(translateMatrix,GLKMatrix4Multiply(scaleMatrix,GLKMatrix4Multiply(zRotationMatrix, GLKMatrix4Multiply(yRotationMatrix, xRotationMatrix))));
    
    self.effect.transform.modelviewMatrix = GLKMatrix4Multiply(camera.lookAtMatrix, modelMatrix);
    self.effect.transform.projectionMatrix = camera.perspectiveMatrix;
}

- (void)draw
{
    [self.effect prepareToDraw];
    
    if (self.texture) {
        self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
        self.effect.texture2d0.target = GLKTextureTarget2D;
        self.effect.texture2d0.name = self.texture.name;
        
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        
        GLfloat t[72][2] = {
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
            {0,0}, {1,0}, {1,1}, {0,0}, {1,1}, {0,1},
        };
        
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, t);
    }
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, self.mesh.triangleVertices);
    
    //glEnableVertexAttribArray(GLKVertexAttribColor);
    //glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, self.colors);
    
    glDrawArrays(GL_TRIANGLES, 0, self.mesh.triangleVerticesLength);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    
    if (self.texture) {
        glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    }
}

- (void)setTextureImage:(UIImage *)textureImage
{
    _textureImage = textureImage;
    
    NSError *error;
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft];
    
    self.texture = [GLKTextureLoader textureWithCGImage:textureImage.CGImage options:options error:&error];
    
#ifdef DEBUG
    if (error) {
        NSLog(@"Error loading texture from image: %@", error);
    }
#endif
    
}

- (GLKVector2 *)textureCoordinates
{
    if (self.textureCoordinateData == nil) {
        self.textureCoordinateData = [NSMutableData dataWithLength:sizeof(GLKVector2) * self.mesh.verticesLength];
    }
    
    return [self.textureCoordinateData mutableBytes];
}

- (void)dealloc
{
    free(self.colors);
}

@end
