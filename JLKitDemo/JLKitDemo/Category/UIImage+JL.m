//
//  UIImage+JL.m
//  JLKitDemo
//
//  Created by Wanjianlong on 2017/3/30.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "UIImage+JL.h"

@implementation UIImage (JL)

+ (UIImage *)imageWithUIColor:(UIColor *)color;
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*)cropSquareImageBaseOfImageOrientation{
    UIImage* squareImage;
    CGFloat inputImageWidth;
    CGFloat inputImageHeight;
    UIImageOrientation inputImageOrientation = self.imageOrientation;
    if (inputImageOrientation == UIImageOrientationLeft || inputImageOrientation == UIImageOrientationRight) {
        inputImageWidth = self.size.height;
        inputImageHeight = self.size.width;
    }else
    {
        inputImageHeight = self.size.height;
        inputImageWidth = self.size.width;
    }
    CGRect cropRect;
    CGRect intCropRect;
    //crop image within center
    if (inputImageHeight >= inputImageWidth) {
        cropRect = CGRectMake(0,(inputImageHeight - inputImageWidth)/2, inputImageWidth, inputImageWidth);
    }else{
        cropRect = CGRectMake((inputImageWidth - inputImageHeight)/2, 0, inputImageHeight, inputImageHeight);
    }
    intCropRect = CGRectIntegral(cropRect);
    
    CGImageRef cropImageRef = CGImageCreateWithImageInRect([self CGImage], intCropRect);
    
    if (inputImageOrientation == UIImageOrientationLeft) {
        squareImage = [[UIImage alloc] initWithCGImage:cropImageRef scale:self.scale orientation:UIImageOrientationLeft];
    }else if (inputImageOrientation == UIImageOrientationRight)
    {
        squareImage = [[UIImage alloc] initWithCGImage:cropImageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationRight];
    }else if (inputImageOrientation==UIImageOrientationDown)
    {
        squareImage= [[UIImage alloc] initWithCGImage:cropImageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown];
    }else{
        squareImage= [[UIImage alloc] initWithCGImage:cropImageRef];
    }
    CFRelease(cropImageRef);
    return squareImage;
}

- (UIImage*)cropSquareImageBaseOfDeviceOrientation
{
    UIImageOrientation inputImageOrientation;
//    if (UIDeviceOrientationPortraitUpsideDown == [UIDevice currentDevice].orientation){
//        inputImageOrientation = UIImageOrientationDown;
//    }else if (UIDeviceOrientationLandscapeLeft == [UIDevice currentDevice].orientation){
//        inputImageOrientation = UIImageOrientationLeft;
//    }else if (UIDeviceOrientationLandscapeRight == [UIDevice currentDevice].orientation){
//        inputImageOrientation = UIImageOrientationRight;
//    }else{
//        inputImageOrientation = UIImageOrientationUp;
//    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationLandscapeRight:
        {
            inputImageOrientation = UIImageOrientationLeft;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            inputImageOrientation = UIImageOrientationRight;
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            inputImageOrientation = UIImageOrientationDown;
        }
            break;
        case UIInterfaceOrientationPortrait:
        {
            inputImageOrientation = UIImageOrientationUp;
        }
            break;
        case UIInterfaceOrientationUnknown:
        {
            inputImageOrientation = UIImageOrientationUp;
        }
            break;
            
        default:
            break;
    }
    
    UIImage* squareImage;
    CGFloat inputImageWidth;
    CGFloat inputImageHeight;
    
//    if (inputImageOrientation == UIImageOrientationLeft || inputImageOrientation == UIImageOrientationRight) {
//        inputImageWidth = self.size.height;
//        inputImageHeight = self.size.width;
//    }else{
        inputImageHeight = self.size.height;
        inputImageWidth = self.size.width;
//    }
    CGRect cropRect;
    CGRect intCropRect;
    //crop image within center
    if (inputImageHeight >= inputImageWidth) {
        cropRect = CGRectMake(0,(inputImageHeight - inputImageWidth)/2, inputImageWidth, inputImageWidth);
    }else{
        cropRect = CGRectMake((inputImageWidth - inputImageHeight)/2, 0, inputImageHeight, inputImageHeight);
    }
    intCropRect = CGRectIntegral(cropRect);
    
    CGImageRef cropImageRef = CGImageCreateWithImageInRect([self CGImage], intCropRect);
    
    if (inputImageOrientation == UIImageOrientationLeft) {
        squareImage = [[UIImage alloc] initWithCGImage:cropImageRef scale:[self scale] orientation:self.imageOrientation];
    }else if (inputImageOrientation == UIImageOrientationRight)
    {
        squareImage = [[UIImage alloc] initWithCGImage:cropImageRef scale:[self scale] orientation:self.imageOrientation];
    }else if (inputImageOrientation==UIImageOrientationDown)
    {
        squareImage= [[UIImage alloc] initWithCGImage:cropImageRef scale:[self scale] orientation:self.imageOrientation];
    }else{
        squareImage= [[UIImage alloc] initWithCGImage:cropImageRef];
    }
//    squareImage = [[UIImage alloc] initWithCGImage:cropImageRef scale:[self scale] orientation:self.imageOrientation];
    CFRelease(cropImageRef);
    return squareImage;
}
- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
