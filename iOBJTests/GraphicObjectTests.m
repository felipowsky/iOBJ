//
//  GraphicObjectTests.m
//  iOBJ
//
//  Created by felipowsky on 24/07/12.
//
//

#import "GraphicObjectTests.h"

@implementation GraphicObjectTests

- (void)testInitializeGraphicObjectWithMeshShouldReturnValidObject
{
    GraphicObject *graphicObject = [[GraphicObject alloc] initWithMesh:[[Mesh alloc] init]];
    
    STAssertTrue(graphicObject != nil, @"", nil);
}

- (void)testInitializeGraphicObjectWithMeshShouldHaveSameValues
{
    NSString *validOBJString = @"v 0.0 0.0 0.0\nv 0.0  0.0 1.0 \n v  0.0  1.0  0.0";
    NSData *validOBJData = [validOBJString dataUsingEncoding:NSASCIIStringEncoding];
    OBJParser *parser = [[OBJParser alloc] initWithData:validOBJData];
    
    Mesh *originalMesh = [parser parseAsObject];
    
    GraphicObject *graphicObject = [[GraphicObject alloc] initWithMesh:originalMesh];
    
    STAssertEquals(graphicObject.mesh.points.count, originalMesh.points.count, @"",nil);
    STAssertEquals(graphicObject.mesh.normals.count, originalMesh.normals.count, @"",nil);
    STAssertEquals(graphicObject.mesh.faces.count, originalMesh.faces.count, @"",nil);
}

@end
