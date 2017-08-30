//
//  UINavigationController+MT.h
//  MiTalk
//
//  Created by wangjianlong on 2017/8/30.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (JL)<UINavigationControllerDelegate,UINavigationBarDelegate>

- (void)setNeedsNavigationBackground:(CGFloat)alpha;



/**
 在代理方法 navgationController:willShowViewController: 中调用,解决滑动返回中途,取消手势造成的导航栏颜色不准确的问题

 @param navigationController 导航控制器实例
 */
- (void)willShowViewControllerOfNavgationController:(UINavigationController *)navigationController;

@end
