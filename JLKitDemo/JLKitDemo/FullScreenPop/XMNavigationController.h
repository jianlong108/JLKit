//
//  XMNavigationController.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMNavigationGlobalDefines.h"



@class XMNavigationController;


/**
 *  @brief UIViewControllerInAHNavigationProtocol
 *  由XMNavigationController中的ViewController选择性实现
 */

@protocol UIViewControllerInXMNavigationProtocol <NSObject>


@optional

/**
 *  @brief 滑动返回开始、结束、取消 滑动返回代理事件
 *
 *  @param navigationController 当前栈控制器
 *  @param viewController       topViewController
 */
- (void)navigationController:(XMNavigationController *)navigationController panBackBeginInWithController:(UIViewController *)viewController;

- (void)navigationController:(XMNavigationController *)navigationController panBackCannelInWithController:(UIViewController *)viewController;

- (void)navigationController:(XMNavigationController *)navigationController panBackEndInWithController:(UIViewController *)viewController;

/**
 *  当滑动手势与其他控件手势冲突时，是否由系统决定执行哪个手势;询问当前viewController，是否允许导航控制器同时相应手势.
 *  返回值默认为NO，表示由开发者自己实现 backRecognizerResolvedBySystem 以下的方法；
 *  返回YES，表示由系统决定是否执行滑动返回
 *
 */

- (BOOL)backRecognizerResolvedBySystem;

/**
 *  由控制器实现,默认仅支持向右滑动返回
 *
 *  @return 支持滑动返回的方向
 */
- (XMPanMoveDirection)supportNavigationBackDirection;

/**
 *  滑动返回是否可以开始执行
 *
 *  @param panMoveDirection 滑动方向
 *
 *  @return 是否可以开始
 */

- (BOOL)navigationBackCanBeginWithDirection:(XMPanMoveDirection)panMoveDirection gestureRecognizer:(UIGestureRecognizer *)recoginzer;


/**
 *  是否接收滑动返回事件
 *  主要解决view的touch move 等点击view支持的事件冲突
 *
 *  @param gestureRecognizer 活动手势
 *  @param touch             touch
 *
 *  @return 是否接收
 */
- (BOOL)navigationGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

/**
 *  @brief 执行真正push 前 回调给 topViewController事件；注意在此方法中不能再次 做push操作，否则会引发死循环
 *
 *  @param navigationController 当前栈控制器
 *  @param viewController       topViewController
 */
- (void)navigationController:(XMNavigationController *)navigationController willPush:(UIViewController *)viewController;

@end


@protocol UIViewControllerInXMNavigationMonitorEventProtocol <NSObject>
/**
 将要Push新的UIViewController
 
 @param navigationController   当前导航控制器
 @param topViewController      当前最顶端视图控制器
 @param willShowViewController 将要显示的视图控制器
 */
- (void)navigationController:(UINavigationController *)navigationController
           topViewController:(UIViewController *)topViewController
      willShowViewController:(UIViewController *)willShowViewController;

/**
 已经Push新的UIViewController
 
 @param navigationController 当前导航控制器
 @param viewController       已经显示的视图控制器
 */
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController;

@end


@interface XMNavigationController : UINavigationController

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic, readonly, strong) UIPanGestureRecognizer *panGestureRecognizer;//滑动手势，不可修改其代理值

@property (nonatomic, readonly, strong) UIViewController *rootViewController;//根控制器，只能初始化时设置；且不能pop的控制器

@property (nonatomic, strong, readonly) NSMutableArray *willPopControllerIdentifierArray;


/**
 *  @brief 控制 栈控制器 是否支持手势 滑动返回
 */
@property (nonatomic, assign, getter = isPanValid)  BOOL panValid;

@property (nonatomic, assign, getter = isPanning)  BOOL paning;

/**
 *  @brief 值为YES 表示栈控制器在执行动画
 */
@property (nonatomic, assign, readonly,getter = isLayouting) BOOL layouting;

/**
 *  @brief 设置push、pop执行动画的时间
 */
@property (nonatomic,assign) CGFloat animationDuration;

@property (nonatomic,readonly) UIView *maskView;

@property (nonatomic,readonly) UIView *animationView;


@property (nonatomic,weak) UIViewController *animationPanTopViewController;
@property (nonatomic,weak) UIViewController *animationPanBelowViewController;

/**
 *  @brief 初始化 栈控制器
 *
 *  @param rootViewController 根控制器
 *
 *  @return 栈控制器
 */
- (id)initWithRootViewController:(UIViewController *)rootViewController;

#pragma mark- 压栈方法

/**
 *  @brief 压栈控制器
 *
 *  @param viewController 需要压栈的viewController
 *  @param animated       是否使用动画，如果animated为YES 则使用默认动画
 *
 *
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;


/**
 *  @brief 压栈控制器
 *
 *  @param viewController 需要压栈的viewController
 *  @param animated       是否使用动画，如果animated为YES 则使用默认动画
 *  @param completionBlock 动画完成后执行的block
 */
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
       animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock;
/**
 *  @brief 压栈控制器
 *
 *  @param viewController 需要压栈的viewController
 *  @param animationType  动画类型
 */
- (void)pushViewController:(UIViewController *)viewController animatiomType:(XMNavigationViewAnimationType)animationType;

/**
 *  @brief 压栈控制器
 *
 *  @param viewController 需要压栈的viewController
 *  @param animationType  动画类型
 *  @param completionBlock 动画完成后执行的block
 */
- (void)pushViewController:(UIViewController *)viewController
             animatiomType:(XMNavigationViewAnimationType)animationType
       animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock;

#pragma mark- 出栈方法


/**
 *  @brief 出栈最上面的控制器方法
 *
 *  @param animated 是否需要动画，如果animated为YES 则 默认寻找与其push对应的动画类型
 *
 *  @return 返回出栈的控制器
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;

/**
 *  @brief 出栈最上面的控制器方法
 *
 *  @param animated 是否需要动画，如果animated为YES 则 默认寻找与其push对应的动画类型
 *  @param completionBlock 动画完成后执行的block
 *  @return 返回出栈的控制器
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
                            animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock;
/**
 *  @brief 出栈最上面的控制器方法
 *
 *  @param animationType  动画类型
 *  @return 返回出栈的控制器
 */
- (UIViewController *)popViewControllerWithAnimationType:(XMNavigationViewAnimationType)animationType;

/**
 *  @brief 出栈最上面的控制器方法
 *
 *  @param animationType  动画类型
 *  @param completionBlock 动画完成后执行的block
 *  @return 返回出栈的控制器
 */
- (UIViewController *)popViewControllerWithAnimationType:(XMNavigationViewAnimationType)animationType
                                     animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock;


/**
 *  @brief 出栈 指定控制器 之上的所有控制器
 *
 *  @param viewController 目标控制器
 *  @param animated       是否需要动画，如果animated为YES 则 默认寻找与其push对应的动画类型
 *
 *  @return 出栈的控制器数组
 */
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;


/**
 *  @brief 出栈 指定控制器 之上的所有控制器
 *
 *  @param viewController 目标控制器
 *  @param animated       是否需要动画，如果animated为YES 则 默认寻找与其push对应的动画类型
 *  @param completionBlock 动画完成后执行的block
 *
 *  @return 出栈的控制器数组
 */
- (NSArray *)popToViewController:(UIViewController *)viewController
                        animated:(BOOL)animated
             animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock;

/**
 *  @brief 出栈 指定控制器 之上的所有控制器
 *
 *  @param viewController 目标控制器
 *  @param animationType  动画类型
 *
 *  @return 出栈的控制器数组
 */
- (NSArray *)popToViewController:(UIViewController *)viewController
               withAnimationType:(XMNavigationViewAnimationType)animationType;

/**
 *  @brief 出栈 指定控制器 之上的所有控制器
 *
 *  @param viewController 目标控制器
 *  @param animationType  动画类型
 *  @param completionBlock 动画完成后执行的block
 *
 *  @return 出栈的控制器数组
 */
- (NSArray *)popToViewController:(UIViewController *)viewController
               withAnimationType:(XMNavigationViewAnimationType)animationType
             animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock;



/**
 *  @brief 出栈到根控制器的方法
 *
 *  @param animated 是否需要动画，如果animated为YES 则 默认寻找与其push对应的动画类型
 *
 *  @return 返回出栈的控制器数组
 */
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

/**
 *  @brief 出栈到根控制器的方法
 *
 *  @param animated 是否需要动画，如果animated为YES 则 默认寻找与其push对应的动画类型
 *  @param completionBlock 动画完成后执行的block
 *
 *  @return 返回出栈的控制器数组
 */
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
                         animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock;


/**
 *  @brief 出栈 到根控制器
 *
 *  @param animationType  动画类型
 *
 *  @return 出栈的控制器数组
 */
- (NSArray *)popToRootViewControllerWithAnimationType:(XMNavigationViewAnimationType)animationType;


/**
 *  @brief 出栈 到根控制器
 *
 *  @param animationType  动画类型
 *  @param completionBlock 动画完成后执行的block
 *
 *  @return 出栈的控制器数组
 */
- (NSArray *)popToRootViewControllerWithAnimationType:(XMNavigationViewAnimationType)animationType
                                  animationCompletion:(XMNavigationAnimationCompletionBlock)completionBlock;

/**
 用于重置View的层级关系
 */
- (void)resetSubViews;

@end
