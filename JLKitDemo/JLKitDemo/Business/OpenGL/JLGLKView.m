//
//  JLGLKView.m
//  OpenGL_Route
//
//  Created by JL on 2022/7/23.
//

#import "JLGLKView.h"
#import <QuartzCore/QuartzCore.h>

@implementation JLGLKView

+ (Class)layerClass
{
    //CAEAGLLayer 会与一个OpenGLES的帧缓存共享它的像素颜色仓库
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context
{
    if (self = [super initWithFrame:frame]) {
        CAEAGLLayer *eagLayer = (CAEAGLLayer *)self.layer;
        eagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithBool:NO],
                                       kEAGLDrawablePropertyRetainedBacking,//告诉coreanimation在层的任何部分需要在屏幕上显示的时候都要绘制整个层的内容(不要试图保留任何以前绘制的图像留作以后重用)
                                       kEAGLColorFormatRGBA8,
                                       kEAGLDrawablePropertyColorFormat,
                                       nil];
        
        _context = context;
    }
    return self;
}
- (void)setContext:(EAGLContext *)context
{
    if (_context != context) {
        [EAGLContext setCurrentContext:_context];
        if (0 != _defaultFrameBuffer) {
            glDeleteFramebuffers(1, &_defaultFrameBuffer);
            _defaultFrameBuffer = 0;
        }
        if (0 != _colorRenderBuffer) {
            glDeleteRenderbuffers(1, &_colorRenderBuffer);
            _colorRenderBuffer = 0;
        }
        
        _context = context;
        
        if (_context) {
            _context = context;
            [EAGLContext setCurrentContext:_context];
            
            glGenFramebuffers(1, &_defaultFrameBuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, _defaultFrameBuffer);
            
            glGenRenderbuffers(1, &_colorRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
            
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
        }
    }
}

- (void)display
{
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, self.drawableWidth, self.drawableHeight);
    [self drawRect:self.bounds];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawRect:(CGRect)rect
{
    if (self.delegate) {
        [self.delegate glkView:self drawInRect:rect];
    }
}

- (void)layoutSubviews
{
    CAEAGLLayer *eagLayer = (CAEAGLLayer *)self.layer;
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eagLayer];
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"fail to make complete frame buffer object %x",status);
    }
}

- (GLint)drawableWidth{
    GLint backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    return backingWidth;
}

- (GLint)drawableHeight
{
    GLint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    return backingHeight;
}

- (void)dealloc
{
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
    _context = nil;
}

@end
