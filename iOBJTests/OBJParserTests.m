//
//  OBJParserTests.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 02/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OBJParserTests.h"

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
    NSString *validOBJString = [NSString stringWithString:@"v 0.0 0.0 0.0\nv 0.0  0.0 1.0 \n v  0.0  1.0  0.0"];
    NSData *validOBJData = [validOBJString dataUsingEncoding:NSASCIIStringEncoding];
    OBJParser *parser = [[OBJParser alloc] initWithData:validOBJData];
    
    STAssertTrue([[parser parseAsObject].vertices count] == 3, @"", nil);
}

@end
