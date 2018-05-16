//
//  JLNavigationController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/11.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "JLNavigationController.h"
//#import "UINavigationController+DelegateManager.h"
#import "UINavigationBar+BackGroundImage.h"
#import "NavgiationBarOfViewControllerProtocol.h"

@interface JLNavigationController ()<
    UINavigationBarDelegate,
    UINavigationControllerDelegate
>

@end

@implementation JLNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]){
//        [self setDelegate:[[_UINavigationControllerDelegateManager alloc] init]];
        self.delegate = self;
    }
    return self;
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

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

-(UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController <NavgiationBarOfViewControllerProtocol>*)viewController animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(hiddenNavigationBar)]) {
        [navigationController setNavigationBarHidden:[viewController hiddenNavigationBar] animated:YES];
    }
    
}

//- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
//{
//    if ([delegate isKindOfClass:NSClassFromString(@"_UINavigationControllerDelegateManager")]) {
//        [self addDelegate:delegate queue:nil];
//        return;
//    }
//    [super setDelegate:delegate];
//}

@end
