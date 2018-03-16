//
//  MTNavigationController.m
//  MiTalk
//
//  Created by pingshw on 17/8/2.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "MTNavigationController.h"
#import "SkinUtil.h" 
#import "UIImage+Colorful.h"
#import "MTBaseViewController.h"
#import "NoNavViewController.h"
#import "TransitionManager.h"

@interface MTNavigationController () <UINavigationControllerDelegate>


@end

@implementation MTNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.tintColor = [CURRENT_SKIN navigationItemTintColorForNormal];
    self.delegate = [TransitionManager sharedInstance];
    
    [self.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName : [CURRENT_SKIN navigationTitleColor],
                                                  NSFontAttributeName: [CURRENT_SKIN navigationTitleFont]}];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

-(UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (void)updateNavigationBarUI {
//    UIViewController *lastVC = self.viewControllers.lastObject;
//    if ([lastVC isKindOfClass:[NoNavViewController class]]) {
//        if (@available(iOS 11.0, *)) {
//            self.navigationBar.translucent = YES;
//        }
//    } else {
//        self.navigationBar.translucent = NO;
//    }
//
//
//    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName : [CURRENT_SKIN navigationTitleColor],
//                                          NSFontAttributeName : [CURRENT_SKIN navigationTitleFont]} ;
//    UIImage *backgroundImage = [UIImage new];
//    if ([lastVC conformsToProtocol:@protocol(MTBaseViewControllerProtocol)]) {
//        titleTextAttributes = [(id<MTBaseViewControllerProtocol>)lastVC navigationBarTitleTextAttributes];
//        backgroundImage = [(id<MTBaseViewControllerProtocol>)lastVC navigationBarBackgroundImage];
//    }
//
//    [self.navigationBar setTitleTextAttributes:titleTextAttributes];
//    [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setShadowImage:[UIImage new]];
//
//    //update left,right bar buttons if needed
//    if ([lastVC conformsToProtocol:@protocol(MTBaseViewControllerProtocol)]) {
//        UINavigationItem *targetItem = self.navigationBar.topItem;
//        if ([targetItem isEqual:lastVC.navigationItem]) {
//            if ([lastVC respondsToSelector:@selector(navigationBarLeftBarButtonItems)]) {
//                targetItem.leftBarButtonItems = [(id<MTBaseViewControllerProtocol>)lastVC navigationBarLeftBarButtonItems];
//            }
//
//            if ([lastVC respondsToSelector:@selector(navigationBarRightBarButtonItems)]) {
//                targetItem.rightBarButtonItems = [(id<MTBaseViewControllerProtocol>)lastVC navigationBarRightBarButtonItems];
//            }
//        }
//    }
}



- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (void)addChildViewController:(UIViewController *)childController{
    [super addChildViewController:childController];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    [super setViewControllers:viewControllers animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if ([self.topViewController isKindOfClass:[viewController class]]) {
        return;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    if (self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = NO;
    }else{
        viewController.hidesBottomBarWhenPushed = YES;
    }
    return viewController;
}

- (UIImage *)navigationBarBackgroundImage {
    return [UIImage createImageWithColor:COLOR255(0x14, 0xb9, 0xc7, 1.0)];
}

@end


