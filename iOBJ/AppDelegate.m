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
    
    [self initialize];
    
    return YES;
}

- (void)initialize
{
    [self copyOBJFilesFromResourcesToDocuments];
}

- (void)copyOBJFilesFromResourcesToDocuments
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

@end
