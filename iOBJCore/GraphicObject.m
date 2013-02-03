//
//  GraphicObject.m
//  iOBJ
//
//  Created by felipowsky on 08/01/12.
//
//

#import "GraphicObject.h"
#import "Shaders.h"

@interface GraphicObject ()

@property (nonatomic, strong) NSArray *sortedMaterials;
@property (nonatomic, strong) NSDictionary *textures;
@property (nonatomic) GLuint shaderProgram;

@end

@implementation GraphicObject

enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_LOOKAT_MATRIX,
    UNIFORM_PERSPECTIVE_MATRIX,
    UNIFORM_TEXTURE2D_ENABLED,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_LIGHT_ENABLED,
    UNIFORM_LIGHT_POSITION,
    NUM_UNIFORMS
};

GLint uniforms[NUM_UNIFORMS];

- (id)initWithMesh:(Mesh *)mesh
{
    self = [super init];
    
    if (self) {
        [self loadShaders];
        
        self.mesh = mesh;
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

- (void)update
{
    [self.transform update];
}

- (void)drawWithDisplayMode:(GraphicObjectDisplayMode)displayMode camera:(Camera *)camera
{
    BOOL textureMode = displayMode == GraphicObjectDisplayModeTexture;
    BOOL solidMode = displayMode == GraphicObjectDisplayModeSolid;
    
    for (MeshMaterial *meshMaterial in self.sortedMaterials) {
        BOOL haveTexture = NO;
        BOOL haveColors = NO;
        
        GLint texture2dEnabled = GL_FALSE;
        GLint lightEnabled = GL_FALSE;
        
        if (meshMaterial.material && (textureMode || solidMode)) {
            haveColors = YES;
            lightEnabled = GL_TRUE;
            
            if (meshMaterial.material.haveTexture && textureMode) {
                GLKTextureInfo *textureInfo = [self.textures objectForKey:meshMaterial.material.name];
                
                if (textureInfo) {
                    texture2dEnabled = GL_TRUE;
                    haveTexture = YES;
                    
                    glActiveTexture(GL_TEXTURE0);
                    glBindTexture(textureInfo.target, textureInfo.name);
                }
            }
        }
        
        glUseProgram(self.shaderProgram);

        glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, self.transform.matrix.m);
        glUniformMatrix4fv(uniforms[UNIFORM_LOOKAT_MATRIX], 1, 0, camera.lookAtMatrix.m);
        glUniformMatrix4fv(uniforms[UNIFORM_PERSPECTIVE_MATRIX], 1, 0, camera.perspectiveMatrix.m);
        
        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(self.transform.matrix), NULL);
        
        glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);
        
        glUniform1i(uniforms[UNIFORM_TEXTURE2D_ENABLED], texture2dEnabled);
        glUniform1i(uniforms[UNIFORM_LIGHT_ENABLED], lightEnabled);
        glUniform3f(uniforms[UNIFORM_LIGHT_POSITION], camera.eyeX, camera.eyeY, camera.eyeZ);
        
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
        
        GLenum mode = GL_TRIANGLES;
        
        switch (displayMode) {
            case GraphicObjectDisplayModePoint:
                mode = GL_POINTS;
                break;
                
            case GraphicObjectDisplayModeWireframe:
                mode = GL_LINES;
                break;
                
            default:
                mode = GL_TRIANGLES;
                break;
        }
        
        glDrawArrays(mode, 0, meshMaterial.trianglePointsLength);
        
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

- (BOOL)loadShaders
{
    self.shaderProgram = glCreateProgram();
    
    GLuint vertexShader;
    
    if (![self compileShader:&vertexShader type:GL_VERTEX_SHADER source:vertexShaderSource]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    GLuint fragmentShader;
    
    if (![self compileShader:&fragmentShader type:GL_FRAGMENT_SHADER source:fragmentShaderSource]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    glAttachShader(self.shaderProgram, vertexShader);
    glAttachShader(self.shaderProgram, fragmentShader);
    
    glBindAttribLocation(self.shaderProgram, GLKVertexAttribPosition, "position");
    glBindAttribLocation(self.shaderProgram, GLKVertexAttribTexCoord0, "texture2d");
    glBindAttribLocation(self.shaderProgram, GLKVertexAttribColor, "color");
    glBindAttribLocation(self.shaderProgram, GLKVertexAttribNormal, "normal");
    
    if (![self linkShaderProgram:self.shaderProgram]) {
        NSLog(@"Failed to link program: %d", self.shaderProgram);
        
        if (vertexShader) {
            glDeleteShader(vertexShader);
            vertexShader = 0;
        }
        
        if (fragmentShader) {
            glDeleteShader(fragmentShader);
            fragmentShader = 0;
        }
        
        if (self.shaderProgram) {
            glDeleteProgram(self.shaderProgram);
            self.shaderProgram = 0;
        }
        
        return NO;
    }
    
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(self.shaderProgram, "modelViewProjectionMatrix");
    uniforms[UNIFORM_LOOKAT_MATRIX] = glGetUniformLocation(self.shaderProgram, "lookAtMatrix");
    uniforms[UNIFORM_PERSPECTIVE_MATRIX] = glGetUniformLocation(self.shaderProgram, "perspectiveMatrix");
    uniforms[UNIFORM_TEXTURE2D_ENABLED] = glGetUniformLocation(self.shaderProgram, "texture2dEnabled");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(self.shaderProgram, "normalMatrix");
    uniforms[UNIFORM_LIGHT_ENABLED] = glGetUniformLocation(self.shaderProgram, "lightEnabled");
    uniforms[UNIFORM_LIGHT_POSITION] = glGetUniformLocation(self.shaderProgram, "lightPosition");
    
    if (vertexShader) {
        glDetachShader(self.shaderProgram, vertexShader);
        glDeleteShader(vertexShader);
    }
    
    if (fragmentShader) {
        glDetachShader(self.shaderProgram, fragmentShader);
        glDeleteShader(fragmentShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(const char*)source
{
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#ifdef DEBUG
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    GLint status;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkShaderProgram:(GLuint)program
{
    glLinkProgram(program);
    
#ifdef DEBUG
    GLint logLength;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
    
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(program, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    GLint status;
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
