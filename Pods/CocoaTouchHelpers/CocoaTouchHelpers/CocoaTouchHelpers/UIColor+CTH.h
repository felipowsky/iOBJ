//
//  UIColor+CTH.h
//

#import <UIKit/UIKit.h>

@interface UIColor (CTHColor)

+ (instancetype)colorWithHex:(NSInteger)rgb;
+ (instancetype)colorWithHex:(NSInteger)rgb alpha:(CGFloat)alpha;

@end
