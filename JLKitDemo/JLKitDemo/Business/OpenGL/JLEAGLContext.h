//
//  JLEAGLContext.h
//  OpenGL_Route
//
//  Created by JL on 2022/7/24.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLEAGLContext : EAGLContext

@property (nonatomic, assign) GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;


- (void)enable:(GLenum)capability;
- (void)disable:(GLenum)capability;
- (void)setBlendSourceFunction:(GLenum)sfactor
   destinationFunction:(GLenum)dfactor;

@end

NS_ASSUME_NONNULL_END
