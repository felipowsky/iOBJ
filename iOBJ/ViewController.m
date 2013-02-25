//
//  ViewController.m
//  iOBJ
//
//  Created by felipowsky on 02/01/12.
//
//

#import "ViewController.h"
#import "LODManager.h"
#import "NSObject+PerformBlock.h"
#import "UIBarButtonItem+DisplayMode.h"
#import "UIView+Additions.h"
#import "GraphicObject.h"
#import "OBJParser.h"
#import "Camera.h"

@interface ViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) LODManager *lodManager;
@property (nonatomic, strong) Camera *camera;
@property (nonatomic) GLfloat previousPinchScale;
@property (nonatomic) GLfloat previousOneFingerPanX;
@property (nonatomic) GLfloat previousOneFingerPanY;
@property (nonatomic) GLfloat previousTwoFingersPanX;
@property (nonatomic) GLfloat previousTwoFingersPanY;
@property (nonatomic) GLfloat previousRotation;
@property (nonatomic, strong) NSString *loadedFile;
@property (nonatomic, strong) NSString *fileToLoad;
@property (nonatomic, weak) UIBarButtonItem *currentModeDisplay;
@property (nonatomic) NSTimeInterval lastTimeInterval;
@property (nonatomic) NSUInteger frames;

@end

@implementation ViewController

- (void)initialize
{
    self.lodManager = nil;
    self.loadedFile = @"";
    self.fileToLoad = @"";
    self.currentModeDisplay = nil;
    self.lastTimeInterval = [NSDate timeIntervalSinceReferenceDate];
    self.frames = 0;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.lodManager = [[LODManager alloc] init];
    
    [self performBlock:^(void) {
        [self showControlsAnimated:NO];
        [self showStatsViewAnimated:NO];
        
        [self displayModeTouched:self.textureDisplayButton];
    }
            afterDelay:0.0];
    
    [self performBlock:^(void) {
        [self performSegueWithIdentifier:@"FileList" sender:self];
    }
            afterDelay:1.0];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

#ifdef DEBUG
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
#endif
    
    [self setupGL];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    
    self.preferredFramesPerSecond = 1000;
    
    Camera *camera = [[Camera alloc] init];
    camera.aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    camera.fovyDegrees = 60.0f;
    camera.eyeZ = 100.0f;
    
    self.camera = camera;
    
    [self registerGestureRecognizersToView:self.gestureView];
}

- (void)registerGestureRecognizersToView:(UIView *)view
{
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapRecognizer.numberOfTouchesRequired = 2;
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.delegate = self;
    
    [view addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    tapRecognizer.delegate = self;
    
    [view addGestureRecognizer:tapRecognizer];    
    
    UIPanGestureRecognizer *panOneFingerRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOneFingerPan:)];
    panOneFingerRecognizer.minimumNumberOfTouches = 1;
    panOneFingerRecognizer.maximumNumberOfTouches = 1;
    panOneFingerRecognizer.delegate = self;
    
    [view addGestureRecognizer:panOneFingerRecognizer];
    
    UIPanGestureRecognizer *panTwoFingersRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingersPan:)];
    panTwoFingersRecognizer.minimumNumberOfTouches = 2;
    panTwoFingersRecognizer.delegate = self;
    
    [view addGestureRecognizer:panTwoFingersRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchRecognizer.delegate = self;
    
    [view addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    rotationRecognizer.delegate = self;
    
    [view addGestureRecognizer:rotationRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (BOOL)shouldAutorotate
{
    self.camera.aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    
    return YES;
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glEnable(GL_DEPTH_TEST);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}

- (void)update
{
    GraphicObject *graphicObject = self.lodManager.currentGraphicObject;
    
    if (graphicObject) {
        [graphicObject update];
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    GLuint verticesCount = 0;
    GLuint facesCount = 0;
    
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glClear(GL_DEPTH_BUFFER_BIT);
    glClear(GL_STENCIL_BUFFER_BIT);
    
    GraphicObject *graphicObject = self.lodManager.currentGraphicObject;
    
    if (graphicObject && self.camera) {
        
        GraphicObjectDisplayMode mode = GraphicObjectDisplayModeTexture;
        
        if (self.currentModeDisplay) {
            mode = self.currentModeDisplay.displayMode;
        }
        
        [graphicObject drawWithDisplayMode:mode camera:self.camera];
        
        verticesCount = graphicObject.mesh.points.count;
        facesCount = graphicObject.mesh.faces.count;
    }
    
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval diffTimeInterval = timeInterval - self.lastTimeInterval;
    
    if (diffTimeInterval > 1.0) {
        NSTimeInterval rate = self.frames / diffTimeInterval;
        self.frames = 0;
        self.lastTimeInterval = [NSDate timeIntervalSinceReferenceDate];
        
        self.framesPerSecondLabel.text = [NSString stringWithFormat:@"%.1f", rate];
    }
    
    self.verticesCountLabel.text = [NSString stringWithFormat:@"%d", verticesCount];
    self.facesCountLabel.text = [NSString stringWithFormat:@"%d", facesCount];
    
    self.frames++;
}

- (void)hideNavigatorBar
{
    [self hideNavigatorBarAnimated:YES];
}

- (void)hideNavigatorBarAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.navigatorBar.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             self.navigatorBar.hidden = YES;
                         }];
    } else {
        self.navigatorBar.alpha = 0.0f;
        self.navigatorBar.hidden = YES;
    }
}

- (void)showNavigatorBar
{
    [self showNavigatorBarAnimated:YES];
}

- (void)showNavigatorBarAnimated:(BOOL)animated
{
    self.navigatorBar.hidden = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.navigatorBar.alpha = 1.0f;
                         }];
    } else {
        self.navigatorBar.alpha = 1.0f;
    }
}

- (void)hideToolbar
{
    [self hideToolbarAnimated:YES];
}

- (void)hideToolbarAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.toolBar.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             self.toolBar.hidden = YES;
                         }];
    } else {
        self.toolBar.alpha = 0.0f;
        self.toolBar.hidden = YES;
    }
}

- (void)showToolBar
{
    [self showToolBarAnimated:YES];
}

- (void)showToolBarAnimated:(BOOL)animated
{
    self.toolBar.hidden = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.toolBar.alpha = 1.0f;
                         }];
    } else {
        self.toolBar.alpha = 1.0f;
    }
}

- (void)hideStatsView
{
    [self hideStatsViewAnimated:YES];
}

- (void)hideStatsViewAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.statsView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             self.statsView.hidden = YES;
                         }];
    } else {
        self.statsView.alpha = 0.0f;
        self.statsView.hidden = YES;
    }
}

- (void)showStatsView
{
    [self showStatsViewAnimated:YES];
}

- (void)showStatsViewAnimated:(BOOL)animated
{
    self.statsView.hidden = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.statsView.alpha = 1.0f;
                         }];
    } else {
        self.statsView.alpha = 1.0f;
    }
}

- (void)hideProgressiveSliderView
{
    [self hideProgressiveSliderViewAnimated:YES];
}

- (void)hideProgressiveSliderViewAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.progressiveSliderView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             self.progressiveSliderView.hidden = YES;
                         }];
    } else {
        self.progressiveSliderView.alpha = 0.0f;
        self.progressiveSliderView.hidden = YES;
    }
}

- (void)showProgressiveSliderView
{
    [self showProgressiveSliderViewAnimated:YES];
}

- (void)showProgressiveSliderViewAnimated:(BOOL)animated
{
    self.progressiveSliderView.hidden = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.progressiveSliderView.alpha = 1.0f;
                         }];
    } else {
        self.progressiveSliderView.alpha = 1.0f;
    }
}

- (void)hideControls
{
    [self hideControlsAnimated:YES];
}

- (void)hideControlsAnimated:(BOOL)animated
{
    [self hideNavigatorBarAnimated:animated];
    [self hideToolbarAnimated:animated];
    
    switch (self.lodManager.type) {
        case LODManagerTypeProgressiveMesh: {
            [self hideProgressiveSliderViewAnimated:animated];
        }
            break;
            
        case LODManagerTypeNormal:
            break;
            
        default:
            break;
    }
}

- (void)showControls
{
    [self showControlsAnimated:YES];
}

- (void)showControlsAnimated:(BOOL)animated
{
    [self showNavigatorBarAnimated:animated];
    [self showToolBarAnimated:animated];
    
    switch (self.lodManager.type) {
        case LODManagerTypeProgressiveMesh: {
            [self showProgressiveSliderViewAnimated:animated];
        }
            break;
            
        case LODManagerTypeNormal:
            break;
            
        default:
            break;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{    
    if (self.navigatorBar.hidden) {
        [self showControls];
        
    } else {
        [self hideControls];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    [self adjustCamera:self.camera toFitObject:self.lodManager.currentGraphicObject];
}

- (void)handleOneFingerPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.gestureView];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousOneFingerPanX = 0.0f;
        self.previousOneFingerPanY = 0.0f;
    
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        GLfloat pan = 1.5f;
        
        GLfloat panX = (translation.x - self.previousOneFingerPanX) * pan;
        GLfloat panY = (translation.y - self.previousOneFingerPanY) * pan;
        
        GraphicObject *graphicObject = self.lodManager.currentGraphicObject;
        
        if (graphicObject) {
            [graphicObject.transform rotateWithDegrees:panY axis:GLKVector3Make(1.0f, 0.0f, 0.0f)];
            [graphicObject.transform rotateWithDegrees:panX axis:GLKVector3Make(0.0f, 1.0f, 0.0f)];
        }
    }
    
    self.previousOneFingerPanX = translation.x;
    self.previousOneFingerPanY = translation.y;
}

- (void)handleTwoFingersPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.gestureView];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousTwoFingersPanX = 0.0f;
        self.previousTwoFingersPanY = 0.0f;
    
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        GLfloat pan = 0.5f;
        
        GLfloat panX = (translation.x - self.previousTwoFingersPanX) * pan;
        GLfloat panY = (translation.y - self.previousTwoFingersPanY) * -pan;
        
        if (fabs(panX) > 0.0f) {
            self.camera.eyeX += panX;
            self.camera.centerX += panX;
        }
        
        if (fabs(panY) > 0.0f) {
            self.camera.eyeY += panY;
            self.camera.centerY += panY;
        }
    }
    
    self.previousTwoFingersPanX = translation.x;
    self.previousTwoFingersPanY = translation.y;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousPinchScale = 0.0f;
    
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        GLfloat pinch = 1.0f;
        
        if ((recognizer.scale - self.previousPinchScale) > 0.0f) {
            pinch = -pinch;
        }
        
        GLfloat result = self.camera.eyeZ + pinch;
        
        if (result > 0) {
            self.camera.eyeZ = result;
        }
    }
    
    self.previousPinchScale = recognizer.scale;
}

- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousRotation = 0.0f;
    
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        GLfloat rotate = (self.previousRotation - recognizer.rotation) * 45.0f;
        
        GraphicObject *graphicObject = self.lodManager.currentGraphicObject;
        
        if (graphicObject) {
            [graphicObject.transform rotateWithDegrees:rotate axis:GLKVector3Make(0.0f, 0.0f, 1.0f)];
        }
    }
    
    self.previousRotation = recognizer.rotation;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[FileListViewController class]]) {
        FileListViewController *viewController = (FileListViewController *) segue.destinationViewController;
        
        viewController.selectedFile = self.loadedFile;
        viewController.delegate = self;
    }
}

- (void)fileList:(FileListViewController *)fileList selectedFile:(NSString *)file
{
    self.fileToLoad = file;
}

- (void)fileListWillClose:(FileListViewController *)fileList
{
    if (self.fileToLoad && ![self.fileToLoad isEqualToString:@""] && ![self.fileToLoad isEqualToString:self.loadedFile]) {

        Mesh *mesh = [self loadOBJFileAsMesh:[self.fileToLoad stringByDeletingPathExtension]];
        
        GraphicObject *newGraphicObject = [[GraphicObject alloc] initWithMesh:mesh];
        
        [self centralizeObject:newGraphicObject];
        [self adjustCamera:self.camera toFitObject:newGraphicObject];
        
        LODManagerType currentLODType = self.lodManager.type;
        
        self.lodManager = [[LODManager alloc] initWithGraphicObject:newGraphicObject];
        
        self.loadedFile = self.fileToLoad;
        
        [self activateLODType:currentLODType];
    }
}

- (void)centralizeObject:(GraphicObject *)graphicObject
{
    [graphicObject.transform translateToOrigin];
}

- (void)adjustCamera:(Camera *)camera toFitObject:(GraphicObject *)graphicObject
{
    camera.centerX = 0.0f;
    camera.centerY = 0.0f;
    camera.centerZ = 0.0f;
    
    camera.upX = 0.0f;
    camera.upY = 1.0f;
    camera.upZ = 0.0f;
    
    camera.eyeX = 0.0f;
    camera.eyeY = 0.0f;
    
    GLfloat maxValue = MAX(graphicObject.width, graphicObject.height);
    
    if (maxValue > 0.0f) {
        camera.eyeZ = maxValue * 2;
    }
}

- (Mesh *)loadOBJFileAsMesh:(NSString *)file
{
    OBJParser *parser = [[OBJParser alloc] initWithFilename:file];
    return [parser parseAsObject];
}

- (void)activateLODType:(LODManagerType)lodType
{
    [self hideProgressiveSliderViewAnimated:NO];
    
    switch (lodType) {
        case LODManagerTypeNormal:
            break;
            
        case LODManagerTypeProgressiveMesh: {
            [self.lodManager generateProgressiveMeshWithPercentage:self.progressiveSlider.value];
            
            [self showProgressiveSliderViewAnimated:NO];
        }
            break;
            
        default:
            break;
    }
    
    GraphicObject *priorGraphicObject = self.lodManager.currentGraphicObject;
    
    self.lodManager.type = lodType;
    
    GraphicObject *currentGraphicObject = self.lodManager.currentGraphicObject;
    
    if (priorGraphicObject && priorGraphicObject != currentGraphicObject) {
        currentGraphicObject.transform = priorGraphicObject.transform;
    }
}

- (IBAction)displayModeTouched:(id)sender
{
    if (self.currentModeDisplay) {
        self.currentModeDisplay.style = UIBarButtonItemStyleBordered;
    }
    
    UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
    barButtonItem.style = UIBarButtonItemStyleDone;
    
    self.currentModeDisplay = barButtonItem;
}

- (IBAction)toggleStats:(id)sender
{
    if (self.statsView.hidden) {
        [self showStatsView];
        
    } else {
        [self hideStatsView];
    }
}

- (IBAction)toggleLOD:(id)sender
{
    UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
    barButtonItem.style = UIBarButtonItemStyleBordered;
    
    if (self.lodManager.type != LODManagerTypeProgressiveMesh) {
        [self activateLODType:LODManagerTypeProgressiveMesh];
        barButtonItem.style = UIBarButtonItemStyleDone;
    
    } else {
        [self activateLODType:LODManagerTypeNormal];
    }
}

- (IBAction)sliderValueChanging:(id)sender
{
    UISlider *slider = (UISlider *) sender;
    
    self.percentageProgressiveLOD.text = [NSString stringWithFormat:@"%d%%", (int) slider.value];
}

- (IBAction)sliderValueChanged:(id)sender
{
    UISlider *slider = (UISlider *) sender;
    
    GraphicObject *priorGraphicObject = self.lodManager.currentGraphicObject;
    
    [self.lodManager generateProgressiveMeshWithPercentage:(int) slider.value];
    
    self.lodManager.currentGraphicObject.transform = priorGraphicObject.transform;
}

@end
