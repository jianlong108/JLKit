//
//  UIViewController+FullScreenPop.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/17.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "UIViewController+FullScreenPop.h"

@implementation UIViewController (FullScreenPop)

- (BOOL)supportFullScreenPop
{
    return YES;
}


- (BOOL)backRecognizerResolvedBySystem
{
    return NO;
}

- (BOOL)navigationBackCanBeginWithGestureRecognizer:(UIGestureRecognizer *)recoginzer
{
    return YES;
}

- (BOOL)navigationGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

@end
