//
//  JLPresentationController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/11.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "JLPresentationController.h"
#import "UIViewController+BottomPresent.h"

@interface JLPresentationController()

@property (nonatomic, strong) UIVisualEffectView * visualView;

@property (nonatomic, assign) CGFloat controllerHeight;

@end

@implementation JLPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController<BottomPresentViewControllerProtocol> *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    _controllerHeight = [presentedViewController controllerViewHeight];
    if (_controllerHeight == 0 ) {
        _controllerHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
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
    
    if ([self.presentedViewController respondsToSelector:@selector(contentViewFrame)]) {
        CGRect frame = [[self.presentedViewController performSelector:@selector(contentViewFrame)] CGRectValue];
        return frame;
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

