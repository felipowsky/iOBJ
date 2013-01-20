//
//  AppDelegate.m
//  iOBJ
//
//  Created by felipowsky on 02/01/12.
//
//

#import "AppDelegate.h"

@implementation AppDelegate

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
        for (NSString *file in contents) {
            NSString *extension = [file pathExtension];
            
            if ([[extension lowercaseString] isEqualToString:@"obj"]) {
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

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    [self initialize];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initialize];
    
    return YES;
}

@end
