//
//  CTHTransition.m
//

#import "CTHTransition.h"

#import "CTHPresentAnimation.h"
#import "CTHDismissAnimation.h"
#import "CTHPushAnimation.h"
#import "CTHPopAnimation.h"

#import "UIViewController+CTH.h"

@implementation CTHTransition

static CTHTransition *instance = nil;

+ (instancetype)shared
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[CTHTransition alloc] init];
        }
        
        return instance;
    }
}

#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[CTHPresentAnimation alloc] initWithAnimation:presented.openAnimation completion:presented.openCompletion];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[CTHDismissAnimation alloc] initWithAnimation:dismissed.closeAnimation completion:dismissed.closeCompletion];
}

#pragma mark UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    id<UIViewControllerAnimatedTransitioning> animation = nil;
    
    if (operation == UINavigationControllerOperationPush) {
        animation = [[CTHPushAnimation alloc] initWithAnimation:toVC.openAnimation completion:toVC.openCompletion];
        
    } else if (operation == UINavigationControllerOperationPop) {
        animation = [[CTHPopAnimation alloc] initWithAnimation:fromVC.closeAnimation completion:fromVC.closeCompletion];
    }
    
    return animation;
}

@end
