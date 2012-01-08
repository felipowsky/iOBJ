//
//  ViewController.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 02/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "GraphicObject.h"

@interface ViewController () {
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    NSMutableArray * graphicObjects;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;
@end

@implementation ViewController

@synthesize context = _context;
@synthesize effect = _effect;

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
    
    graphicObjects = [[NSMutableArray alloc] initWithCapacity:10];

    //TODO object for init tests
    GraphicObject * objectTest = [[GraphicObject alloc] init];
    [graphicObjects addObject: objectTest];
    
    [self setupGL];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)setupGL
{
    [EAGLContext setCurrentContext: self.context];
    
    for (GraphicObject *obj in graphicObjects) {
        [[obj shader] useProgram];
    }
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext: self.context];
    
    for (GraphicObject *obj in graphicObjects) {
        [[obj shader] delProgram];
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    
    for (GraphicObject *obj in graphicObjects) {
        [obj update];
    }

    //TODO info for NDC
//    self.view.bounds.size.width / self.view.bounds.size.height
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    for (GraphicObject *obj in graphicObjects) {
        [obj draw];
    }    
}


@end
