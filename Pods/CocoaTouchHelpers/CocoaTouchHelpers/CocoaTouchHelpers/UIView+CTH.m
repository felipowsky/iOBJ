//
//  UIView+CTH.m
//

#import "UIView+CTH.h"

@implementation UIView (CTHView)

- (id)firstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subview in self.subviews) {
        id responder = [subview firstResponder];
        
        if (responder != nil) {
            return responder;
        }
    }
    
    return nil;
}

@end
