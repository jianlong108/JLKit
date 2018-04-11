//
//  UIViewController+PresentController.h
//  MiTalk
//
//  Created by wangjianlong on 2018/3/28.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPresentViewControllerProtocol.h"

@interface UIViewController (PresentController)<UIViewControllerTransitioningDelegate>

- (void)customPresentViewController:(UIViewController <CustomPresentViewControllerProtocol>*)viewController animated:(BOOL)flag completion:(void (^)(void))completion;

@end
