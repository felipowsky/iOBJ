//
//  UIViewController+CTH.h
//

#import <UIKit/UIKit.h>

typedef enum {
    CTHAnimationNone,
    CTHAnimationLeft,
    CTHAnimationRight,
    CTHAnimationTop,
    CTHAnimationBottom,
    CTHAnimationFadeIn,
    CTHAnimationFadeOut,
} CTHAnimation;

@interface UIViewController (CTHViewController)

@property (nonatomic) CTHAnimation openAnimation;
@property (nonatomic, copy) void (^openCompletion)(void);
@property (nonatomic) CTHAnimation closeAnimation;
@property (nonatomic, copy) void (^closeCompletion)(void);

+ (id)viewControllerInitialStoryboard:(NSString *)name bundle:(NSBundle *)storyboardBundleOrNil;
+ (id)viewControllerWithIdentifier:(NSString *)identifier storyboard:(NSString *)name bundle:(NSBundle *)storyboardBundleOrNil;

- (void)openViewController:(UIViewController *)viewControllerToOpen animation:(CTHAnimation)animation modal:(BOOL)modal completion:(void (^)(void))completion;
- (void)closeViewController;
- (void)closeViewControllerAnimation:(CTHAnimation)animation;
- (void)closeViewControllerAnimation:(CTHAnimation)animation completion:(void (^)(void))completion;

- (void)setBackBarButtonItemTitle:(NSString *)title style:(UIBarButtonItemStyle)style;

- (BOOL)shouldPopViewController;

@end
