//
//  LODManager.h
//  iOBJ
//
//  Created by felipowsky on 31/01/13.
//
//

#import <Foundation/Foundation.h>

@class GraphicObject, Camera;

typedef enum {
    LODManagerTypeNormal,
    LODManagerTypeProgressiveMesh,
    LODManagerTypeProgressiveMeshCache,
} LODManagerType;

@interface LODManager : NSObject

@property (nonatomic, readonly, strong) GraphicObject *currentGraphicObject;
@property (nonatomic, readonly) GLuint verticesCount;
@property (nonatomic) LODManagerType type;

- (id)initWithGraphicObject:(GraphicObject *)graphicObject;
- (void)generateProgressiveMeshWithPercentage:(GLuint)percentage cache:(BOOL)cache completion:(void (^)(BOOL finished))completion;

@end
