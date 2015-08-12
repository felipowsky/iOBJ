//
//  CTHTextField.m
//

#import "CTHTextField.h"

@implementation CTHTextField

- (void)drawRect:(CGRect)rect
{
    if (self.borderColor != nil) {
        self.layer.borderColor = self.borderColor.CGColor;
    }
    
    if (self.placeholderColor != nil) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: self.placeholderColor}];
    }
    
    self.layer.borderWidth = self.borderWidth;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

@end
