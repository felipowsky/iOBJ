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
@property (nonatomic) BOOL haveTextures;

@end

@implementation GraphicObject

- (id)initWithMesh:(Mesh *)mesh
{
    self = [super init];
    
    if (self) {
        self.mesh = [mesh copy];
        self.effect = [[GLKBaseEffect alloc] init];
        
        NSArray *materialValues = self.mesh.materials.allValues;
        
        self.haveTextures = NO;
        
        for (int i = 0; i < materialValues.count && !self.haveTextures; i++) {
            Material *material = [materialValues objectAtIndex:i];
            
            if (![material.diffuseTextureMap isEqualToString:@""]) {
                self.haveTextures = YES;
            }
        }
        
        if (materialValues.count == 1) {
            Material *material = [materialValues objectAtIndex:0];
            NSString *textureName = material.diffuseTextureMap;
            
            NSString *filename = [textureName stringByDeletingPathExtension];
            NSString *extension = [textureName pathExtension];
            
            NSString *pathFile = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
            
            NSData *content = [NSData dataWithContentsOfFile:pathFile];
            
            self.textureImage = [UIImage imageWithData:content];
        }
#ifdef DEBUG
        else if (materialValues.count > 1) {
            NSLog(@"More then one material defined, no support yet.");
        }
#endif
        
        NSNumber *maxX = nil;
        NSNumber *minX = nil;
        NSNumber *maxY = nil;
        NSNumber *minY = nil;
        NSNumber *maxZ = nil;
        NSNumber *minZ = nil;
        
        int pointsLength = self.mesh.pointsLength;
        
        for (int i = 0; i < pointsLength; i++) {
            GLKVector3 point = self.mesh.points[i];
            
            if (maxX == nil || point.x > [maxX floatValue]) {
                maxX = [NSNumber numberWithFloat:point.x];
            }
            
            if (maxY == nil || point.y > [maxY floatValue]) {
                maxY = [NSNumber numberWithFloat:point.y];
            }
            
            if (maxZ == nil || point.z > [maxZ floatValue]) {
                maxZ = [NSNumber numberWithFloat:point.z];
            }
            
            if (minX == nil || point.x < [minX floatValue]) {
                minX = [NSNumber numberWithFloat:point.x];
            }
            
            if (minY == nil || point.y < [minY floatValue]) {
                minY = [NSNumber numberWithFloat:point.y];
            }
            
            if (minZ == nil || point.z < [minZ floatValue]) {
                minZ = [NSNumber numberWithFloat:point.z];
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
    if (self.haveTextures) {
        self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
        self.effect.texture2d0.target = GLKTextureTarget2D;
        self.effect.texture2d0.name = self.texture.name;
    }
    
    [self.effect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnable(GLKVertexAttribNormal);
    
    if (self.haveTextures) {
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    }
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, self.mesh.trianglePoints);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, self.mesh.triangleNormals);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, self.mesh.triangleTextures);
    
    glDrawArrays(GL_TRIANGLES, 0, self.mesh.trianglePointsLength);
    
    if (self.haveTextures) {
        glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    }
    
    glDisableVertexAttribArray(GLKVertexAttribNormal);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
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
