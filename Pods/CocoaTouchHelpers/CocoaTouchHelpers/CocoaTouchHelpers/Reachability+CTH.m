//
//  Reachability+CTH.m
//

#import "Reachability+CTH.h"

#import <objc/runtime.h>

@interface Reachability ()

@property (nonatomic) BOOL connected;

@end

@implementation Reachability (CTHReachability)

static Reachability *simpleInstance = nil;

+ (void)startSimpleNotifier
{
    @synchronized(self) {
        if (simpleInstance == nil) {
            simpleInstance = [Reachability reachabilityWithHostname:@"www.google.com"];
            
            simpleInstance.reachableBlock = ^(Reachability *reach) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    simpleInstance.connected = YES;
                });
            };
            
            simpleInstance.unreachableBlock = ^(Reachability *reach) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    simpleInstance.connected = NO;
                });
            };
        }
        
        [simpleInstance startNotifier];
    }
}

+ (void)stopSimpleNotifier
{
    @synchronized(self) {
        if (simpleInstance != nil) {
            [simpleInstance stopNotifier];
        }
    }
}

+ (BOOL)isConnected
{
    @synchronized(self) {
        BOOL connected = NO;
        
        if (simpleInstance != nil) {
            connected = simpleInstance.connected;
        }
        
        return connected;
    }
}

#pragma mark Getters and Setters

- (BOOL)connected
{
    return [objc_getAssociatedObject(self, @selector(connected)) boolValue];
}

- (void)setConnected:(BOOL)connected
{
    objc_setAssociatedObject(self, @selector(connected), [NSNumber numberWithBool:connected], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
