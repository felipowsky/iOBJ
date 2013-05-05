//
//  ViewDependentMesh.m
//  iOBJ
//
//  Created by felipowsky on 19/03/13.
//
//

#import "ViewDependentMesh.h"
#import "Mesh.h"
#import "Camera.h"
#import "GraphicObject.h"

#import "vds.h"
#import "stdvds.h"
#import "path.h"
#import "vdsprivate.h"
#import "vector.h"
#import "Face3.h"
#import "Vertex.h"
#import "Material.h"

@interface ViewDependentMesh ()

@property (nonatomic, weak) GraphicObject *originalGraphicObject;
@property (nonatomic) vdsNode *vertexTree;

@end

@implementation ViewDependentMesh

typedef float Matrix4[4][4];

- (id)initWithGraphicObject:(GraphicObject *)graphicObject
{
    self = [super init];
    
    if (self) {
        self.originalGraphicObject = graphicObject;
        self.vertexTree = nil;
    }
    
    return self;
}

- (void)dealloc
{
    free(_vertexTree);
}

- (Mesh *)generateMeshWithCamera:(Camera *)camera
{
    if (!self.vertexTree) {
        [self generateVertexTree];
    }
    
    Matrix4 viewmat, invviewmat;
    vdsVec3 eyept, viewvector;
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            viewmat[i][j] = self.originalGraphicObject.transform.matrix.m[i*j];
        }
    }
    
    mat4Inverse(invviewmat, viewmat);
    
    eyept[0] = invviewmat[3][0];
    eyept[1] = invviewmat[3][1];
    eyept[2] = invviewmat[3][2];
    viewvector[0] = invviewmat[2][0];
    viewvector[1] = invviewmat[2][1];
    viewvector[2] = invviewmat[2][2];
    
    VEC3_NORMALIZE(viewvector);
    
    vdsSetViewpoint(eyept);
    vdsSetLookVec(viewvector);
    vdsSetFOV(camera.fovyDegrees * M_PI / 180);
    vdsSetThreshold(0.01);
    vdsAdjustTreeBoundary(_vertexTree, vdsThresholdTest);
    
    renderTree(_vertexTree, vdsSimpleVisibility);
    
    return nil;
}

void renderTree(vdsNode *node, vdsVisibilityFunction visible)
{
    vdsNode *child;
    
    if (visible != NULL) {
        int visibility = visible(node);
        
        if (visibility == 0) {
            /* Node invisible, return */
            NSLog(@"NOT visible: %.2f, %.2f, %.2f", node->coord[0], node->coord[1], node->coord[2]);
            return;
        } else if (visibility == 2) {
            /* Node completely visible, turn off visibility checking */
            visible = NULL;
        }
    }
    /* If we got this far, node is visible.  Render it */
    //render(node);
    NSLog(@"visible: %.2f, %.2f, %.2f", node->coord[0], node->coord[1], node->coord[2]);
    /* If node is at VDS_CULLDEPTH, children have no vistris, so can return */
    if (node->depth == VDS_CULLDEPTH) {
        return;
    }
    
    child = node->children;
    
    while (child != NULL) {
        renderTree(child, visible);
        child = child->sibling;
    }
}

- (void)generateVertexTree
{
    vdsBeginVertexTree();
    vdsBeginGeometry();
    
    Mesh *originalMesh = self.originalGraphicObject.mesh;
    
    int pointsLength = originalMesh.points.count;
    
    for (int i = 0; i < pointsLength; i++) {
        NSValue *pointValue = [originalMesh.points objectAtIndex:i];
        GLKVector3 point;
        [pointValue getValue:&point];
        
        vdsAddNode(point.x, point.y, point.z);
    }
    
    for (int i = 0; i < originalMesh.faces.count; i++) {
        Face3 *face = [originalMesh.faces objectAtIndex:i];
        
        Vertex *vertex0 = [face.vertices objectAtIndex:0];
        Vertex *vertex1 = [face.vertices objectAtIndex:1];
        Vertex *vertex2 = [face.vertices objectAtIndex:2];
        
        vdsVec3 n0 = {vertex0.normal.x, vertex0.normal.y, vertex0.normal.z};
        vdsVec3 n1 = {vertex1.normal.x, vertex1.normal.y, vertex1.normal.z};
        vdsVec3 n2 = {vertex2.normal.x, vertex2.normal.y, vertex2.normal.z};
        
        vdsByte3 c0 = {0, 0, 0};
        vdsByte3 c1 = {0, 0, 0};
        vdsByte3 c2 = {0, 0, 0};
        
        vdsAddTri(vertex0.pointIndex, vertex1.pointIndex, vertex2.pointIndex, n0, n1, n2, c0, c1, c2);
    }
    
    vdsNode *nodes = vdsEndGeometry();
    vdsNode **nodesPtrs = NULL;
    
    nodesPtrs = (vdsNode **) malloc(sizeof(vdsNode *) * pointsLength);
    
    for (int i = 0; i < pointsLength; i++) {
        nodesPtrs[i] = &nodes[i];
    }
    
    clusterOctree(nodesPtrs, pointsLength, 0);
    self.vertexTree = vdsEndVertexTree();
    
    free(nodesPtrs);
}

@end
