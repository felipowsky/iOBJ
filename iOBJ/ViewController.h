//
//  ViewController.h
//  iOBJ
//
//  Created by felipowsky on 02/01/12.
//
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "FileListViewController.h"

@interface ViewController : GLKViewController <FileListViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIView *gestureView;
@property (nonatomic, weak) IBOutlet UINavigationBar *navigatorBar;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *textureDisplayButton;
@property (nonatomic, weak) IBOutlet UILabel *framesPerSecondLabel;
@property (nonatomic, weak) IBOutlet UILabel *verticesCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *facesCountLabel;
@property (nonatomic, weak) IBOutlet UIView *statsView;
@property (nonatomic, weak) IBOutlet UIView *progressiveSliderView;
@property (nonatomic, weak) IBOutlet UISlider *progressiveSlider;
@property (nonatomic, weak) IBOutlet UILabel *percentageProgressiveLOD;

- (IBAction)displayModeTouched:(id)sender;
- (IBAction)toggleStats:(id)sender;
- (IBAction)toggleLOD:(id)sender;
- (IBAction)sliderValueChanging:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

@end
