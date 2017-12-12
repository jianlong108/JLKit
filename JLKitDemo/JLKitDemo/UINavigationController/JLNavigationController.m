//
//  JLNavigationController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/11.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "JLNavigationController.h"
#import "UINavigationController+DelegateManager.h"

@interface JLNavigationController ()

@end

@implementation JLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]){
        [self setDelegate:[[_UINavigationControllerDelegateManager alloc] init]];
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    if (self.viewControllers.count == 1) {
        vc.hidesBottomBarWhenPushed = NO;
    }
    return vc;
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    if ([delegate isKindOfClass:NSClassFromString(@"_UINavigationControllerDelegateManager")]) {
        [self addDelegate:delegate queue:nil];
        return;
    }
    [super setDelegate:delegate];
}

@end
