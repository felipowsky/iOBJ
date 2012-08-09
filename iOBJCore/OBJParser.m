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

- (void)parseAsObjectWithMesh:(const Mesh *)mesh
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

- (Point3D)parseVertexPointWithScanner:(const NSScanner *)scanner
{
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    
    [scanner scanFloat:&x];
    [scanner scanFloat:&y];
    [scanner scanFloat:&z];
    
    Point3D point;
    point.x = x;
    point.y = y;
    point.z = z;
    
    return point;
}

- (Vector3D)parseNormalWithScanner:(const NSScanner *)scanner
{
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    
    [scanner scanFloat:&x];
    [scanner scanFloat:&y];
    [scanner scanFloat:&z];
    
    Vector3D normal;
    normal.x = x;
    normal.y = y;
    normal.z = z;
    
    return normal;
}

- (Face3D *)parseFaceWithScanner:(const NSScanner *)scanner toMesh:(const Mesh *)mesh withMaterial:(Material *)material
{
    NSString *word = nil;
    Face3D *face = [[Face3D alloc] init];
    face.material = material;
    BOOL haveNormals = mesh.normalsLength > 0;
    
    for (int i = 0; i < 3; i++) {
        word = [self nextWordWithScanner:scanner];
        NSScanner *vertexScanner = [NSScanner scannerWithString:word];
        
        int pointIndex = 1;
        int normalIndex = 1;
        int textureIndex = 1;
        
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
        
        if ([vertexScanner scanString:@"/" intoString:nil]) {
            if (![vertexScanner scanInt:&textureIndex]) {
                textureIndex = 1;
            }
        }
        
        if ([vertexScanner scanString:@"/" intoString:nil]) {
            if (![vertexScanner scanInt:&normalIndex]) {
                normalIndex = 1;
            }
        }
        
        Vertex vertex;
        
        Point3D point = mesh.vertices[pointIndex-1];
        vertex.point = point;
        
        if (haveNormals) {
           Vector3D normal = mesh.normals[normalIndex-1];
            vertex.normal = normal;
        }
        
        face.vertices[i] = vertex;
    }
    
    if (!haveNormals) {
        Vector3D normal = [Mesh flatNormalsWithFace:face];
        
        for (int i = 0; i < 3; i++) {
            face.vertices[i].normal = normal;
        }
    }
    
    return face;
}

- (NSDictionary *)parseMaterialsWithScanner:(const NSScanner *)scanner
{
    MaterialParser *parser = [[MaterialParser alloc] initWithFilename:self.filename];
    return [parser parseMaterialsAsDictionary];
}

- (NSString *)parseUseMaterialWithScanner:(const NSScanner *)scanner
{
    return [self nextWordWithScanner:scanner];
}

- (void)parseLine:(NSString *)line toMesh:(const Mesh *)mesh materials:(NSDictionary **)materials currentMaterial:(Material **)currentMaterial
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
        
        } else if ([word isEqualToString:@"mtllib"]) {
            NSDictionary *newMaterials = [self parseMaterialsWithScanner:scanner];
            
            if (newMaterials) {
                
                if (materials) {
                    NSMutableDictionary *combination = [NSMutableDictionary dictionaryWithDictionary:newMaterials];
                    [combination addEntriesFromDictionary:*materials];
                    
                    *materials = [[NSDictionary alloc] initWithDictionary:combination];
                    
                } else {
                    *materials = [[NSDictionary alloc] initWithDictionary:newMaterials];
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
