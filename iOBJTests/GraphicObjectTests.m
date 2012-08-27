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

- (void)testInitializeGraphicObjectWithMeshShouldHaveAnotherMesh
{
    Mesh *originalMesh = [[Mesh alloc] init];
    GraphicObject *graphicObject = [[GraphicObject alloc] initWithMesh:originalMesh];
    
    STAssertTrue(originalMesh != graphicObject.mesh, @"", nil);
}

- (void)testInitializeGraphicObjectWithMeshShouldHaveSameValues
{
    NSString *validOBJString = @"v 0.0 0.0 0.0\nv 0.0  0.0 1.0 \n v  0.0  1.0  0.0";
    NSData *validOBJData = [validOBJString dataUsingEncoding:NSASCIIStringEncoding];
    OBJParser *parser = [[OBJParser alloc] initWithData:validOBJData];
    
    Mesh *originalMesh = [parser parseAsObject];
    
    GraphicObject *graphicObject = [[GraphicObject alloc] initWithMesh:originalMesh];
    
    STAssertEquals(graphicObject.mesh.pointsLength, originalMesh.pointsLength, @"",nil);
    STAssertEquals(graphicObject.mesh.normalsLength, originalMesh.normalsLength, @"",nil);
    STAssertEquals(graphicObject.mesh.facesLength, originalMesh.facesLength, @"",nil);
    STAssertEquals(graphicObject.mesh.trianglePointsLength, originalMesh.trianglePointsLength, @"",nil);
}

@end
