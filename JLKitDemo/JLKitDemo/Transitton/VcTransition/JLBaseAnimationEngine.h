//
//  JLBaseAnimationEngine.h
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/26.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLBaseAnimationEngine : NSObject<
 UIViewControllerAnimatedTransitioning
>

@property (nonatomic, assign) BOOL reverse;

@property (nonatomic, assign) NSTimeInterval animaitonDuration;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView;

@end
