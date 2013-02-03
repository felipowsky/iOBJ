//
//  LODManager.m
//  iOBJ
//
//  Created by felipowsky on 31/01/13.
//
//

#import "LODManager.h"

@interface LODManager ()

@property (nonatomic, strong) GraphicObject *originalGraphicObject;
@property (nonatomic, strong) GraphicObject *graphicObjectWithProgressiveMesh;

@end

@implementation LODManager

- (id)initWithGraphicObject:(GraphicObject *)graphicObject
{
    self = [super init];
    
    if (self) {
        self.originalGraphicObject = graphicObject;
        self.type = LODManagerTypeNormal;
        self.graphicObjectWithProgressiveMesh = nil;
    }
    
    return self;
}

- (void)generateProgressiveMeshWithPercentual:(int)percentual
{
    if (self.originalGraphicObject) {
        int vertices = self.originalGraphicObject.mesh.pointsLength * (percentual * 0.01);
        GraphicObject *priorGraphicObject = self.graphicObjectWithProgressiveMesh;
        
        if (!priorGraphicObject || priorGraphicObject.mesh.pointsLength != vertices) {
            Mesh *newMesh = [self.originalGraphicObject.mesh copy];
            
            self.graphicObjectWithProgressiveMesh = [[GraphicObject alloc] initWithMesh:newMesh];
        }        
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
