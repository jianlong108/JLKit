//
//  UIViewController+BottomPresent.m
//  JLKitDemo
//
//  Created by wangjianlong on 2018/3/27.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "UIViewController+BottomPresent.h"
#import "JLPresentationController.h"

@implementation UIViewController (BottomPresent)

- (void)customPresentViewController:(UIViewController <BottomPresentViewControllerProtocol>*)viewController animated:(BOOL)flag completion:(void (^)(void))completion
{
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:flag completion:completion];
    
}


@end
