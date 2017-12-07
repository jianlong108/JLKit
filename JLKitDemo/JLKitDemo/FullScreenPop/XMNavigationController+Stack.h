//
//  XMNavigationController+Stack.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "XMNavigationController.h"

@interface XMNavigationController (Stack)

/**
 *  @brief 返回栈顶控制器
 *
 *  @return 返回栈顶控制器
 */
- (UIViewController *)topViewController;
/**
 *  @brief 返回当前显示的下一层控制器
 *
 *  @return 返回当前显示的下一层控制器
 */
- (UIViewController *)belowViewController;


/**
 *  @brief 获取指定控制器之上的控制器
 *
 *  @param viewController 指定控制器
 *
 *  @return 获取指定控制器之上的控制器数组
 */
- (NSArray *)viewControllersAfterViewController:(UIViewController *)viewController;


/**
 *  @brief 将控制器添加到viewControllers数组中，并将其设置为子控制器；并不对view操作
 *
 *  @param controller 需要添加的控制器
 */
- (void)addController:(UIViewController *)controller;

/**
 *  @brief 将控制器从viewControllers数组中移除，并从子控制器中移除；并将其view 从父视图中移除
 *
 *  @param controller 需要移除的控制器
 */
- (void)removeController:(UIViewController *)controller;

/**
 *  @brief 将指定的控制器之上的所有控制器从viewControllers数组中移除，并从子控制器中移除；并将其view 从父视图中移除
 *
 *  @param controller 指定的控制器
 */
- (void)removeToController:(UIViewController *)controller;

@end
