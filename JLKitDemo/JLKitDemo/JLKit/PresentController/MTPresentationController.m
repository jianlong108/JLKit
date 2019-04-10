//
//  MTPresentationController.m
//  MiTalk
//
//  Created by wangjianlong on 2018/3/28.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import "MTPresentationController.h"
#import "CustomPresentViewControllerProtocol.h"

@interface MTPresentationController()

@property (nonatomic, strong) UIVisualEffectView * visualView;

@property (nonatomic, assign) CGFloat controllerHeight;

@end

@implementation MTPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController<CustomPresentViewControllerProtocol> *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    if ([presentedViewController respondsToSelector:@selector(contentViewHeight)]) {
        _controllerHeight = [presentedViewController contentViewHeight];
    }
    return [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
}

- (void)presentationTransitionWillBegin{
    
    // 使用UIVisualEffectView实现模糊效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    _visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _visualView.frame = self.containerView.bounds;
    _visualView.alpha = 0.4;
    _visualView.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBlureView:)];
    [_visualView addGestureRecognizer:gesture];
    
    [self.containerView addSubview:_visualView];
    
    
}

- (void)presentationTransitionDidEnd:(BOOL)completed{
    
    // 如果呈现没有完成，那就移除背景 View
    if (!completed) {
        [_visualView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin{
    _visualView.alpha = 0.0;
}

- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if (completed) {
        [_visualView removeFromSuperview];
    }
}

- (CGRect)frameOfPresentedViewInContainerView{
    
    UIViewController <CustomPresentViewControllerProtocol>*presentedController = (UIViewController <CustomPresentViewControllerProtocol>*)self.presentedViewController;
    
    if ([presentedController respondsToSelector:@selector(contentViewFrame)]) {
       return [presentedController contentViewFrame];
    }
    
    CGFloat windowH = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat windowW = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    return CGRectMake(0,windowH - _controllerHeight,windowW, _controllerHeight);
}


- (void)tapBlureView:(UIGestureRecognizer *)gesture
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
