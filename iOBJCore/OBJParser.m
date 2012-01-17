//
//  OBJParser.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OBJParser.h"

@interface OBJParser ()

@property (strong) NSData *data;

- (void)parseLine:(NSString *)line toMesh:(const Mesh **)mesh;
- (Point3D *)parseVertexPointWithScanner:(const NSScanner **)scanner;
- (Vector3D *)parseNormalWithScanner:(const NSScanner **)scanner;
- (Face *)parseFaceWithScanner:(const NSScanner **)scanner toMesh:(const Mesh **)mesh;
- (NSString *)nextWordWithScanner:(const NSScanner **)scanner;

@end

@implementation OBJParser

@synthesize data = _data;

- (id)initWithData:(NSData *)data
{
    self = [super init];
    
    if (self) {
        self.data = data;
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
        [self parseLine:lineWithoutComments toMesh:&mesh];
    }
    
    return mesh;
}

- (Point3D *)parseVertexPointWithScanner:(const NSScanner **)scanner
{
    double x = 0.0;
    double y = 0.0;
    double z = 0.0;
    
    [*scanner scanDouble:&x];
    [*scanner scanDouble:&y];
    [*scanner scanDouble:&z];
    
    return [[Point3D alloc] initWith:x y:y z:z];
}

- (Vector3D *)parseNormalWithScanner:(const NSScanner **)scanner
{
    double x = 0.0;
    double y = 0.0;
    double z = 0.0;
    
    [*scanner scanDouble:&x];
    [*scanner scanDouble:&y];
    [*scanner scanDouble:&z];
    
    return [[Vector3D alloc] initWith:x y:y z:z];
}

- (Face *)parseFaceWithScanner:(const NSScanner **)scanner toMesh:(const Mesh **)mesh
{
    NSMutableArray *vertices = [[NSMutableArray alloc] init];
    NSString *word = nil;
    
    while ((word = [self nextWordWithScanner:scanner]) != nil) {
        NSScanner *vertexScanner = [NSScanner scannerWithString:word];
        
        int pointIndex = 0;
        int normalIndex = 0;
        
        // for now we're dealing only with format: point//normal
        [vertexScanner scanInt:&pointIndex];
        [vertexScanner scanString:@"/" intoString:nil];
        [vertexScanner scanString:@"/" intoString:nil];
        [vertexScanner scanInt:&normalIndex];
        
        Point3D *point = [(*mesh).vertices objectAtIndex:pointIndex-1];
        Vector3D *normal = [(*mesh).normals objectAtIndex:normalIndex-1];
        
        Vertex *vertex = [[Vertex alloc] initWithPoint:point normal:normal];
        [vertices addObject:vertex];
    }
    
    return [[Face alloc] initWithVertices:vertices];
}

- (void)parseLine:(NSString *)line toMesh:(const Mesh **)mesh
{
    NSScanner *scanner = [NSScanner scannerWithString:line];
    NSString *word = [self nextWordWithScanner:&scanner];
    
    if (word != nil) {
        
        if ([word isEqualToString:@"v"]) {
            [(*mesh).vertices addObject:[self parseVertexPointWithScanner:&scanner]];
        
        } else if ([word isEqualToString:@"vn"]) {
            [(*mesh).normals addObject:[self parseNormalWithScanner:&scanner]];
        
        } else if ([word isEqualToString:@"f"]) {
            [(*mesh).faces addObject:[self parseFaceWithScanner:&scanner toMesh:mesh]];
        }
        
    }
}

- (NSString *)nextWordWithScanner:(const NSScanner **)scanner
{
    NSString *word = nil;
    [*scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&word];
    
    return word;
}

@end
