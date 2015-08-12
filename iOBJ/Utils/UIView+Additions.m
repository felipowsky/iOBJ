//
//  UIView+Additions.m
//  iOBJ
//
//  Created by felipowsky on 17/11/12.
//
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

@dynamic cornerRadius;

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

@end
