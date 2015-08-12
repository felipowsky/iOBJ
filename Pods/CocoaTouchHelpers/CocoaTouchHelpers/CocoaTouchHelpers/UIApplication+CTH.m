//
//  UIApplication+CTH.m
//

#import "UIApplication+CTH.h"

@implementation UIApplication (CTHApplication)

+ (void)setStatusBarStyle:(UIStatusBarStyle)style animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:style animated:animated];
}

@end
