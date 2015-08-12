//
//  CTHPopAnimation.m
//

#import "CTHPopAnimation.h"

#import "UIDevice+CTH.h"

@interface CTHPopAnimation ()

@property (nonatomic) CTHAnimation animation;
@property (nonatomic, copy) void (^completion)(void);

@end

@implementation CTHPopAnimation

- (id)init
{
    self = [super init];
    
    if (self) {
        self.animation = CTHAnimationNone;
        self.completion = nil;
    }
    
    return self;
}

- (id)initWithAnimation:(CTHAnimation)animation completion:(void (^)(void))completion
{
    self = [super init];
    
    if (self) {
        self.animation = animation;
        self.completion = completion;
    }
    
    return self;
}

#pragma mark UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = 0.0;
    
    switch (self.animation) {
        case CTHAnimationNone: {
            duration = 0.0;
        }
            break;
            
        default: {
            duration = 0.25;
        }
            break;
    }
    
    return duration;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [toViewController.view layoutIfNeeded];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *containerView = [transitionContext containerView];
    
    CGRect initialFrame = fromViewController.view.frame;
    CGRect finalFrame = fromViewController.view.frame;
    
    switch (self.animation) {
        case CTHAnimationNone: {
        }
            break;
        case CTHAnimationBottom: {
            finalFrame.origin.y = initialFrame.size.height;
        }
            break;
        case CTHAnimationTop: {
            finalFrame.origin.y = -initialFrame.size.height;
        }
            break;
        case CTHAnimationLeft: {
            finalFrame.origin.x = -initialFrame.size.width;
        }
            break;
        case CTHAnimationRight: {
            finalFrame.origin.x = initialFrame.size.width;
        }
            break;
        case CTHAnimationFadeIn: {
        }
            break;
        case CTHAnimationFadeOut: {
        }
            break;
    }
    
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    [UIView animateWithDuration:duration animations:^{
        
        switch (self.animation) {
            case CTHAnimationNone: {
            }
                break;
            case CTHAnimationBottom: {
            }
                break;
            case CTHAnimationTop: {
            }
                break;
            case CTHAnimationLeft: {
            }
                break;
            case CTHAnimationRight: {
            }
                break;
            case CTHAnimationFadeIn: {
                fromViewController.view.alpha = 1.0f;
            }
                break;
            case CTHAnimationFadeOut: {
                fromViewController.view.alpha = 0.0f;
            }
                break;
        }
        
        fromViewController.view.frame = finalFrame;
        
    } completion:^(BOOL finished) {
        [fromViewController.view removeFromSuperview];
        [transitionContext completeTransition:YES];
        
        UIApplication *application = [UIApplication sharedApplication];
        id<UIApplicationDelegate> applicationDelegate = application.delegate;
        
        if (applicationDelegate && [applicationDelegate respondsToSelector:@selector(application:supportedInterfaceOrientationsForWindow:)]) {
            NSUInteger supportedOrientations = [applicationDelegate application:application supportedInterfaceOrientationsForWindow:application.keyWindow];
            
            [[UIDevice currentDevice] forceOrientationWithSupportedInterfaceOrientations:supportedOrientations];
        }
        
        if (self.completion) {
            self.completion();
        }
    }];
}

@end
