//
//  NSObject+PerformBlock.h
//  LeagueOfLegends
//
//  Created by felipowsky on 01/11/12.
//  Copyright (c) 2012 felipowsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlock)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
