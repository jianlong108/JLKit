//
//  JLGLKVertexAttribArrayBuffer.m
//  OpenGL_Route
//
//  Created by JL on 2022/7/24.
//

#import "JLGLKVertexAttribArrayBuffer.h"

@interface JLGLKVertexAttribArrayBuffer ()

@property (nonatomic, readwrite) GLuint name;
@property (nonatomic, readwrite) GLsizeiptr bufferSizeBytes;
@property (nonatomic, readwrite) GLsizei stride;

@end

@implementation JLGLKVertexAttribArrayBuffer

- (id)initWithAttribStride:(GLsizei)aStride
   numberOfVertices:(GLsizei)count
   bytes:(const GLvoid *)dataPtr
   usage:(GLenum)usage;
{
   NSParameterAssert(0 < aStride);
   NSAssert((0 < count && NULL != dataPtr) ||
      (0 == count && NULL == dataPtr),
      @"data must not be NULL or count > 0");
      
   if(nil != (self = [super init]))
   {
      _stride = aStride;
      _bufferSizeBytes = _stride * count;
      
      glGenBuffers(1, &_name); // STEP 1
      glBindBuffer(GL_ARRAY_BUFFER, self.name); // STEP 2
      glBufferData(                  // STEP 3
         GL_ARRAY_BUFFER,  // Initialize buffer contents
         _bufferSizeBytes,  // Number of bytes to copy
         dataPtr,          // Address of bytes to copy
         usage);           // Hint: cache in GPU memory
         
      NSAssert(0 != _name, @"Failed to generate name");
   }
   
   return self;
}

- (void)reinitWithAttribStride:(GLsizei)aStride
   numberOfVertices:(GLsizei)count
   bytes:(const GLvoid *)dataPtr;
{
   NSParameterAssert(0 < aStride);
   NSParameterAssert(0 < count);
   NSParameterAssert(NULL != dataPtr);
   NSAssert(0 != _name, @"Invalid name");

   self.stride = aStride;
   self.bufferSizeBytes = aStride * count;
   
   glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
      self.name);
   glBufferData(                  // STEP 3
      GL_ARRAY_BUFFER,  // Initialize buffer contents
      _bufferSizeBytes,  // Number of bytes to copy
      dataPtr,          // Address of bytes to copy
      GL_DYNAMIC_DRAW);
}

- (void)prepareToDrawWithAttrib:(GLuint)index
   numberOfCoordinates:(GLint)count
   attribOffset:(GLsizeiptr)offset
   shouldEnable:(BOOL)shouldEnable
{
   NSParameterAssert((0 < count) && (count < 4));
   NSParameterAssert(offset < self.stride);
   NSAssert(0 != _name, @"Invalid name");

   glBindBuffer(GL_ARRAY_BUFFER,     // STEP 2
      self.name);

   if(shouldEnable)
   {
      glEnableVertexAttribArray(     // Step 4
         index);
   }

   glVertexAttribPointer(            // Step 5
      index,               // Identifies the attribute to use
      count,               // number of coordinates for attribute
      GL_FLOAT,            // data is floating point
      GL_FALSE,            // no fixed point scaling
      _stride,         // total num bytes stored per vertex
      NULL + offset);      // offset from start of each vertex to
                           // first coord for attribute
#ifdef DEBUG
   {  // Report any errors
      GLenum error = glGetError();
      if(GL_NO_ERROR != error)
      {
         NSLog(@"GL Error: 0x%x", error);
      }
   }
#endif
}

- (void)drawArrayWithMode:(GLenum)mode
   startVertexIndex:(GLint)first
   numberOfVertices:(GLsizei)count
{
   NSAssert(self.bufferSizeBytes >=
      ((first + count) * self.stride),
      @"Attempt to draw more vertex data than available.");
      
   glDrawArrays(mode, first, count); // Step 6
}

+ (void)drawPreparedArraysWithMode:(GLenum)mode
   startVertexIndex:(GLint)first
   numberOfVertices:(GLsizei)count;
{
   glDrawArrays(mode, first, count); // Step 6
}

- (void)dealloc
{
    // Delete buffer from current context
    if (0 != _name)
    {
        glDeleteBuffers (1, &_name); // Step 7
        _name = 0;
    }
}

@end
