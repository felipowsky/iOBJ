//
//  ViewController.h
//  iOBJ
//
//  Created by felipowsky on 02/01/12.
//
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "GraphicObject.h"
#import "OBJParser.h"
#import "Camera.h"
#import "FileListViewController.h"
#import "NSObject+PerformBlock.h"
#import "UIBarButtonItem+DisplayMode.h"

@interface ViewController : GLKViewController <FileListViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *gestureView;
@property (nonatomic, weak) IBOutlet UINavigationBar *navigatorBar;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *textureDisplayButton;

- (IBAction)displayModeTouched:(id)sender;

@end
