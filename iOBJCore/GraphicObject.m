//
//  GraphicObject.m
//  iOBJ
//
//  Created by Silvio Fragnani da Silva on 08/01/12.
//
//

#import "GraphicObject.h"

@interface GraphicObject ()

@property (nonatomic, strong) GLKBaseEffect *effect;
@property (nonatomic, strong) GLKTextureInfo *texture;

@end

@implementation GraphicObject

- (id)initWithMesh:(Mesh *)mesh
{
    self = [super init];
    
    if (self) {
        self.mesh = [mesh copy];
        self.effect = [[GLKBaseEffect alloc] init];
        self.textureImage = [UIImage imageNamed:@"Barrel_Ex_diff.tga"];
        
        NSNumber *maxX = nil;
        NSNumber *minX = nil;
        NSNumber *maxY = nil;
        NSNumber *minY = nil;
        NSNumber *maxZ = nil;
        NSNumber *minZ = nil;
        
        int verticesLength = self.mesh.verticesLength;
        
        for (int i = 0; i < verticesLength; i++) {
            GLKVector3 vertex = self.mesh.vertices[i];
            
            if (maxX == nil || vertex.x > [maxX floatValue]) {
                maxX = [NSNumber numberWithFloat:vertex.x];
            }
            
            if (maxY == nil || vertex.y > [maxY floatValue]) {
                maxY = [NSNumber numberWithFloat:vertex.y];
            }
            
            if (maxZ == nil || vertex.z > [maxZ floatValue]) {
                maxZ = [NSNumber numberWithFloat:vertex.z];
            }
            
            if (minX == nil || vertex.x < [minX floatValue]) {
                minX = [NSNumber numberWithFloat:vertex.x];
            }
            
            if (minY == nil || vertex.y < [minY floatValue]) {
                minY = [NSNumber numberWithFloat:vertex.y];
            }
            
            if (minZ == nil || vertex.z < [minZ floatValue]) {
                minZ = [NSNumber numberWithFloat:vertex.z];
            }
        }
        
        GLfloat toOriginX = 0.0f;
        GLfloat toOriginY = 0.0f;
        GLfloat toOriginZ = 0.0f;
        
        if (maxX != nil && minX != nil) {
            toOriginX = ([minX floatValue] + [maxX floatValue]) / 2.0f;
        }
        
        if (maxY != nil && minY != nil) {
            toOriginY = ([minY floatValue] + [maxY floatValue]) / 2.0f;
        }
        
        if (maxZ != nil && minZ != nil) {
            toOriginZ = ([minZ floatValue] + [maxZ floatValue]) / 2.0f;
        }
        
        _transform = [[Transform alloc] initWithToOrigin:GLKVector3Make(-toOriginX, -toOriginY, -toOriginZ)];
    }
    
    return self;
}

- (void)update:(NSTimeInterval)deltaTime camera:(Camera *)camera
{
    [self.transform update];
    
    self.effect.transform.modelviewMatrix = GLKMatrix4Multiply(camera.lookAtMatrix, self.transform.matrix);
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
        
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, self.mesh.triangleTextures);
    }
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, self.mesh.triangleVertices);
    
    glDrawArrays(GL_TRIANGLES, 0, self.mesh.triangleVerticesLength);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    
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

@end
