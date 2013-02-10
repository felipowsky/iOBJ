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
        _vertices = [NSMutableArray arrayWithObjects:[Vertex new], [Vertex new], [Vertex new], nil];
        self.material = nil;
    }
    
    return self;
}

- (void)setVertex:(Vertex *)vertex atIndex:(NSUInteger)index
{
    if (index < 3) {
        [self.vertices setObject:vertex atIndexedSubscript:index];
    }
#ifdef DEBUG
    else {
        NSLog(@"Can't set vertex at index '%d', set a index between 0 and 2", index);
    }
#endif
    
}

@end
