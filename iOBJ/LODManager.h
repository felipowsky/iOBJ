//
//  LODManager.h
//  iOBJ
//
//  Created by felipowsky on 31/01/13.
//
//

#import <Foundation/Foundation.h>

@class GraphicObject;

typedef enum {
    LODManagerTypeNormal,
    LODManagerTypeProgressiveMesh,
} LODManagerType;

@interface LODManager : NSObject

@property (nonatomic, readonly, strong) GraphicObject *currentGraphicObject;
@property (nonatomic) LODManagerType type;

- (id)initWithGraphicObject:(GraphicObject *)graphicObject;
- (void)generateProgressiveMeshWithPercentage:(int)percentage;

@end
