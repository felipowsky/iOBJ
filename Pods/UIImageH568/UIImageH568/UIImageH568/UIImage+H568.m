//
//  UIImage+H568.m
//
//  Created by Angel Garcia on 9/28/12.
//  Copyright (c) 2012 angelolloqui.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation UIImage (H568)


+ (void)load {
    if  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
        ([UIScreen mainScreen].bounds.size.height > 480.0f)) {
        
        //Exchange XIB loading implementation
        Method m1 = class_getInstanceMethod(NSClassFromString(@"UIImageNibPlaceholder"), @selector(initWithCoder:));
    	Method m2 = class_getInstanceMethod(self, @selector(initWithCoderH568:));
		method_exchangeImplementations(m1, m2);
        
        //Exchange imageNamed: implementation
        method_exchangeImplementations(class_getClassMethod(self, @selector(imageNamed:)),
                                       class_getClassMethod(self, @selector(imageNamedH568:)));
    }
}

+ (UIImage *)imageNamedH568:(NSString *)imageName {
    return [UIImage imageNamedH568:[self renameImageNameForH568:imageName]];
}

- (id)initWithCoderH568:(NSCoder *)aDecoder {
	NSString *resourceName = [aDecoder decodeObjectForKey:@"UIResourceName"];
    NSString *resourceH568 = [UIImage renameImageNameForH568:resourceName];
    
    //If no 568h version, load as default
    if ([resourceName isEqualToString:resourceH568]) {
        return [self initWithCoderH568:aDecoder];
    }
    //If 568h exists, load with [UIImage imageNamed:]
    else {
        return [UIImage imageNamedH568:resourceH568];
    }    
}

+ (NSString *)renameImageNameForH568:(NSString *)imageName {
    
    NSMutableString *imageNameMutable = [imageName mutableCopy];
    
    //Delete png extension
    NSRange extension = [imageName rangeOfString:@".png" options:NSBackwardsSearch | NSAnchoredSearch];
    if (extension.location != NSNotFound) {
        [imageNameMutable deleteCharactersInRange:extension];
    }
    
    //Look for @2x to introduce -568h string
    NSRange retinaAtSymbol = [imageName rangeOfString:@"@2x"];
    if (retinaAtSymbol.location != NSNotFound) {
        [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
    } else {
        [imageNameMutable appendString:@"-568h@2x"];
    }
    
    //Check if the image exists and load the new 568 if so or the original name if not
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@"png"];
    if (imagePath) {
        //Remove the @2x to load with the correct scale 2.0
        [imageNameMutable replaceOccurrencesOfString:@"@2x" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [imageNameMutable length])];
        return imageNameMutable;
    } else {
        return imageName;
    }
}

@end