//
//  Face3D.h
//  iOBJ
//
//  Created by felipowsky on 09/08/12.
//
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Material.h"
#import "Vertex.h"

@interface Face3D : NSObject

@property (nonatomic) Vertex *vertices;
@property (nonatomic, strong) Material *material;

@end
