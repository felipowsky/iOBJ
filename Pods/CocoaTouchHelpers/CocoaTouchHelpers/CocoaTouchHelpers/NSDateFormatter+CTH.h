//
//  NSDateFormatter+CTH.h
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (CTHDateFormatter)

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format;

@end
