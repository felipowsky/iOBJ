//
//  CTHView.m
//

#import "CTHView.h"

@implementation CTHView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.cornerRadius != 0.0f) {
        self.layer.cornerRadius = self.cornerRadius;
        self.clipsToBounds = YES;
    }
    
    if (self.borderWidth != 0.0f) {
        self.layer.borderWidth = self.borderWidth;
        self.layer.borderColor = self.borderColor.CGColor;
    }
}

@end
