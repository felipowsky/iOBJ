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
@property (nonatomic) GLuint lastProgressivePercentage;

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
        self.lastProgressivePercentage = 100;
    }
    
    return self;
}

- (void)generateProgressiveMeshWithPercentage:(GLuint)percentage cache:(BOOL)cache completion:(void (^)(BOOL finished))completion
{
    if (self.originalGraphicObject && percentage < 100) {
        GLuint vertices = self.originalGraphicObject.mesh.points.count * (percentage * 0.01f);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Mesh *newMesh = [self.progressiveMesh generateMeshWithVertices:vertices cache:cache];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL finished = NO;
                
                @try {
                    self.graphicObjectWithProgressiveMesh = [[GraphicObject alloc] initWithMesh:newMesh];
                
                    self.lastProgressivePercentage = percentage;
                    
                    finished = YES;
                    
                } @finally {
                    if (completion) {
                        completion(finished);
                    }
                }
            });
        });
    
    } else {
        if (completion) {
            completion(YES);
        }
    }
}

- (GraphicObject *)currentGraphicObject
{
    GraphicObject *graphicObject = self.originalGraphicObject;
    
    switch (self.type) {
        case LODManagerTypeNormal: {
            graphicObject = self.originalGraphicObject;
        }
            break;
        case LODManagerTypeProgressiveMesh:
        case LODManagerTypeProgressiveMeshCache: {
            if (self.lastProgressivePercentage < 100) {
                graphicObject = self.graphicObjectWithProgressiveMesh;
            
            } else {
                graphicObject = self.originalGraphicObject;
            }
        }
            break;
            
        default: {
            graphicObject = self.originalGraphicObject;
        }
            break;
    }
    
    return graphicObject;
}

- (GLuint)verticesCount
{
    GLuint vertices = 0;
    
    switch (self.type) {
        case LODManagerTypeNormal: {
            vertices = self.currentGraphicObject.mesh.points.count;
        }
            break;
        case LODManagerTypeProgressiveMesh:
        case LODManagerTypeProgressiveMeshCache: {
            vertices = self.originalGraphicObject.mesh.points.count * (self.lastProgressivePercentage * 0.01f);
        }
            break;
            
        default: {
            vertices = self.currentGraphicObject.mesh.points.count;
        }
            break;
    }
    
    return vertices;
}

@end
