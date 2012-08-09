//
//  Face3D.m
//  iOBJ
//
//  Created by felipowsky on 09/08/12.
//
//

#import "Face3D.h"
#import "Mesh.h"

@implementation Face3D

- (id)init
{
    self = [super init];
    
    if (self) {
        self.vertices = malloc(sizeof(Vertex) * 3);
        self.material = nil;
    }
    
    return self;
}

- (void)dealloc
{
    free(self.vertices);
}

@end
