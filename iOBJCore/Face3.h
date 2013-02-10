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

@property (nonatomic, strong, readonly) NSMutableArray *vertices;
@property (nonatomic, strong) Material *material;

- (void)setVertex:(Vertex *)vertex atIndex:(NSUInteger)index;

@end
