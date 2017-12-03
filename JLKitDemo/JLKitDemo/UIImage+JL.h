//
//  UIImage+JL.h
//  JLKitDemo
//
//  Created by Wanjianlong on 2017/3/30.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JL)

- (UIImage*)cropSquareImageBaseOfImageOrientation;
- (UIImage*)cropSquareImageBaseOfDeviceOrientation;
- (UIImage *)fixOrientation;
+ (UIImage *)imageWithUIColor:(UIColor *)color;
@end
