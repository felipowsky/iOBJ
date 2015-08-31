//
//  UIImageView+CTH.m
//

#import "UIImageView+CTH.h"

@implementation UIImageView (CTHImageView)

- (void)tintImage
{
    self.image = [self imageTinted];
}

- (void)tintImageWithTintColor:(UIColor *)tintColor
{
    self.tintColor = tintColor;
    
    [self tintImage];
}

- (UIImage *)imageTinted
{
    return [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
