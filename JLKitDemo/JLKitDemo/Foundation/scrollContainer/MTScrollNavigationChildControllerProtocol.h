//
//  MTScrollContainerChildControllerProtocol.h
//  MiTalk
//
//  Created by wangjianlong on 2018/3/22.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//
#import <UIKit/UIKit.h>

@class MTScrollNavigationController;

@protocol MTScrollNavigationChildControllerProtocol <NSObject>

- (UIScrollView *)contentScrollView;

@optional

- (void)setScrollViewContentInset:(UIEdgeInsets)inset;

/*!
 @method
 @abstract   子视图控制器即将显示
 @discussion 子视图控制器即将显示
 */
- (void)childViewWillAppearInScrollNavigtionViewController:(MTScrollNavigationController *)scrollNavigationViewController;

/*!
 @method
 @abstract   子视图控制器即将消失
 @discussion 子视图控制器即将消失
 */
- (void)childViewWillDisAppearInScrollNavigtionViewController:(MTScrollNavigationController *)scrollNavigationViewController;

@end
