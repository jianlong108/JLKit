//
//  JLGLKViewController.h
//  OpenGL_Route
//
//  Created by JL on 2022/7/24.
//

#import <UIKit/UIKit.h>
#import "JLGLKView.h"

@class CADisplayLink;

NS_ASSUME_NONNULL_BEGIN

@interface JLGLKViewController : UIViewController<JLGLKViewDelegate>

@property (nonatomic, strong) CADisplayLink     *displayLink;
@property (nonatomic, assign) NSInteger         preferredFramesPerSecond;
@property (nonatomic, readonly) NSInteger framesPerSecond;
@property (nonatomic, assign) BOOL pause;

@end

NS_ASSUME_NONNULL_END
