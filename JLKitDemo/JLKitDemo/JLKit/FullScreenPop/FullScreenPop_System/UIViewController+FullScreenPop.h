//
//  UIViewController+FullScreenPop.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/17.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FullScreenPop)

/**
 是否支持全屏返回

 @return 默认YES 支持
 */
- (BOOL)supportFullScreenPop;

/**
 *  当滑动手势与其他控件手势冲突时，是否由系统决定执行那个手势;询问当前viewController，是否允许导航控制器同时响应手势.
 *  返回值默认为NO，表示由开发者自己实现 backRecognizerResolvedBySystem 以下的方法；
 *  返回YES，表示由系统决定是否执行滑动返回
 *
 */

- (BOOL)backRecognizerResolvedBySystem;


- (BOOL)navigationBackCanBeginWithGestureRecognizer:(UIGestureRecognizer *)recoginzer;


/**
 解决互斥手势之间 谁来响应的问题

 @param gestureRecognizer 滑动返回手势
 @param otherGestureRecognizer 其余业务相关手势
 @return 默认NO。。如果返回YES，代表滑动返回手势与其他手势冲突时，全部让其他手势响应事件
 */
- (BOOL)navigationGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end
