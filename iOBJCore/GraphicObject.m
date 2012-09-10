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

@end

@implementation GraphicObject

- (id)initWithMesh:(Mesh *)mesh
{
    self = [super init];
    
    if (self) {
        self.mesh = mesh;
        self.effect = [[GLKBaseEffect alloc] init];
        
        _haveTextures = NO;
        _textures = [[NSDictionary alloc] init];
        
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
        
        for (NSString *key in self.mesh.materials.allKeys) {
            MeshMaterial *meshMaterial = [self.mesh.materials objectForKey:key];
            
            [self addTextureWithMeshMaterial:meshMaterial forKey:key];
        }
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
     
        for (Texture *texture in self.textures.allValues) {
            self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
            self.effect.texture2d0.target = GLKTextureTarget2D;
            self.effect.texture2d0.name = texture.textureInfo.name;
        }
    }
    
    [self.effect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnable(GLKVertexAttribNormal);
    
    if (self.haveTextures) {
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    }
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, self.mesh.trianglePoints);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, self.mesh.triangleNormals);
    
    if (self.haveTextures) {
        
        for (Texture *texture in self.textures.allValues) {
            glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, texture.meshMaterial.triangleTextures);
        }
    }
    
    glDrawArrays(GL_TRIANGLES, 0, self.mesh.trianglePointsLength);
    
    if (self.haveTextures) {
        glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    }
    
    glDisableVertexAttribArray(GLKVertexAttribNormal);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
}

- (void)addTextureWithMeshMaterial:(MeshMaterial *)meshMaterial forKey:(NSString *)key
{
    if (meshMaterial.material.haveTexture) {
        NSString *textureName = meshMaterial.material.diffuseTextureMap;
        
        NSString *filename = [textureName stringByDeletingPathExtension];
        NSString *extension = [textureName pathExtension];
        
        NSString *pathFile = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
        
        NSData *content = [NSData dataWithContentsOfFile:pathFile];
        
        UIImage *image = [UIImage imageWithData:content];
        
        NSError *error;
        
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft];
        
        GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:options error:&error];
        
#ifdef DEBUG
        if (error) {
            NSLog(@"Error loading texture from image: %@", error);
        }
#endif
        
        if (textureInfo) {
            Texture *newTexture = [[Texture alloc] initWithTextureInfo:textureInfo meshMaterial:meshMaterial];
            
            NSMutableDictionary *newTextures = [NSMutableDictionary dictionaryWithDictionary:self.textures];
            
            [newTextures setObject:newTexture forKey:key];
            
            _textures = [NSDictionary dictionaryWithDictionary:newTextures];
            _haveTextures = YES;
        }
    }
}

@end
