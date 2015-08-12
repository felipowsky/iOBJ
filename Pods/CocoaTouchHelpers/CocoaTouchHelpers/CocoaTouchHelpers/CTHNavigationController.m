//
//  CTHNavigationController.m
//

#import "CTHNavigationController.h"

#import "UIViewController+CTH.h"

@implementation CTHNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    BOOL shouldPop = YES;
    
    if (self.viewControllers.count > 0) {
        id viewController = [self.viewControllers lastObject];
        
        if ([viewController respondsToSelector:@selector(shouldPopViewController)]) {
            shouldPop = [viewController shouldPopViewController];
        }
    }
    
    return shouldPop ? [super popViewControllerAnimated:animated] : nil;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL shouldPop = YES;
    
    if (self.viewControllers.count > 0) {
        id viewController = [self.viewControllers lastObject];
        
        if ([viewController respondsToSelector:@selector(shouldPopViewController)]) {
            shouldPop = [viewController shouldPopViewController];
        }
    }
    
    return shouldPop ? [super popToViewController:viewController animated:animated] : nil;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    BOOL shouldPop = YES;
    
    if (self.viewControllers.count > 0) {
        id viewController = [self.viewControllers lastObject];
        
        if ([viewController respondsToSelector:@selector(shouldPopViewController)]) {
            shouldPop = [viewController shouldPopViewController];
        }
    }
    
    return shouldPop ? [super popToRootViewControllerAnimated:animated] : nil;
}

#pragma mark UINavigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    if (item == [[self.viewControllers lastObject] navigationItem]) {
        [self popViewControllerAnimated:YES];
        
        return NO;
    }
    
    return YES;
}

@end
