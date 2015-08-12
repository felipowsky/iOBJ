//
//  CTHPopAnimation.h
//

#import <UIKit/UIKit.h>

#import "UIViewController+CTH.h"

@interface CTHPopAnimation : NSObject <UIViewControllerAnimatedTransitioning>

- (id)initWithAnimation:(CTHAnimation)animation completion:(void (^)(void))completion;

@end
