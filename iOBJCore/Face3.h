//
//  Face3.h
//  iOBJ
//
//  Created by felipowsky on 09/08/12.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Vertex, Material;

@interface Face3 : NSObject <NSCopying>

@property (nonatomic, strong) NSMutableArray *vertices;
@property (nonatomic, strong) NSMutableArray *textures;
@property (nonatomic, strong) Material *material;
@property (nonatomic, readonly) GLKVector3 normal;

- (BOOL)hasVertex:(Vertex *)vertex;
- (void)cleanFaceFromVertices;
- (void)replaceVertex:(Vertex *)oldVertex newVertex:(Vertex *)newVertex;

@end
