//
//  InitialViewController.m
//  iOBJ
//
//  Created by felipowsky on 8/11/15.
//
//

#import "InitialViewController.h"

#import "ViewerViewController.h"
#import "FileListViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *viewController = [UIViewController viewControllerWithIdentifier:@"ViewerNavigation" storyboard:@"Viewer" bundle:nil];
        
        [self openViewController:viewController animation:CTHAnimationFadeIn modal:YES completion:^{
        }];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setBackBarButtonItemTitle:@"" style:UIBarButtonItemStylePlain];
    
    [UIApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

@end
