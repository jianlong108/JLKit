//
//  MTContainerChildViewControllerProtocol.h
//  MiTalk
//
//  Created by wangjianlong on 2018/1/31.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//
#import <UIKit/UIkit.h>

@protocol MTContainerChildViewControllerProtocol <NSObject>

@optional
- (BOOL)panViewShouldBegin:(UIPanGestureRecognizer *)panGesture;

- (UIScrollView *)contentScrollView;

@end
