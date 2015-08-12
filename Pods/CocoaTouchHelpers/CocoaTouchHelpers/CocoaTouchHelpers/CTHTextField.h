//
//  CTHTextField.h
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CTHTextField : UITextField

@property (nonatomic) IBInspectable UIEdgeInsets edgeInsets;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

@end
