//
//  LODManager.m
//  iOBJ
//
//  Created by felipowsky on 31/01/13.
//
//

#import "LODManager.h"
#import "GraphicObject.h"
#import "ProgressiveMesh.h"

@interface LODManager ()

@property (nonatomic, strong) GraphicObject *originalGraphicObject;
@property (nonatomic, strong) GraphicObject *graphicObjectWithProgressiveMesh;
@property (nonatomic, strong) ProgressiveMesh *progressiveMesh;

@end

@implementation LODManager

- (id)initWithGraphicObject:(GraphicObject *)graphicObject
{
    self = [super init];
    
    if (self) {
        self.originalGraphicObject = graphicObject;
        self.type = LODManagerTypeNormal;
        self.graphicObjectWithProgressiveMesh = nil;
        self.progressiveMesh = [[ProgressiveMesh alloc] initWithMesh:graphicObject.mesh];
    }
    
    return self;
}

- (void)generateProgressiveMeshWithPercentage:(int)percentage
{
    if (self.originalGraphicObject) {        
        int vertices = self.originalGraphicObject.mesh.points.count * (percentage * 0.01);
        
        Mesh *newMesh = [self.progressiveMesh generateMeshWithVertices:vertices];
        
        self.graphicObjectWithProgressiveMesh = [[GraphicObject alloc] initWithMesh:newMesh];
    }
}

- (GraphicObject *)currentGraphicObject
{
    GraphicObject *graphicObject = self.originalGraphicObject;
    
    if (self.type == LODManagerTypeProgressiveMesh) {
        graphicObject = self.graphicObjectWithProgressiveMesh;
    
    }
    
    return graphicObject;
}

@end
