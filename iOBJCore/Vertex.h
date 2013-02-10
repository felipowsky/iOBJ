//
//  Vertex.h
//  iOBJ
//
//  Created by felipowsky on 09/08/12.
//
//

#import <GLKit/GLKit.h>

@interface Vertex : NSObject

@property (nonatomic) GLKVector3 point;
@property (nonatomic) int pointIndex;
@property (nonatomic) GLKVector2 texture;
@property (nonatomic) int textureIndex;
@property (nonatomic) GLKVector3 normal;
@property (nonatomic) int normalIndex;

@end;
