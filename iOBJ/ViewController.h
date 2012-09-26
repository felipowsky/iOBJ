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

@interface ViewController : GLKViewController

@property (nonatomic, weak) IBOutlet UIView *gestureView;
@property (nonatomic, weak) IBOutlet UINavigationBar *navigatorBar;

@end
