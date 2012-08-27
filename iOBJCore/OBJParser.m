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
    
    mesh.materials = [NSDictionary dictionaryWithDictionary:materials];
    
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
    NSMutableData *verticesData = [NSMutableData data];
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
        
        Vertex vertex;
        
        GLKVector3 point = mesh.points[pointIndex-1];
        vertex.point = point;
        
        if (textureIndex > 0) {
            vertex.texture = mesh.textureCoordinates[textureIndex-1];
        }
        
        if (haveNormals) {
            GLKVector3 normal = mesh.normals[normalIndex-1];
            vertex.normal = normal;
        }
        
        [verticesData appendBytes:&vertex length:sizeof(Vertex)];
    }
    
    const Vertex *verticesArray = [verticesData bytes];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    // file format allows any number of vertices, so we tessellate
    for (int i = 1; i+1 < verticesData.length / sizeof(Vertex); i++) {
        Face3 *face = [[Face3 alloc] init];
        
        face.vertices[0] = verticesArray[0];
        face.vertices[1] = verticesArray[i];
        face.vertices[2] = verticesArray[i+1];
        face.material = material;
        
        if (!haveNormals) {
            GLKVector3 normal = [Mesh flatNormalsWithFace:face];
            
            for (int i = 0; i < 3; i++) {
                face.vertices[i].normal = normal;
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
    NSString *word = nil;
    
    [scanner scanWord:&word];
    
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
