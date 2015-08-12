//
//  CTHDismissAnimation.h
//

#import <UIKit/UIKit.h>

#import "UIViewController+CTH.h"

@interface CTHDismissAnimation : NSObject <UIViewControllerAnimatedTransitioning>

- (id)initWithAnimation:(CTHAnimation)animation completion:(void (^)(void))completion;

@end
