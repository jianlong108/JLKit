//
//  NavigationTranstionEngine.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/12.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationTranstionEngine : NSObject

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;

- (UIPercentDrivenInteractiveTransition *)interactivePopTransition;


@end
