//
//  CTHView.h
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CTHView : UIView

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@end
