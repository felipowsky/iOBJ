//
//  ViewController.m
//  iOBJ
//
//  Created by felipowsky on 02/01/12.
//
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GraphicObject *graphicObject;
@property (strong, nonatomic) Camera *camera;
@property (nonatomic) float previousPinchScale;
@property (nonatomic) float previousOneFingerPanX;
@property (nonatomic) float previousOneFingerPanY;
@property (nonatomic) float previousTwoFingersPanX;
@property (nonatomic) float previousTwoFingersPanY;
@property (nonatomic) float previousRotation;

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.graphicObject = nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

#ifdef DEBUG
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
#endif
    
    [self setupGL];
    
    [self registerGestureRecognizersToView:self.view];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    Camera *camera = [[Camera alloc] init];
    camera.aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    camera.fovyDegrees = 60.0f;
    camera.eyeZ = 100.0f;
    
    self.camera = camera;
    
    NSString *cubePathFile = [[NSBundle mainBundle] pathForResource:@"Rollermine" ofType:@"obj"];
    
    NSError *error;
    
    NSString *cubeContent = [NSString stringWithContentsOfFile:cubePathFile encoding:NSASCIIStringEncoding error:&error];
    
    OBJParser *parser = [[OBJParser alloc] initWithData:[cubeContent dataUsingEncoding:NSASCIIStringEncoding]];
    Mesh *mesh = [parser parseAsObject];
    
    self.graphicObject = [[GraphicObject alloc] initWithMesh:mesh];
    [self.graphicObject.transform centralizeInWorld];
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
    [self.graphicObject update:self.timeSinceLastUpdate camera:self.camera];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.graphicObject draw];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    [self.graphicObject.transform centralizeInWorld];
    
    self.camera.centerX = 0.0f;
    self.camera.eyeX = 0.0f;
    self.camera.centerY = 0.0f;
    self.camera.eyeY = 0.0f;
    self.camera.eyeZ = 10.0f;
}

- (void)handleOneFingerPan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousOneFingerPanX = 0.0f;
        self.previousOneFingerPanY = 0.0f;
    }
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    float pan = 2.0f;
    
    float panX = (translation.x - self.previousOneFingerPanX) * pan;
    float panY = (translation.y - self.previousOneFingerPanY) * pan;
    
    [self.graphicObject.transform rotateWithDegrees:panY axis:GLKVector3Make(1.0f, 0.0f, 0.0f)];
    [self.graphicObject.transform rotateWithDegrees:panX axis:GLKVector3Make(0.0f, 1.0f, 0.0f)];
    
    self.previousOneFingerPanX = translation.x;
    self.previousOneFingerPanY = translation.y;
}

- (void)handleTwoFingersPan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousTwoFingersPanX = 0.0f;
        self.previousTwoFingersPanY = 0.0f;
    }
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    float pan = 0.01f;
    
    float panX = (translation.x - self.previousTwoFingersPanX) * pan;
    float panY = (translation.y - self.previousTwoFingersPanY) * -pan;
    
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
    
    float pinch = 5.0f;
    
    if ((recognizer.scale - self.previousPinchScale) > 0.0f) {
        pinch = -pinch;
    }
    
    self.camera.eyeZ += pinch;
    
    self.previousPinchScale = recognizer.scale;
}

- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousRotation = 0.0f;
    }
    
    float rotate = (self.previousRotation - recognizer.rotation) * 45.0f;
    
    [self.graphicObject.transform rotateWithDegrees:rotate axis:GLKVector3Make(0.0f, 0.0f, 1.0f)];
    
    self.previousRotation = recognizer.rotation;
}

@end
