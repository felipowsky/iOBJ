//
//  NSObject+PerformBlock.m
//  LeagueOfLegends
//
//  Created by felipowsky on 01/11/12.
//  Copyright (c) 2012 felipowsky. All rights reserved.
//

#import "NSObject+PerformBlock.h"

@implementation NSObject (PerformBlock)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:[block copy] afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block
{
    block();
}

@end
