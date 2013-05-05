//
//  UIButton+DisplayMode.m
//  iOBJ
//
//  Created by felipowsky on 05/11/12.
//
//

#import "UIButton+DisplayMode.h"

@implementation UIButton (DisplayMode)

@dynamic displayMode;

- (void)setDisplayMode:(GraphicObjectDisplayMode)displayMode
{
	objc_setAssociatedObject(self, @"displayMode", [NSNumber numberWithInt:displayMode], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GraphicObjectDisplayMode)displayMode
{
	NSNumber *value = objc_getAssociatedObject(self, @"displayMode");
    return [value intValue];
}

@end
