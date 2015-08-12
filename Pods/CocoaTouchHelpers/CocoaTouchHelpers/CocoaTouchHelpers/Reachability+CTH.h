//
//  Reachability+CTH.h
//

#import "Reachability.h"

@interface Reachability (CTHReachability)

+ (void)startSimpleNotifier;
+ (void)stopSimpleNotifier;
+ (BOOL)isConnected;

@end
