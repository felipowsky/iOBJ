//
//  OBJParserTests.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 02/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OBJParserTests.h"
#import "Face.h"

@implementation OBJParserTests

- (void)testParseValidOBJShouldReturnMeshObject
{
    NSString *validOBJString = [NSString stringWithString:@"v 0.0 0.0 0.0\nv 0.0  0.0 1.0 \n v  0.0  1.0  0.0"];
    NSData *validOBJData = [validOBJString dataUsingEncoding:NSASCIIStringEncoding];
    OBJParser *parser = [[OBJParser alloc] initWithData:validOBJData];
    
    STAssertTrue([[parser parseAsObject] isKindOfClass:[Mesh class]], @"", nil);
}

- (void)testParseValidOBJWith3VerticesShouldReturnMeshWith3Vertices
{
    NSString *validOBJString = [NSString stringWithString:@"v 0.0 0.0 0.0\nv 0.0 0.0 1.0\nv 0.0 1.0 0.0"];
    NSData *validOBJData = [validOBJString dataUsingEncoding:NSASCIIStringEncoding];
    OBJParser *parser = [[OBJParser alloc] initWithData:validOBJData];
    
    STAssertTrue([[parser parseAsObject].vertices count] == 3, @"", nil);
}

- (void)testParseValidVertexShouldReturnMeshObjectWithVertex
{
    NSString *validOBJString = [NSString stringWithString:@"v 1.0 2.0 3.0"];
    NSData *validOBJData = [validOBJString dataUsingEncoding:NSASCIIStringEncoding];
    OBJParser *parser = [[OBJParser alloc] initWithData:validOBJData];
    
    Mesh *mesh = [parser parseAsObject];
    Point3D *point = [mesh.vertices objectAtIndex:0];
    
    STAssertEquals(point.x, 1.0, @"", nil);
    STAssertEquals(point.y, 2.0, @"", nil);
    STAssertEquals(point.z, 3.0, @"", nil);
}

- (void)testParseValidNormalShouldReturnMeshObjectWithNormal
{
    NSString *validOBJString = [NSString stringWithString:@"vn 0.0 1.0 -1.0"];
    NSData *validOBJData = [validOBJString dataUsingEncoding:NSASCIIStringEncoding];
    OBJParser *parser = [[OBJParser alloc] initWithData:validOBJData];
    
    Mesh *mesh = [parser parseAsObject];
    Vector3D *vector = [mesh.normals objectAtIndex:0];
    STAssertEquals(vector.x, 0.0, @"", nil);
    STAssertEquals(vector.y, 1.0, @"", nil);
    STAssertEquals(vector.z, -1.0, @"", nil);
}

- (void)testParseFaceWithPointAndNormalShouldReturnMeshObjectWithFace
{
    NSMutableString *validOBJString = [[NSMutableString alloc] init];
    
    [validOBJString appendString:@"v 1.0 2.0 3.0\n"];
    [validOBJString appendString:@"v 0.0 1.0 0.0\n"];
    [validOBJString appendString:@"v 1.0 1.0 0.0\n"];
    [validOBJString appendString:@"vn 0.0 0.0 -1.0\n"];
    [validOBJString appendString:@"f 1//1 2//1 3//1"];
    
    NSData *validOBJData = [validOBJString dataUsingEncoding:NSASCIIStringEncoding];
    OBJParser *parser = [[OBJParser alloc] initWithData:validOBJData];
    
    Mesh *mesh = [parser parseAsObject];
    Face *face = [mesh.faces objectAtIndex:0];
    Vertex *vertex0 = [face.vertices objectAtIndex:0];
    
    STAssertTrue([face.vertices count] == 3, @"", nil);
    STAssertEquals(vertex0.point.x, 1.0, @"", nil);
    STAssertEquals(vertex0.point.y, 2.0, @"", nil);
    STAssertEquals(vertex0.point.z, 3.0, @"", nil);
    STAssertEquals(vertex0.normal.x, 0.0, @"", nil);
    STAssertEquals(vertex0.normal.y, 0.0, @"", nil);
    STAssertEquals(vertex0.normal.z, -1.0, @"", nil);
}

@end
