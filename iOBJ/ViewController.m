//
//  ViewController.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 02/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) NSMutableArray *graphicObjects;
@property (strong, nonatomic) Camera *camera;
@property (nonatomic) float previousPinchScale;
@property (nonatomic) float previousPanX;
@property (nonatomic) float previousPanY;

@end

@implementation ViewController

@synthesize graphicObjects = _graphicObjects, context = _context, camera = _camera, previousPinchScale = _previousPinchScale, previousPanX = _previousPanX, previousPanY = _previousPanY;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.graphicObjects = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    [self registerGestureRecognizersToView:self.view];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    Camera *camera = [[Camera alloc] init];
    camera.aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    camera.fovyDegrees = 60;
    camera.farZ = 100;
    camera.eyeZ = 10;
    
    self.camera = camera;
    
    NSString *cubePathFile = [[NSBundle mainBundle] pathForResource:@"cube" ofType:@"obj"];
    NSError *error = nil;
    NSString *cubeContent = [NSString stringWithContentsOfFile:cubePathFile encoding:NSASCIIStringEncoding error:&error];
    
    OBJParser *parser = [[OBJParser alloc] initWithData:[cubeContent dataUsingEncoding:NSASCIIStringEncoding]];
    Mesh *mesh = [parser parseAsObject]; 
    
    [self.graphicObjects addObject:[[GraphicObject alloc] initWithMesh:mesh]];
    
    [self setupGL];
}

- (void)registerGestureRecognizersToView:(UIView *)view
{
    UIPanGestureRecognizer *panRecognizer = 
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.minimumNumberOfTouches = 2;
    
    [view addGestureRecognizer:panRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    
    [view addGestureRecognizer:pinchRecognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [self.graphicObjects removeAllObjects];
    
    self.graphicObjects = nil;
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
    for (GraphicObject *obj in self.graphicObjects) {
        [obj updateWithCamera:self.camera];
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    for (GraphicObject *obj in self.graphicObjects) {
        [obj draw];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousPanX = 0.0;
        self.previousPanY = 0.0;
    }
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    float pan = 0.05;
    
    float panX = (translation.x - self.previousPanX) * pan;
    float panY = (translation.y - self.previousPanY) * -pan;
    
    if (fabs(panX) > 0.0) {
        self.camera.eyeX += panX;
        self.camera.centerX += panX;
    }
    
    if (fabs(panY) > 0.0) {
        self.camera.eyeY += panY;
        self.camera.centerY += panY;
    }
    
    self.previousPanX = translation.x;
    self.previousPanY = translation.y;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.previousPinchScale = 0.0;
    }
    
    float pinch = 1.0;
    
    if ((recognizer.scale - self.previousPinchScale) > 0.0) {
        pinch = -pinch;
    }
    
    float newFovy = self.camera.fovyDegrees + pinch;
    
    if (newFovy > 0.0) {
        self.camera.fovyDegrees = newFovy;
    }
    self.previousPinchScale = recognizer.scale;
}

@end
