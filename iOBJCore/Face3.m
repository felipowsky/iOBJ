//
//  Face3.m
//  iOBJ
//
//  Created by felipowsky on 09/08/12.
//
//

#import "Face3.h"

@implementation Face3

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
    if (self.vertices) {
        free(self.vertices);
    }
}

@end
