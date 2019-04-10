//
//  XMNavigationController+UIViewControllerInXMNavigationController.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "XMNavigationController+UIViewControllerInXMNavigationController.h"

@implementation XMNavigationController (UIViewControllerInXMNavigationController)

#pragma mark - 当navigationController 在另一个navigationController中时

/**
 *  @brief 滑动返回开始、结束、取消 滑动返回代理事件
 *
 *  @param navigationController 当前栈控制器
 *  @param viewController       topViewController
 */
- (void)navigationController:(XMNavigationController *)navigationController panBackBeginInWithController:(UIViewController *)viewController
{
    if ([self.topViewController respondsToSelector:_cmd])
    {
        [(id<UIViewControllerInXMNavigationProtocol>)self.topViewController navigationController:navigationController panBackBeginInWithController:self.topViewController];
    }
}

- (void)navigationController:(XMNavigationController *)navigationController panBackCannelInWithController:(UIViewController *)viewController
{
    if ([self.topViewController respondsToSelector:_cmd])
    {
        [(id<UIViewControllerInXMNavigationProtocol>)self.topViewController navigationController:navigationController panBackCannelInWithController:self.topViewController];
    }
}

- (void)navigationController:(XMNavigationController *)navigationController panBackEndInWithController:(UIViewController *)viewController
{
    if ([self.topViewController respondsToSelector:_cmd])
    {
        [(id<UIViewControllerInXMNavigationProtocol>)self.topViewController navigationController:navigationController panBackEndInWithController:self.topViewController];
    }
}

/**
 *  当滑动手势与其他控件手势冲突时，是否由系统决定执行那个手势;询问当前viewController，是否允许导航控制器同时相应手势.
 *  返回值默认为NO，表示由开发者自己实现 backRecognizerResolvedBySystem 以下的方法；
 *  返回YES，表示由系统决定是否执行滑动返回
 *
 */

- (BOOL)backRecognizerResolvedBySystem
{
    if ([self.topViewController respondsToSelector:_cmd])
    {
        return [(id<UIViewControllerInXMNavigationProtocol>)self.topViewController backRecognizerResolvedBySystem];
    }
    
    return NO;
}

/**
 *  由控制器实现,默认仅支持向右滑动返回
 *
 *  @return 支持滑动返回的方向
 */
- (XMPanMoveDirection)supportNavigationBackDirection
{
    if ([self.topViewController respondsToSelector:_cmd])
    {
        return  [(id<UIViewControllerInXMNavigationProtocol>)self.topViewController supportNavigationBackDirection];
    }
    
    return kXMPanMoveDirectionRight;
}

/**
 *  滑动返回是否可以开始执行
 *
 *  @param panMoveDirection 滑动方向
 *
 *  @return 是否可以开始
 */

- (BOOL)navigationBackCanBeginWithDirection:(XMPanMoveDirection)panMoveDirection gestureRecognizer:(UIGestureRecognizer *)recoginzer
{
    if ([self.topViewController respondsToSelector:_cmd])
    {
        return [(id<UIViewControllerInXMNavigationProtocol>)self.topViewController navigationBackCanBeginWithDirection:panMoveDirection gestureRecognizer:recoginzer];
    }
    else
    {
        return YES;
    }
}


/**
 *  是否接收滑动返回事件
 *  主要解决view的touch move 等点击view支持的事件冲突
 *
 *  @param gestureRecognizer 活动手势
 *  @param touch             touch
 *
 *  @return 是否接受
 */
- (BOOL)navigationGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([self.topViewController respondsToSelector:_cmd])
    {
        return [(id<UIViewControllerInXMNavigationProtocol>)self.topViewController navigationGestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
    else
    {
        return YES;
    }
}

@end
