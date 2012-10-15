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
@property (nonatomic, strong) NSArray *sortedMaterials;
@property (nonatomic, strong) NSDictionary *textures;

@end

@implementation GraphicObject

- (id)initWithMesh:(Mesh *)mesh
{
    self = [super init];
    
    if (self) {
        self.mesh = mesh;
        self.effect = [[GLKBaseEffect alloc] init];
        self.textures = [[NSDictionary alloc] init];
        _width = 0.0f;
        _height = 0.0f;
        _depth = 0.0f;
        
        _haveTextures = NO;
        
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
            GLfloat minXF = [minX floatValue];
            GLfloat maxXF = [maxX floatValue];
            
            toOriginX = (minXF + maxXF) / 2.0f;
            _width = maxXF - minXF;
        }
        
        if (maxY != nil && minY != nil) {
            GLfloat minYF = [minY floatValue];
            GLfloat maxYF = [maxY floatValue];
            
            toOriginY = (minYF + maxYF) / 2.0f;
            _height = maxYF - minYF;
        }
        
        if (maxZ != nil && minZ != nil) {
            GLfloat minZF = [minZ floatValue];
            GLfloat maxZF = [maxZ floatValue];
            
            toOriginZ = (minZF + maxZF) / 2.0f;
            _depth = maxZF - minZF;
        }
        
        _transform = [[Transform alloc] initWithToOrigin:GLKVector3Make(-toOriginX, -toOriginY, -toOriginZ)];
        
        NSArray *meshMaterials = self.mesh.materials.allValues;
        
        for (MeshMaterial *meshMaterial in meshMaterials) {
            [self addTextureWithMeshMaterial:meshMaterial];
        }
        
        self.sortedMaterials = meshMaterials;
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
    for (MeshMaterial *meshMaterial in self.sortedMaterials) {
        BOOL haveTexture = NO;
        BOOL haveColors = NO;
        
        if (meshMaterial.material) {
            Material *material = meshMaterial.material;
            
            haveColors = YES;
            
            self.effect.light0.enabled = GL_TRUE;
            self.effect.material.ambientColor = material.ambientColor;
            self.effect.material.diffuseColor = material.diffuseColor;
            self.effect.material.specularColor = material.specularColor;
            
            if (meshMaterial.material.haveTexture) {
                GLKTextureInfo *textureInfo = [self.textures objectForKey:meshMaterial.material.name];
                
                if (textureInfo) {
                    self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
                    self.effect.texture2d0.target = GLKTextureTarget2D;
                    self.effect.texture2d0.name = textureInfo.name;
                    
                    haveTexture = YES;
                }
            }
        }
        
        [self.effect prepareToDraw];
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        
        if (haveColors) {
            glEnableVertexAttribArray(GLKVertexAttribColor);
        }
        
        if (haveTexture) {
            glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        }
        
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, meshMaterial.trianglePoints);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, meshMaterial.triangleNormals);
        
        if (haveColors) {
            glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, meshMaterial.triangleColors);
        }
        
        if (haveTexture) {
            glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, meshMaterial.triangleTextures);
        }
        
        glDrawArrays(GL_TRIANGLES, 0, meshMaterial.trianglePointsLength);
        
        if (haveTexture) {
            glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
        }
        
        if (haveColors) {
            glDisableVertexAttribArray(GLKVertexAttribColor);
        }
        
        glDisableVertexAttribArray(GLKVertexAttribNormal);
        
        glDisableVertexAttribArray(GLKVertexAttribPosition);   
    }
}

- (void)addTextureWithMeshMaterial:(MeshMaterial *)meshMaterial
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
            NSMutableDictionary *newTextures = [NSMutableDictionary dictionaryWithDictionary:self.textures];
            
            [newTextures setObject:textureInfo forKey:meshMaterial.material.name];
            
            self.textures = [NSDictionary dictionaryWithDictionary:newTextures];
            
            _haveTextures = YES;
        }
    }
}

- (void)setSortedMaterials:(NSArray *)sortedMaterials
{
    if (sortedMaterials) {
        /*
         sort meshes:
         1. material with texture
         2. material without texture
         3. no material
         */
        _sortedMaterials = [sortedMaterials sortedArrayUsingComparator:^NSComparisonResult(id anObject, id otherObject) {
            
            MeshMaterial *anMaterial = (MeshMaterial *)anObject;
            MeshMaterial *otherMaterial = (MeshMaterial *)otherObject;
            
            NSComparisonResult result = NSOrderedSame;
            
            if (anMaterial.material && otherMaterial.material) {
                
                if (anMaterial.material.haveTexture && !otherMaterial.material.haveTexture) {
                    result = NSOrderedAscending;
                
                } else if (!anMaterial.material.haveTexture && otherMaterial.material.haveTexture) {
                    result = NSOrderedDescending;
                }
            
            } else if (anMaterial.material && !otherMaterial.material) {
                result = NSOrderedAscending;
                
            } else if (!anMaterial.material && otherMaterial.material) {
                result = NSOrderedDescending;
                
            }
            
            return result;
        }];
        
    } else {
        _sortedMaterials = [[NSArray array] alloc];
    }
}

@end
