//
//  Face3.h
//  iOBJ
//
//  Created by felipowsky on 09/08/12.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Material.h"
#import "Vertex.h"

@interface Face3 : NSObject

@property (nonatomic) Vertex *vertices;
@property (nonatomic, strong) Material *material;
@property (nonatomic, readonly) GLKVector3 *textures;

- (void)addTexture:(GLKVector3)texture atIndex:(GLuint)index;

@end
