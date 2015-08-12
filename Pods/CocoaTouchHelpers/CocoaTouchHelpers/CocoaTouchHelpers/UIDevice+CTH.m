//
//  UIDevice+CTH.m
//

#import "UIDevice+CTH.h"

@implementation UIDevice (CTHDevice)

- (void)forceOrientationWithSupportedInterfaceOrientations:(NSUInteger)supportedInterfaceOrientations
{
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    NSNumber *orientation = nil;
    
    // portrait
    if (supportedInterfaceOrientations & UIInterfaceOrientationMaskPortrait) {
        if (currentOrientation != UIInterfaceOrientationPortrait) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        }
        
    // upside down
    } else if (supportedInterfaceOrientations & UIInterfaceOrientationMaskPortraitUpsideDown) {
        if (currentOrientation != UIInterfaceOrientationPortraitUpsideDown) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown];
        }
        
    // landscape left
    } else if (supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeLeft) {
        if (currentOrientation != UIInterfaceOrientationLandscapeLeft) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        }
        
    // landscape right
    } else if (supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeRight) {
        if (currentOrientation != UIInterfaceOrientationLandscapeRight) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        }
        
    // portrait and landscape left
    } else if (supportedInterfaceOrientations & (UIInterfaceOrientationMaskPortrait |
                                                 UIInterfaceOrientationMaskLandscapeLeft)) {
        if (currentOrientation != UIInterfaceOrientationPortrait &&
            currentOrientation != UIInterfaceOrientationLandscapeLeft) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        }
        
    // portrait and landscape right
    } else if (supportedInterfaceOrientations & (UIInterfaceOrientationMaskPortrait |
                                                 UIInterfaceOrientationMaskLandscapeRight)) {
        if (currentOrientation != UIInterfaceOrientationPortrait &&
            currentOrientation != UIInterfaceOrientationLandscapeRight) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        }
        
    // portrait and upside down
    } else if (supportedInterfaceOrientations & (UIInterfaceOrientationMaskPortrait |
                                                 UIInterfaceOrientationMaskPortraitUpsideDown)) {
        if (currentOrientation != UIInterfaceOrientationPortrait &&
            currentOrientation != UIInterfaceOrientationPortraitUpsideDown) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        }
        
    // upside and landscape left
    } else if (supportedInterfaceOrientations & (UIInterfaceOrientationMaskPortraitUpsideDown |
                                                 UIInterfaceOrientationMaskLandscapeLeft)) {
        if (currentOrientation != UIInterfaceOrientationPortraitUpsideDown &&
            currentOrientation != UIInterfaceOrientationLandscapeLeft) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown];
        }
        
    // upside and landscape right
    } else if (supportedInterfaceOrientations & (UIInterfaceOrientationMaskPortraitUpsideDown |
                                                 UIInterfaceOrientationMaskLandscapeRight)) {
        if (currentOrientation != UIInterfaceOrientationPortraitUpsideDown &&
            currentOrientation != UIInterfaceOrientationLandscapeRight) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown];
        }
        
    // landscape left and landscape right
    } else if (supportedInterfaceOrientations & (UIInterfaceOrientationMaskLandscapeLeft |
                                                 UIInterfaceOrientationMaskLandscapeRight)) {
        if (currentOrientation != UIInterfaceOrientationLandscapeLeft &&
            currentOrientation != UIInterfaceOrientationLandscapeRight) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        }
        
    // all but upside down
    } else if (supportedInterfaceOrientations & UIInterfaceOrientationMaskAllButUpsideDown) {
        if (currentOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        }
        
    // all but portrait
    } else if (supportedInterfaceOrientations & (UIInterfaceOrientationMaskLandscape |
                                                 UIInterfaceOrientationMaskPortraitUpsideDown)) {
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown];
        }
        
    // all but landscape right
    } else if (supportedInterfaceOrientations & (UIInterfaceOrientationMaskPortrait |
                                                 UIInterfaceOrientationMaskPortraitUpsideDown |
                                                 UIInterfaceOrientationMaskLandscapeLeft)) {
        if (currentOrientation == UIInterfaceOrientationLandscapeRight) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        }
        
    // all but landscape left
    } else if (supportedInterfaceOrientations & (UIInterfaceOrientationMaskPortrait |
                                                 UIInterfaceOrientationMaskPortraitUpsideDown |
                                                 UIInterfaceOrientationMaskLandscapeRight)) {
        if (currentOrientation == UIInterfaceOrientationLandscapeLeft) {
            orientation = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        }
    }
    
    if (orientation != nil) {
        [[UIDevice currentDevice] setValue:orientation forKey:@"orientation"];
    }
}

@end
