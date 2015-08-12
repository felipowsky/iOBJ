//
//  UIImageView+CTH.h
//

#import <UIKit/UIKit.h>

@interface UIImageView (CTHImageView)

- (void)tintImage;
- (void)tintImageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageTinted;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

@end
