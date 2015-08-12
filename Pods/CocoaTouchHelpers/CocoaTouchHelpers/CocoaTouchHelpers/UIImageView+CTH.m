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
    UIColor *previousTintColor = self.tintColor;
    
    self.tintColor = tintColor;
    
    [self tintImage];
    
    self.tintColor = previousTintColor;
}

- (UIImage *)imageTinted
{
    return [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    UIColor *previousTintColor = self.tintColor;
    
    self.tintColor = tintColor;
    
    UIImage *image = [self imageTinted];
    
    self.tintColor = previousTintColor;
    
    return image;
}

@end
