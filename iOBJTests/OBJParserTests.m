//
//  OBJParserTests.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 02/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OBJParserTests.h"

@implementation OBJParserTests

- (void)setUp
{
    NSString *validContent = [NSString stringWithString:@"v 0.0 0.0 0.0\nv 0.0  0.0 1.0 \n v  0.0  1.0  0.0"];
    validOBJ = [validContent dataUsingEncoding:NSASCIIStringEncoding];
}

- (void)testParseValidOBJShouldReturnMeshObject
{
    OBJParser *parser = [[OBJParser alloc] initWithData:validOBJ];
    
    STAssertTrue([[parser parseAsObject] isKindOfClass:[Mesh class]], @"", nil);
}

@end
