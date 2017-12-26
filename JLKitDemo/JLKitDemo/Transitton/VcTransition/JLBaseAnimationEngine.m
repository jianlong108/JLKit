//
//  JLBaseAnimationEngine.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/26.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "JLBaseAnimationEngine.h"

@implementation JLBaseAnimationEngine

- (id)init {
    if (self = [super init]) {
        self.animaitonDuration = 0.6f;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.animaitonDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    [self animateTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
}

// override by Subclass 
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
}

@end
