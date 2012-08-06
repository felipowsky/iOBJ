//
//  OBJParser.m
//  iOBJ
//
//  Created by felipowsky on 03/01/12.
//
//

#import "OBJParser.h"

@interface OBJParser ()

@property (nonatomic, strong) NSData *data;

@end

@implementation OBJParser

- (id)initWithData:(const NSData *)data
{
    self = [super init];
    
    if (self) {
        self.data = [data copy];
    }
    
    return self;
}

- (Mesh *)parseAsObject
{
    NSString *objString = [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding];
    NSArray *lines = [objString componentsSeparatedByString:@"\n"];
    
    Mesh *mesh = [[Mesh alloc] init];
    
    for (NSString *line in lines) {
        
        NSString *lineWithoutComments = [[line componentsSeparatedByString:@"#"] objectAtIndex:0];
        [self parseLine:lineWithoutComments toMesh:mesh];
    }
    
    return mesh;
}

- (void)parseAsObjectWithMesh:(const Mesh *)mesh
{
    NSString *objString = [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding];
    NSArray *lines = [objString componentsSeparatedByString:@"\n"];
    
   for (NSString *line in lines) {
        
        NSString *lineWithoutComments = [[line componentsSeparatedByString:@"#"] objectAtIndex:0];
        [self parseLine:lineWithoutComments toMesh:mesh];
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

- (Face)parseFaceWithScanner:(const NSScanner *)scanner toMesh:(const Mesh *)mesh
{
    NSString *word = nil;
    Face face;
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

- (void)parseLine:(NSString *)line toMesh:(const Mesh *)mesh
{
    NSScanner *scanner = [NSScanner scannerWithString:line];
    NSString *word = [self nextWordWithScanner:scanner];
    
    if (word) {
        
        if ([word isEqualToString:@"v"]) {
            [mesh addVertex:[self parseVertexPointWithScanner:scanner]];
        
        } else if ([word isEqualToString:@"vn"]) {
            [mesh addNormal:[self parseNormalWithScanner:scanner]];
        
        } else if ([word isEqualToString:@"f"]) {
            [mesh addFace:[self parseFaceWithScanner:scanner toMesh:mesh]];
        
        } else if ([word isEqualToString:@"mtllib"]) {
            
            
        }
        
    }
}

- (NSString *)nextWordWithScanner:(const NSScanner *)scanner
{
    NSString *word = nil;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&word];
    
    return word;
}

@end
