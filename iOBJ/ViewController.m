//
//  ViewController.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 02/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *_graphicObjects;
    Camera *_camera;
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) NSMutableArray *graphicObjects;
@property (strong, nonatomic) Camera *camera;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation ViewController

@synthesize graphicObjects = _graphicObjects;
@synthesize context = _context;
@synthesize camera = _camera;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    GLKMatrix4 perspectiveMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60), 2.0/3.0, 1, 100);
    GLKMatrix4 lookAtMatrix = GLKMatrix4MakeLookAt(0, 0, 10, 0, 0, 0, 0, 1, 0);
    
    self.camera = [[Camera alloc] initWithPerspective:perspectiveMatrix lookAt:lookAtMatrix];
    
    NSString *cubePathFile = [[NSBundle mainBundle] pathForResource:@"cube" ofType:@"obj"];
    NSError *error = nil;
    NSString *cubeContent = [NSString stringWithContentsOfFile:cubePathFile encoding:NSASCIIStringEncoding error:&error];
    
    OBJParser *parser = [[OBJParser alloc] initWithData:[cubeContent dataUsingEncoding:NSASCIIStringEncoding]];
    Mesh *mesh = [parser parseAsObject]; 
    
    self.graphicObjects = [[NSMutableArray alloc] init];
    [self.graphicObjects addObject:[[GraphicObject alloc] initWithMesh:mesh]];
    
    [self setupGL];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
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

@end
