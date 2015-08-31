//
//  AppDelegate.m
//  iOBJ
//
//  Created by felipowsky on 02/01/12.
//
//

#import "AppDelegate.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[CrashlyticsKit]];
    
    [self configureAppearance];
    [self configureFiles];
    
    return YES;
}

- (void)configureAppearance
{
    UIColor *foregroundColor = [UIColor colorWithHex:0xFFAF0F];
    UIColor *backgroundColor = [UIColor blackColor];
    
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName: foregroundColor,
                                     };
    
    self.window.tintColor = foregroundColor;
    
    [UINavigationBar appearance].barTintColor = backgroundColor;
    [UINavigationBar appearance].tintColor = foregroundColor;
    [UINavigationBar appearance].titleTextAttributes = textAttributes;
    [UINavigationBar appearance].translucent = NO;
    
    [UIToolbar appearance].barTintColor = backgroundColor;
    [UIToolbar appearance].tintColor = foregroundColor;
    [UIToolbar appearance].translucent = NO;
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [UIBarButtonItem appearance].tintColor = foregroundColor;
}

- (void)configureFiles
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:resourcePath error:&error];
    
    if (!error) {
        NSArray *extensions = [NSArray arrayWithObjects:@"obj", @"mtl", @"tga", nil];
        
        for (NSString *file in contents) {
            NSString *extension = [file pathExtension];
            
            if ([extensions containsObject:[extension lowercaseString]]) {
                NSString *fromFilePath = [resourcePath stringByAppendingPathComponent:file];
                NSString *toFilePath = [documentsPath stringByAppendingPathComponent:file];
                
                if (![fileManager fileExistsAtPath:toFilePath]) {
                    [fileManager copyItemAtPath:fromFilePath toPath:toFilePath error:&error];
#ifdef DEBUG
                    if (error) {
                        NSLog(@"Couldn't copy '%@' to '%@'", fromFilePath, toFilePath);
                    }
#endif
                }
            }
        }
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't load resources from '%@'", resourcePath);
    }
#endif

}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    NSUInteger supportedOrientations = UIInterfaceOrientationMaskAll;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        supportedOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    UIWindow *keyWindow = application.keyWindow;
    
    if (keyWindow != nil && [keyWindow isEqual:self.window]) {
    }
    
    return supportedOrientations;
}

- (UIViewController *)topmostViewController:(UIViewController *)viewController topClasses:(NSArray *)specialCases
{
    if (viewController == nil) {
        return nil;
    }
    
    UIViewController *presentedViewController = viewController.presentedViewController;
    
    if (presentedViewController != nil) {
        return [self topmostViewController:presentedViewController topClasses:specialCases];
        
    } else if (specialCases != nil && [specialCases containsObject:viewController.class]) {
        
        return viewController;
        
    } else if ([viewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navigationController = (UINavigationController *) viewController;
        
        return [self topmostViewController:[navigationController.viewControllers lastObject] topClasses:specialCases];
    }
    
    return viewController;
}

@end
