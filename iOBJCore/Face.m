//
//  Face.m
//  iOBJ
//
//  Created by felipowsky on 09/08/12.
//
//

#import "Face.h"
#import "Mesh.h"

@implementation Face

- (id)init
{
    self = [super init];
    
    if (self) {
        self.vertices = malloc(sizeof(Vertex) * 3);
        self.material = nil;
    }
    
    return self;
}

@end
