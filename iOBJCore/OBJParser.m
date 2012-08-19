//
//  OBJParser.m
//  iOBJ
//
//  Created by felipowsky on 03/01/12.
//
//

#import "OBJParser.h"

@implementation OBJParser

- (id)initWithFilename:(NSString *)filename
{
    self = [super initWithFilename:filename ofType:@"obj"];
    
    if (self) {
    }
    
    return self;
}

- (Mesh *)parseAsObject
{
    NSString *objString = [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding];
    NSArray *lines = [objString componentsSeparatedByString:@"\n"];
    
    Mesh *mesh = [[Mesh alloc] init];
    NSDictionary *materials = [[NSDictionary alloc] init];
    Material *currentMaterial = nil;
    
    for (NSString *line in lines) {
        
        NSString *lineWithoutComments = [[line componentsSeparatedByString:@"#"] objectAtIndex:0];
        [self parseLine:lineWithoutComments toMesh:mesh materials:&materials currentMaterial:&currentMaterial];
    }
    
    return mesh;
}

- (void)parseAsObjectWithMesh:(Mesh *)mesh
{
    NSString *objString = [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding];
    NSArray *lines = [objString componentsSeparatedByString:@"\n"];
    
    NSDictionary *materials = [[NSDictionary alloc] init];
    Material *currentMaterial = nil;
        
   for (NSString *line in lines) {
        
        NSString *lineWithoutComments = [[line componentsSeparatedByString:@"#"] objectAtIndex:0];
       [self parseLine:lineWithoutComments toMesh:mesh materials:&materials currentMaterial:&currentMaterial];
    }
}

- (GLKVector3)parseVertexPointWithScanner:(NSScanner *)scanner
{
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    
    [scanner scanFloat:&x];
    [scanner scanFloat:&y];
    [scanner scanFloat:&z];
    
    GLKVector3 point = GLKVector3Make(x, y, z);
    
    return point;
}

- (GLKVector3)parseNormalWithScanner:(NSScanner *)scanner
{
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    
    [scanner scanFloat:&x];
    [scanner scanFloat:&y];
    [scanner scanFloat:&z];
    
    GLKVector3 normal = GLKVector3Make(x, y, z);
    
    return normal;
}

- (Face3 *)parseFaceWithScanner:(NSScanner *)scanner toMesh:(Mesh *)mesh withMaterial:(Material *)material
{
    NSString *word = nil;
    Face3 *face = [[Face3 alloc] init];
    face.material = material;
    BOOL haveNormals = mesh.normalsLength > 0;
    GLKVector3 *textures = nil;
    
    for (int i = 0; i < 3; i++) {
        word = [self nextWordWithScanner:scanner];
        NSScanner *vertexScanner = [NSScanner scannerWithString:word];
        
        int pointIndex = 1;
        int normalIndex = 1;
        int textureIndex = 0;
        
        /*
         formats:
         point/texture/normal
         point/texture/
         point/texture
         point//normal
         point//
         point/
         point
         */
        [vertexScanner scanInt:&pointIndex];
        
        if ([vertexScanner scanString:@"/" intoString:NULL]) {
            if (![vertexScanner scanInt:&textureIndex]) {
                textureIndex = 0;
            }
        }
        
        if ([vertexScanner scanString:@"/" intoString:NULL]) {
            if (![vertexScanner scanInt:&normalIndex]) {
                normalIndex = 1;
            }
        }
        
        Vertex vertex;
        
        GLKVector3 point = mesh.vertices[pointIndex-1];
        vertex.point = point;
        
        if (textureIndex > 0) {
            
            if (!textures) {
                textures = malloc(sizeof(GLKVector3) * 3);
            }
            
            textures[i] = mesh.textureCoordinates[textureIndex-1];
        }
        
        if (haveNormals) {
            GLKVector3 normal = mesh.normals[normalIndex-1];
            vertex.normal = normal;
        }
        
        face.vertices[i] = vertex;
    }
    
    if (textures) {
        for (int i = 0; i < 3; i++) {
            [face addTexture:textures[i] atIndex:i];
        }
        
        free(textures);
    }
    
    if (!haveNormals) {
        GLKVector3 normal = [Mesh flatNormalsWithFace:face];
        
        for (int i = 0; i < 3; i++) {
            face.vertices[i].normal = normal;
        }
    }
    
    return face;
}

- (GLKVector3)parseTextureCoordinateWithScanner:(NSScanner *)scanner
{
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    
    [scanner scanFloat:&x];
    [scanner scanFloat:&y];
    
    GLKVector3 textureCoordinate = GLKVector3Make(x, y, z);
    
    return textureCoordinate;
}

- (NSDictionary *)parseMaterialsWithScanner:(NSScanner *)scanner
{
    MaterialParser *parser = [[MaterialParser alloc] initWithFilename:self.filename];
    return [parser parseMaterialsAsDictionary];
}

- (NSString *)parseUseMaterialWithScanner:(NSScanner *)scanner
{
    return [self nextWordWithScanner:scanner];
}

- (void)parseLine:(NSString *)line toMesh:(Mesh *)mesh materials:(NSDictionary **)materials currentMaterial:(Material **)currentMaterial
{
    NSScanner *scanner = [NSScanner scannerWithString:line];
    NSString *word = [self nextWordWithScanner:scanner];
    
    if (word) {
        
        if ([word isEqualToString:@"v"]) {
            [mesh addVertex:[self parseVertexPointWithScanner:scanner]];
        
        } else if ([word isEqualToString:@"vn"]) {
            [mesh addNormal:[self parseNormalWithScanner:scanner]];
        
        } else if ([word isEqualToString:@"f"]) {
            [mesh addFace:[self parseFaceWithScanner:scanner toMesh:mesh withMaterial:*currentMaterial]];
            
        } else if ([word isEqualToString:@"vt"]) {
            [mesh addTextureCoordinate:[self parseTextureCoordinateWithScanner:scanner]];
            
        
        } else if ([word isEqualToString:@"mtllib"]) {
            NSDictionary *newMaterials = [self parseMaterialsWithScanner:scanner];
            
            if (newMaterials) {
                
                if (materials) {
                    NSMutableDictionary *combination = [NSMutableDictionary dictionaryWithDictionary:newMaterials];
                    [combination addEntriesFromDictionary:*materials];
                    
                    *materials = [[NSDictionary alloc] initWithDictionary:combination];
                    
                }
                
            }
            
        } else if ([word isEqualToString:@"usemtl"]) {
            NSString *name = [self parseUseMaterialWithScanner:scanner];
            
            if (materials) {
                *currentMaterial = [*materials objectForKey:name];
                
#ifdef DEBUG
                if (!currentMaterial) {
                    NSLog(@"Undefined material '%@'", name);
                }
#endif
            }
        }
        
    }
}

@end
