//
//  CustomPresentControllerProtocol.h
//  MiTalk
//
//  Created by wangjianlong on 2018/3/28.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//
#import <UIKit/UIKit.h>


@protocol CustomPresentViewControllerProtocol<NSObject>

/**
 被展示view 的最终高度
 宽度默认是主屏幕宽度. 展示位置位于屏幕底部 如需要自定义显示位置, presentedController实现- (CGRect)contentViewFrame即可
 @return 高度
 */
- (CGFloat)contentViewHeight;

@optional

/**
 这个frame 是基于UIScreen 做布局.可以通过frame设置显示的位置.中心,底部...
 
 @return frame
 */
- (CGRect)contentViewFrame;

@end
