//
//  UIViewController+PresentController.m
//  MiTalk
//
//  Created by wangjianlong on 2018/3/28.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import "UIViewController+PresentController.h"
#import "MTPresentationController.h"

@implementation UIViewController (PresentController)

- (void)customPresentViewController:(UIViewController <CustomPresentViewControllerProtocol>*)viewController animated:(BOOL)flag completion:(void (^)(void))completion
{
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:flag completion:completion];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    MTPresentationController *presentController =[[MTPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    return presentController;
}

@end
