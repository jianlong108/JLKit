//
//  JLEAGLContext.m
//  OpenGL_Route
//
//  Created by JL on 2022/7/24.
//

#import "JLEAGLContext.h"

@implementation JLEAGLContext

- (void)setClearColor:(GLKVector4)clearColorRGBA
{
   _clearColor = clearColorRGBA;
   
   NSAssert(self == [[self class] currentContext],
      @"Receiving context required to be current context");
      
   glClearColor(
      clearColorRGBA.r,
      clearColorRGBA.g,
      clearColorRGBA.b,
      clearColorRGBA.a);
}

- (void)clear:(GLbitfield)mask
{
   NSAssert(self == [[self class] currentContext],
      @"Receiving context required to be current context");
      
   glClear(mask);
}

- (void)enable:(GLenum)capability;
{
   NSAssert(self == [[self class] currentContext],
      @"Receiving context required to be current context");
   
   glEnable(capability);
}


- (void)disable:(GLenum)capability;
{
   NSAssert(self == [[self class] currentContext],
      @"Receiving context required to be current context");
      
   glDisable(capability);
}

- (void)setBlendSourceFunction:(GLenum)sfactor
   destinationFunction:(GLenum)dfactor;
{
   glBlendFunc(sfactor, dfactor);
}

@end
