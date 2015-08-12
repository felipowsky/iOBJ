//
//  CTHTransition.h
//
//

#import <UIKit/UIKit.h>

@interface CTHTransition : NSObject <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

+ (instancetype)shared;

@end
