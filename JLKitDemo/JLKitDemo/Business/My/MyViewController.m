//
//  MyViewController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/11.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "MyViewController.h"
#import "SimpleCell.h"
#import "SimpleItem.h"
#import "OTSectionModel.h"
#import "SettingViewController.h"
#import "LoginViewController.h"

@interface MyViewController ()


@end

@implementation MyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[SimpleCell class] forCellReuseIdentifier:SimpleCell_ReuseIdentifer];
   
//    [self transitionSetting];
    self.title = @"我的";
    
    [self setUpModel];
}

- (void)setUpModel
{
    __weak typeof(self)weakSelf = self;
    OTSectionModel *sectionOne = [[OTSectionModel alloc]init];
    sectionOne.footerHeight = 7;
    sectionOne.headerHeight = 7;
    
    SimpleItem *model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"登录页";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        SettingViewController *vc = [[SettingViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"设置";
    [sectionOne.items addObject:model];
    
    
    [self.sectionItems addObject:sectionOne];
}


//- (void)transitionSetting
//{
//
//    //启动XXTransition自定义转场
//    [XXTransition startGoodJob:GoodJobTypeAll transitionDuration:0.3];
//
//    //更改全局NavTransiton效果
//    [XXTransition setNavTransitonKey:XXTransitionAnimationNavSink];
//
//    //自定义特殊ViewController的NavTransiton效果和返回手势
//    [XXTransition registerPushViewController:[LoginViewController class] forTransitonKey:XXTransitionAnimationNavSink];
////    [XXTransition registerPushViewController:[LoginViewController class] forTransitonKey:XXTransitionAnimationNavPage];
//    [XXTransition registerPopGestureType:XXPopGestureTypeFullScreen forViewController:[LoginViewController class]];
////    [XXTransition registerPopGestureType:XXPopGestureTypeForbidden forViewController:[LoginViewController class]];
//
//    //添加自定义NavTransiton效果
//    NSString *demoTransitionAnimationFragment = @"demoTransitionAnimationFragment";
//    [XXTransition addPushAnimation:demoTransitionAnimationFragment animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
//
//        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//        UIView *containerView = [transitionContext containerView];
//        UIView *toVCTempView = [toVC.view snapshotViewAfterScreenUpdates:YES];
//        [containerView addSubview:toVC.view];
//        [containerView sendSubviewToBack:toVC.view];
//
//        NSMutableArray *fragmentViews = [[NSMutableArray alloc] init];
//
//        CGSize size = fromVC.view.frame.size;
//        CGFloat fragmentWidth = 20.0f;
//
//        NSInteger rowNum = size.width/fragmentWidth + 1;
//        for (int i = 0; i < rowNum ; i++) {
//
//            for (int j = 0; j < size.height/fragmentWidth + 1; j++) {
//
//                CGRect rect = CGRectMake(i*fragmentWidth, j*fragmentWidth, fragmentWidth, fragmentWidth);
//                UIView *fragmentView = [toVCTempView resizableSnapshotViewFromRect:rect  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
//                [containerView addSubview:fragmentView];
//                [fragmentViews addObject:fragmentView];
//                fragmentView.frame = rect;
//                fragmentView.layer.transform = CATransform3DMakeTranslation( random()%50 *50, 0, 0);
//                fragmentView.alpha = 0;
//            }
//
//        }
//
//
//        [UIView animateWithDuration:duration animations:^{
//            for (UIView *fragmentView in fragmentViews) {
//                fragmentView.layer.transform = CATransform3DIdentity;
//                fragmentView.alpha = 1;
//
//            }
//        } completion:^(BOOL finished) {
//            for (UIView *fragmentView in fragmentViews) {
//                [fragmentView removeFromSuperview];
//            }
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//        }];
//    }];
//
//    [XXTransition addPopAnimation:demoTransitionAnimationFragment animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
//        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//        UIView *containerView = [transitionContext containerView];
//        UIView *fromTempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
//
//        [containerView addSubview:toVC.view];
//
//        NSMutableArray *fragmentViews = [[NSMutableArray alloc] init];
//
//        CGSize size = fromVC.view.frame.size;
//        CGFloat fragmentWidth = 20.0f;
//
//        NSInteger rowNum = size.width/fragmentWidth + 1;
//        for (int i = 0; i < rowNum ; i++) {
//
//            for (int j = 0; j < size.height/fragmentWidth + 1; j++) {
//
//                CGRect rect = CGRectMake(i*fragmentWidth, j*fragmentWidth, fragmentWidth, fragmentWidth);
//                UIView *fragmentView = [fromTempView resizableSnapshotViewFromRect:rect  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
//                [containerView addSubview:fragmentView];
//                [fragmentViews addObject:fragmentView];
//                fragmentView.frame = rect;
//            }
//
//        }
//
//        [UIView animateWithDuration:duration animations:^{
//            for (UIView *fragmentView in fragmentViews) {
//
//                CGRect rect = fragmentView.frame;
//
//                rect.origin.x = rect.origin.x + random()%50 *50;
//                fragmentView.frame = rect;
//                fragmentView.alpha = 0.0;
//            }
//        } completion:^(BOOL finished) {
//            for (UIView *fragmentView in fragmentViews) {
//                [fragmentView removeFromSuperview];
//            }
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//        }];
//
//    }];
//
//    [XXTransition registerPopGestureType:XXPopGestureTypeFullScreen forViewController:[SettingViewController class]];
////    [XXTransition registerPushViewController:[SettingViewController class] forTransitonKey:demoTransitionAnimationFragment];
//
//    //添加自定义ModalTransiton效果,使用需调用UIViewController+XXTransition方法 - xx_presentViewController: makeAnimatedTransitioning: completion:
//    NSString *demoTransitionAnimationModalSink = @"DemoTransitionAnimationModalSink";
//    __weak typeof(self) weakSelf = self;
//    [XXTransition addPresentAnimation:demoTransitionAnimationModalSink animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
//        UIView *containerView = [transitionContext containerView];
//        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
//        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
//        UIView *tempView = [fromView snapshotViewAfterScreenUpdates:NO];
//        fromView.hidden = YES;
//
//        [containerView addSubview:tempView];
//        [containerView addSubview:toView];
//
//        toView.frame = CGRectMake(0, CGRectGetHeight(containerView.frame), CGRectGetWidth(containerView.frame), 400);
//
//        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5 animations:^{
//                tempView.layer.transform = [weakSelf sinkTransformFirstPeriod];;
//            }];
//
//            [UIView addKeyframeWithRelativeStartTime:.5 relativeDuration:.5 animations:^{
//                tempView.layer.transform = [weakSelf sinkTransformSecondPeriod];
//                toView.transform = CGAffineTransformMakeTranslation(0, -400);
//            }];
//        } completion:^(BOOL finished) {
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//        }];
//    }];
//
//    [XXTransition addDismissAnimation:demoTransitionAnimationModalSink backGestureDirection:XXBackGesturePanDown animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
//        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
//        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
//        UIView *tempView = [transitionContext containerView].subviews[0];
//
//        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5 animations:^{
//                fromView.transform = CGAffineTransformIdentity;
//                tempView.layer.transform = [weakSelf sinkTransformFirstPeriod];
//            }];
//
//            [UIView addKeyframeWithRelativeStartTime:.5 relativeDuration:.5 animations:^{
//                tempView.layer.transform = CATransform3DIdentity;
//            }];
//        } completion:^(BOOL finished) {
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//            if (![transitionContext transitionWasCancelled]) {
//                toView.hidden = NO;
//                [tempView removeFromSuperview];
//            }
//        }];
//    }];
//}

- (CATransform3D)sinkTransformFirstPeriod{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/-900;
    t = CATransform3DTranslate(t, 0, 0, -100);
    t = CATransform3DRotate(t, 15.0 * M_PI/180.0, 1, 0, 0);
    return t;
    
}

- (CATransform3D)sinkTransformSecondPeriod{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = [self sinkTransformFirstPeriod].m34;
    t = CATransform3DTranslate(t, 0, -40, 0);
    t = CATransform3DScale(t, 0.8, 0.8, 1);
    return t;
}
@end
