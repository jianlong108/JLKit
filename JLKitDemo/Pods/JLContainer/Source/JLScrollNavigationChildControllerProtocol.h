//
//  JLScrollContainerChildControllerProtocol.h
//  JLContainer
//
//  Created by wangjianlong on 2018/3/22.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//
#import <UIKit/UIKit.h>

@class JLScrollNavigationController;

@protocol JLScrollNavigationChildControllerProtocol <NSObject>

@optional

- (UIScrollView *)contentScrollView;

- (void)setScrollViewContentInset:(UIEdgeInsets)inset;

//右侧的展示视图,被展示在MTScrollNavigationController 上 scrollTitleBar上.
- (UIView *)rightExtensionView;
- (UIView *)leftExtensionView;

- (NSString *)titleForScrollTitleBar;

@end

