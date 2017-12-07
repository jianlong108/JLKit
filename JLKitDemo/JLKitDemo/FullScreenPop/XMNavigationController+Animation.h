//
//  XMNavigationController+Animation.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "XMNavigationController.h"
#import "XMNavigationGlobalDefines.h"

@interface XMNavigationController (Animation)

- (void)pushAnimationType:(XMNavigationViewAnimationType)animationType fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController onCompletion:(XMNavigationAnimationCompletionBlock)completionBlock;

- (void)popAnimationType:(XMNavigationViewAnimationType)animationType fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController onCompletion:(XMNavigationAnimationCompletionBlock)completionBlock;

@end
