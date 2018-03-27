//
//  UIViewController+BottomPresent.h
//  JLKitDemo
//
//  Created by wangjianlong on 2018/3/27.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomPresentViewControllerProtocol<NSObject>

- (CGFloat)controllerViewHeight;

@optional


/**
 这个frame 是基于UIScreen 做布局.可以通过frame设置显示的位置.中心,底部...

 @return frame
 */
- (CGRect)contentViewFrame;

@end

@interface UIViewController (BottomPresent)<UIViewControllerTransitioningDelegate>

- (void)customPresentViewController:(UIViewController <BottomPresentViewControllerProtocol>*)viewController animated:(BOOL)flag completion:(void (^)(void))completion;

@end
