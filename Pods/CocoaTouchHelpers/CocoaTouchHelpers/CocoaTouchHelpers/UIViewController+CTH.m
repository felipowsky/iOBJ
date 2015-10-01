//
//  UIViewController+CTH.m
//

#import "UIViewController+CTH.h"

#import <objc/runtime.h>

#import "CTHTransition.h"

@implementation UIViewController (CTHViewController)

+ (id)viewControllerInitialStoryboard:(NSString *)name bundle:(NSBundle *)storyboardBundleOrNil
{
    return [[UIStoryboard storyboardWithName:name bundle:storyboardBundleOrNil] instantiateInitialViewController];
}

+ (id)viewControllerWithIdentifier:(NSString *)identifier storyboard:(NSString *)name bundle:(NSBundle *)storyboardBundleOrNil
{
    return [[UIStoryboard storyboardWithName:name bundle:storyboardBundleOrNil] instantiateViewControllerWithIdentifier:identifier];
}

- (void)openViewController:(UIViewController *)viewControllerToOpen animation:(CTHAnimation)animation modal:(BOOL)modal completion:(void (^)(void))completion
{
    BOOL present = modal || self.navigationController == nil;
    
    viewControllerToOpen.openAnimation = animation;
    viewControllerToOpen.openCompletion = completion;
    
    if (viewControllerToOpen.closeAnimation == CTHAnimationNone) {
        switch (animation) {
            case CTHAnimationNone: {
                viewControllerToOpen.closeAnimation = CTHAnimationNone;
            }
                break;
            case CTHAnimationBottom: {
                viewControllerToOpen.closeAnimation = CTHAnimationTop;
            }
                break;
            case CTHAnimationTop: {
                viewControllerToOpen.closeAnimation = CTHAnimationBottom;
            }
                break;
            case CTHAnimationLeft: {
                viewControllerToOpen.closeAnimation = CTHAnimationRight;
            }
                break;
            case CTHAnimationRight: {
                viewControllerToOpen.closeAnimation = CTHAnimationLeft;
            }
                break;
            case CTHAnimationFadeIn: {
                viewControllerToOpen.closeAnimation = CTHAnimationFadeOut;
            }
                break;
            case CTHAnimationFadeOut: {
                viewControllerToOpen.closeAnimation = CTHAnimationFadeIn;
            }
                break;
        }
    }
    
    viewControllerToOpen.transitioningDelegate = [CTHTransition shared];
    
    if (present) {
        viewControllerToOpen.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:viewControllerToOpen animated:YES completion:nil];
    
    } else {
        self.navigationController.delegate = [CTHTransition shared];
        [self.navigationController pushViewController:viewControllerToOpen animated:YES];
    }
}

- (void)closeViewController
{
    [self closeViewControllerAnimation:self.closeAnimation completion:self.closeCompletion];
}

- (void)closeViewControllerAnimation:(CTHAnimation)animation
{
    [self closeViewControllerAnimation:animation completion:self.closeCompletion];
}

- (void)closeViewControllerAnimation:(CTHAnimation)animation completion:(void (^)(void))completion
{
    self.closeAnimation = animation;
    self.closeCompletion = completion;
    
    BOOL pop = self.navigationController != nil && self.navigationController.viewControllers.count > 1;
    
    if (pop) {
        [self.navigationController popViewControllerAnimated:YES];
    
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)setBackBarButtonItemTitle:(NSString *)title style:(UIBarButtonItemStyle)style
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:style target:nil action:nil];
}

- (BOOL)shouldPopViewController
{
    return YES;
}

#pragma mark Getters and Setters

- (CTHAnimation)openAnimation
{
    return [objc_getAssociatedObject(self, @selector(openAnimation)) intValue];
}

- (void)setOpenAnimation:(CTHAnimation)openAnimation
{
    objc_setAssociatedObject(self, @selector(openAnimation), [NSNumber numberWithInt:openAnimation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CTHAnimation)closeAnimation
{
    return [objc_getAssociatedObject(self, @selector(closeAnimation)) intValue];
}

- (void)setCloseAnimation:(CTHAnimation)closeAnimation
{
    objc_setAssociatedObject(self, @selector(closeAnimation), [NSNumber numberWithInt:closeAnimation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))openCompletion
{
    return objc_getAssociatedObject(self, @selector(openCompletion));
}

- (void)setOpenCompletion:(void (^)(void))openCompletion
{
    objc_setAssociatedObject(self, @selector(openCompletion), openCompletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))closeCompletion
{
    return objc_getAssociatedObject(self, @selector(closeCompletion));
}

- (void)setCloseCompletion:(void (^)(void))closeCompletion
{
    objc_setAssociatedObject(self, @selector(closeCompletion), closeCompletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
