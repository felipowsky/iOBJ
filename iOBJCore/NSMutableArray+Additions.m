//
//  NSMutableArray+Additions.m
//  iOBJ
//
//  Created by felipowsky on 10/02/13.
//
//

#import "NSMutableArray+Additions.h"

@implementation NSMutableArray (Additions)

- (void)addUniqueObject:(id)anObject
{
    if (![self containsObject:anObject]) {
        [self addObject:anObject];
    }
}

@end
