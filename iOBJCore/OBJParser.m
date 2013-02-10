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

- (GLKVector3)parsePointWithScanner:(NSScanner *)scanner
{
    GLfloat x = 0.0f;
    GLfloat y = 0.0f;
    GLfloat z = 0.0f;
    
    [scanner scanFloat:&x];
    [scanner scanFloat:&y];
    [scanner scanFloat:&z];
    
    GLKVector3 point = GLKVector3Make(x, y, z);
    
    return point;
}

- (GLKVector3)parseNormalWithScanner:(NSScanner *)scanner
{
    GLfloat x = 0.0f;
    GLfloat y = 0.0f;
    GLfloat z = 0.0f;
    
    [scanner scanFloat:&x];
    [scanner scanFloat:&y];
    [scanner scanFloat:&z];
    
    GLKVector3 normal = GLKVector3Make(x, y, z);
    
    return normal;
}

- (NSArray *)parseFacesWithScanner:(NSScanner *)scanner toMesh:(Mesh *)mesh withMaterial:(Material *)material
{
    NSMutableArray *vertices = [[NSMutableArray alloc] init];
    BOOL haveNormals = mesh.normalsLength > 0;
    NSString *word = nil;
    
    while ([scanner scanWord:&word]) {
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
        
        Vertex *vertex = [[Vertex alloc] init];
        
        int realPointIndex = pointIndex - 1;
        
        GLKVector3 point = mesh.points[realPointIndex];
        vertex.point = point;
        vertex.pointIndex = realPointIndex;
        
        if (textureIndex > 0) {
            int realTextureIndex = textureIndex - 1;
            vertex.texture = mesh.textureCoordinates[realTextureIndex];
            vertex.textureIndex = realTextureIndex;
        }
        
        if (haveNormals) {
            int realNormalIndex = normalIndex - 1;
            GLKVector3 normal = mesh.normals[realNormalIndex];
            vertex.normal = normal;
            vertex.normalIndex = realNormalIndex;
        }
        
        [vertices addObject:vertex];
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    // file format allows any number of vertices, so we tessellate
    for (int i = 1; i+1 < vertices.count; i++) {
        Face3 *face = [[Face3 alloc] init];
        
        [face setVertex:[vertices objectAtIndex:0] atIndex:0];
        [face setVertex:[vertices objectAtIndex:i] atIndex:1];
        [face setVertex:[vertices objectAtIndex:i+1] atIndex:2];
        
        face.material = material;
        
        if (!haveNormals) {
            GLKVector3 normal = [Mesh flatNormalsWithFace:face];
            
            for (int i = 0; i < 3; i++) {
                Vertex *vertex = [face.vertices objectAtIndex:i];
                vertex.normal = normal;
            }
        }
        
        [result addObject:face];
    }
    
    return [NSArray arrayWithArray:result];
}

- (GLKVector2)parseTextureCoordinateWithScanner:(NSScanner *)scanner
{
    GLfloat x = 0.0f;
    GLfloat y = 0.0f;
    
    [scanner scanFloat:&x];
    [scanner scanFloat:&y];
    
    if (x < 0.0f) {
        x = x - floorf(x);
    }
    
    if (y < 0.0f) {
        y = y - floorf(y);
    }
    
    GLKVector2 textureCoordinate = GLKVector2Make(x, y);
    
    return textureCoordinate;
}

- (NSDictionary *)parseMaterialsWithScanner:(NSScanner *)scanner
{
    NSMutableString *word = nil;
    
    [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&word];
    
    NSArray *split = [[word lastPathComponent] componentsSeparatedByString:@"\\"];
    
    NSString *filename = [[split objectAtIndex:split.count-1] stringByDeletingPathExtension];
    
    MaterialParser *parser = [[MaterialParser alloc] initWithFilename:filename];
    return [parser parseMaterialsAsDictionary];
}

- (NSString *)parseUseMaterialWithScanner:(NSScanner *)scanner
{
    NSString *word = nil;
    
    [scanner scanWord:&word];
    
    return word;
}

- (void)parseLine:(NSString *)line toMesh:(Mesh *)mesh materials:(NSDictionary **)materials currentMaterial:(Material **)currentMaterial
{
    NSScanner *scanner = [NSScanner scannerWithString:line];
    NSString *word = nil;
    
    if ([scanner scanWord:&word]) {
        
        if ([word isEqualToString:@"v"]) {
            [mesh addPoint:[self parsePointWithScanner:scanner]];
        
        } else if ([word isEqualToString:@"vn"]) {
            [mesh addNormal:[self parseNormalWithScanner:scanner]];
        
        } else if ([word isEqualToString:@"f"]) {
            
            NSArray *faces = [self parseFacesWithScanner:scanner toMesh:mesh withMaterial:*currentMaterial];
            
            for (Face3 *face in faces) {
                [mesh addFace:face];
            }
            
        } else if ([word isEqualToString:@"vt"]) {
            [mesh addTextureCoordinate:[self parseTextureCoordinateWithScanner:scanner]];
        
        } else if ([word isEqualToString:@"mtllib"]) {
            NSDictionary *newMaterials = [self parseMaterialsWithScanner:scanner];
            
            if (newMaterials) {
                
                if (*materials) {
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
                if (!*currentMaterial) {
                    NSLog(@"Undefined material '%@'", name);
                }
#endif
            }
        
        }
        
    }
}

@end
