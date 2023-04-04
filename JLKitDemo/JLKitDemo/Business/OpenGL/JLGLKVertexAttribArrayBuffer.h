//
//  JLGLKVertexAttribArrayBuffer.h
//  OpenGL_Route
//
//  Created by JL on 2022/7/24.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

//@class AGLKElementIndexArrayBuffer;

typedef enum {
    AGLKVertexAttribPosition = GLKVertexAttribPosition,
    AGLKVertexAttribNormal = GLKVertexAttribNormal,
    AGLKVertexAttribColor = GLKVertexAttribColor,
    AGLKVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    AGLKVertexAttribTexCoord1 = GLKVertexAttribTexCoord1,
} AGLKVertexAttrib;


@interface JLGLKVertexAttribArrayBuffer : NSObject

@property (nonatomic, readonly) GLuint
   name;
@property (nonatomic, readonly) GLsizeiptr
   bufferSizeBytes;
@property (nonatomic, readonly) GLsizei
   stride;

+ (void)drawPreparedArraysWithMode:(GLenum)mode
   startVertexIndex:(GLint)first
   numberOfVertices:(GLsizei)count;

- (id)initWithAttribStride:(GLsizei)stride
   numberOfVertices:(GLsizei)count
   bytes:(const GLvoid *)dataPtr
   usage:(GLenum)usage;

- (void)prepareToDrawWithAttrib:(GLuint)index
   numberOfCoordinates:(GLint)count
   attribOffset:(GLsizeiptr)offset
   shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode
   startVertexIndex:(GLint)first
   numberOfVertices:(GLsizei)count;
   
- (void)reinitWithAttribStride:(GLsizei)stride
   numberOfVertices:(GLsizei)count
   bytes:(const GLvoid *)dataPtr;

@end

NS_ASSUME_NONNULL_END
