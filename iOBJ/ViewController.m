//
//  ViewController.m
//  iOBJ
//
//  Created by felipowsky on 02/01/12.
//
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GraphicObject *graphicObject;
@property (nonatomic, strong) Camera *camera;
@property (nonatomic) GLfloat previousPinchScale;
@property (nonatomic) GLfloat previousOneFingerPanX;
@property (nonatomic) GLfloat previousOneFingerPanY;
@property (nonatomic) GLfloat previousTwoFingersPanX;
@property (nonatomic) GLfloat previousTwoFingersPanY;
@property (nonatomic) GLfloat previousRotation;
@property (nonatomic, strong) NSString *loadedFile;
@property (nonatomic, strong) NSString *fileToLoad;

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.graphicObject = nil;
        self.loadedFile = @"";
        self.fileToLoad = @"";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.graphicObject) {
        [self hideNavigatorBar];
    
    } else {
        [self showNavigatorBar];
        
    }
    
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
    
    self.preferredFramesPerSecond = 30;
    
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
    doubleTapRecognizer.numberOfTapsRequired = 2;
    
    [view addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
    [view addGestureRecognizer:tapRecognizer];    
    
    UIPanGestureRecognizer *panOneFingerRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOneFingerPan:)];
    panOneFingerRecognizer.minimumNumberOfTouches = 1;
    panOneFingerRecognizer.maximumNumberOfTouches = 1;
    
    [view addGestureRecognizer:panOneFingerRecognizer];
    
    UIPanGestureRecognizer *panTwoFingersRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingersPan:)];
    panTwoFingersRecognizer.minimumNumberOfTouches = 2;
    
    [view addGestureRecognizer:panTwoFingersRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    
    [view addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    
    [view addGestureRecognizer:rotationRecognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    self.graphicObject = nil;
	self.context = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL shouldRotate = NO;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        shouldRotate = (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        shouldRotate = YES;
    }
    
    if (shouldRotate) {
        self.camera.aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    }
    
    return shouldRotate;
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
    if (self.graphicObject) {
        [self.graphicObject update:self.timeSinceLastUpdate camera:self.camera];
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glClear(GL_DEPTH_BUFFER_BIT);
    glClear(GL_STENCIL_BUFFER_BIT);
    
    if (self.graphicObject) {
        [self.graphicObject draw];
    }
}

- (void)hideNavigatorBar
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.navigatorBar.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.navigatorBar.hidden = YES;
                     }];
}

- (void)showNavigatorBar
{
    self.navigatorBar.hidden = NO;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.navigatorBar.alpha = 1.0f;
                     }];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{    
    if (self.navigatorBar.hidden) {
        [self showNavigatorBar];
        
    } else {
        [self hideNavigatorBar];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
}

- (void)handleOneFingerPan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousOneFingerPanX = 0.0f;
        self.previousOneFingerPanY = 0.0f;
    }
    
    CGPoint translation = [recognizer translationInView:self.gestureView];
    
    GLfloat pan = 2.0f;
    
    GLfloat panX = (translation.x - self.previousOneFingerPanX) * pan;
    GLfloat panY = (translation.y - self.previousOneFingerPanY) * pan;
    
    if (self.graphicObject) {
        [self.graphicObject.transform rotateWithDegrees:panY axis:GLKVector3Make(1.0f, 0.0f, 0.0f)];
        [self.graphicObject.transform rotateWithDegrees:panX axis:GLKVector3Make(0.0f, 1.0f, 0.0f)];
    }
    
    self.previousOneFingerPanX = translation.x;
    self.previousOneFingerPanY = translation.y;
}

- (void)handleTwoFingersPan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousTwoFingersPanX = 0.0f;
        self.previousTwoFingersPanY = 0.0f;
    }
    
    CGPoint translation = [recognizer translationInView:self.gestureView];
    
    GLfloat pan = 0.01f;
    
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
    
    self.previousTwoFingersPanX = translation.x;
    self.previousTwoFingersPanY = translation.y;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousPinchScale = 0.0f;
    }
    
    if (recognizer.state != UIGestureRecognizerStateEnded) {
        GLfloat pinch = 1.0f;
        
        if ((recognizer.scale - self.previousPinchScale) > 0.0f) {
            pinch = -pinch;
        }
        
        GLfloat result = self.camera.eyeZ + pinch;
        
        if (result > 0) {
            self.camera.eyeZ = result;
        }
        
        self.previousPinchScale = recognizer.scale;
    }
}

- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousRotation = 0.0f;
    }
    
    GLfloat rotate = (self.previousRotation - recognizer.rotation) * 45.0f;
    
    if (self.graphicObject) {
        [self.graphicObject.transform rotateWithDegrees:rotate axis:GLKVector3Make(0.0f, 0.0f, 1.0f)];
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
        
        self.graphicObject = newGraphicObject;
        
        self.loadedFile = self.fileToLoad;
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

@end
