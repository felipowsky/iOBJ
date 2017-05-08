//
//  ViewerViewController.h
//  iOBJ
//
//  Created by felipowsky on 8/30/15.
//
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ViewerViewController : GLKViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIView *gestureView;
//@property (nonatomic, weak) IBOutlet UINavigationBar *navigatorBar;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UIButton *textureDisplayButton;
@property (nonatomic, weak) IBOutlet UILabel *framesPerSecondLabel;
@property (nonatomic, weak) IBOutlet UILabel *verticesCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *facesCountLabel;
@property (nonatomic, weak) IBOutlet UIView *statsView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *progressiveButton;
@property (nonatomic, weak) IBOutlet UIView *progressiveOptionsView;
@property (nonatomic, weak) IBOutlet UISlider *progressiveSlider;
@property (nonatomic, weak) IBOutlet UILabel *percentageProgressiveLabel;
@property (nonatomic, weak) IBOutlet UISwitch *cacheProgressiveSwitch;
@property (nonatomic, weak) IBOutlet UIView *loadingView;
@property (nonatomic, weak) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *displayModeButtons;

- (IBAction)displayModeAction:(id)sender;
- (IBAction)toggleStatsAction:(id)sender;
- (IBAction)toggleLODAction:(id)sender;
- (IBAction)sliderValueChangingAction:(id)sender;
- (IBAction)sliderValueChangedAction:(id)sender;
- (IBAction)progressiveCacheValueChangedAction:(id)sender;
- (IBAction)filestListAction:(id)sender;

@end
