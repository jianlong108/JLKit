//
//  JLGLKViewController.m
//  OpenGL_Route
//
//  Created by JL on 2022/7/24.
//

#import "JLGLKViewController.h"
#import <QuartzCore/QuartzCore.h>

static const NSInteger kAGLKDefaultFramesPerSecond = 30;

@interface JLGLKViewController ()

@end

@implementation JLGLKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
   bundle:(NSBundle *)nibBundleOrNil;
{
    if(nil != (self = [super initWithNibName:nibNameOrNil
       bundle:nibBundleOrNil]))
    {
      _displayLink =
         [CADisplayLink displayLinkWithTarget:self
            selector:@selector(drawView:)];

      self.preferredFramesPerSecond =
         kAGLKDefaultFramesPerSecond;

      [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
         forMode:NSDefaultRunLoopMode];
         
      self.paused = NO;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
   if (nil != (self = [super initWithCoder:coder]))
   {
      _displayLink =
         [CADisplayLink displayLinkWithTarget:self
            selector:@selector(drawView:)];

      self.preferredFramesPerSecond =
         kAGLKDefaultFramesPerSecond;

      [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
         forMode:NSDefaultRunLoopMode];
         
      self.paused = NO;
   }
   
   return self;
}

- (void)loadView
{
    JLGLKView *view = [[JLGLKView alloc] init];
    view.delegate = self;
    self.view = view;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   // Verify the type of view created automatically by the
   // Interface Builder storyboard
   JLGLKView *view = (JLGLKView *)self.view;
   NSAssert([view isKindOfClass:[JLGLKView class]],
      @"View controller's view is not a AGLKView");
   
   view.opaque = YES;
   view.delegate = self;
}

   
/////////////////////////////////////////////////////////////////
// This method is called when the receiver's view appears and
// unpauses the receiver.
- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   self.paused = NO;
}


/////////////////////////////////////////////////////////////////
// This method is called when the receiver's view disappears and
// pauses the receiver.
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.paused = YES;
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)drawView:(id)sender
{
   [(JLGLKView *)self.view display];
}


/////////////////////////////////////////////////////////////////
// Returns the receiver's framesPerSecond property value.
- (NSInteger)framesPerSecond
{
   return 60 / _displayLink.preferredFramesPerSecond;
}


/////////////////////////////////////////////////////////////////
// This method sets the desired frames per second rate at for
// redrawing the receiver's view.
- (void)setPreferredFramesPerSecond:(NSInteger)aValue
{
   _preferredFramesPerSecond = aValue;
   
   _displayLink.preferredFramesPerSecond = MAX(1, (60 / aValue));
}


/////////////////////////////////////////////////////////////////
// This method returns YES if the receiver is paused and NO
// otherwise. The receiver does not automatically prompt redraw
// of the receiver's view when paused.
- (BOOL)isPaused
{
   return _displayLink.paused;
}


/////////////////////////////////////////////////////////////////
// This method sets whether the receiver is paused. The receiver
// automatically prompts redraw of the receiver's view
// unless paused.
- (void)setPaused:(BOOL)aValue
{
   _displayLink.paused = aValue;
}


/////////////////////////////////////////////////////////////////
// This required AGLKViewDelegate method does nothing. Subclasses
// of this class may override this method to draw on behalf of
// the receiver's view.
- (void)glkView:(JLGLKView *)view drawInRect:(CGRect)rect;
{
}

@end
