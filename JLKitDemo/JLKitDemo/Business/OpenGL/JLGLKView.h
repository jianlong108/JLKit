//
//  JLGLKView.h
//  OpenGL_Route
//
//  Created by JL on 2022/7/23.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

NS_ASSUME_NONNULL_BEGIN

@class EAGLContext;
@class JLGLKView;

@protocol JLGLKViewDelegate <NSObject>

@required

- (void)glkView:(JLGLKView *)view drawInRect:(CGRect)rect;

@end

@interface JLGLKView : UIView

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, assign) GLuint defaultFrameBuffer;
@property (nonatomic, assign) GLuint colorRenderBuffer;
@property (nonatomic, assign) GLint drawableWidth;
@property (nonatomic, assign) GLint drawableHeight;

@property (nonatomic, weak) id<JLGLKViewDelegate>delegate;

- (void)display;

@end

NS_ASSUME_NONNULL_END
