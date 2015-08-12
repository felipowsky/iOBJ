//
//  CTHPresentAnimation.h
//

#import <UIKit/UIKit.h>

#import "UIViewController+CTH.h"

@interface CTHPresentAnimation : NSObject <UIViewControllerAnimatedTransitioning>

- (id)initWithAnimation:(CTHAnimation)animation completion:(void (^)(void))completion;

@end
