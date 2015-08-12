//
//  NSDate+CTH.m
//

#import "NSDate+CTH.h"

@implementation NSDate (CTHDate)

+ (instancetype)dateWithObjectTimeIntervalSince1970:(id)object
{
    if (object == nil || object == NULL || [[NSNull null] isEqual:object]) {
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:[object doubleValue]];
}

@end
