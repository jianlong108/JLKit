//
//  TabBarViewController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/26.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "TabBarViewController.h"
#import "XMNavigationController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "JLNavigationController.h"
#import "JLFoldAnimationer.h"
#import "JLHorizontalPanInteraction.h"
#import "HomeContainerController.h"
#import "PrincipleViewController.h"
#import <libkern/OSAtomic.h>
#import <dlfcn.h>

@interface TabBarViewController ()<
    UITabBarControllerDelegate
>
{
    JLFoldAnimationer *_animationController;
    JLHorizontalPanInteraction *_panInteractionGesture;
}

@end

@implementation TabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    // create the interaction / animation controllers
//    _panInteractionGesture = [JLHorizontalPanInteraction new];
//    _animationController = [JLFoldAnimationer new];
//    _animationController.folders = 3;
    
    // observe changes in the currently presented view controller
//    [self addObserver:self
//           forKeyPath:@"selectedViewController"
//              options:NSKeyValueObservingOptionNew
//              context:nil];
    
    
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:[HomeViewController new]];
    [self addChildViewController:homeNav];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [[UIColor blueColor] colorWithAlphaComponent:0.4]} forState:UIControlStateSelected];
    
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"icon_tabbar_addressbook_normal"] selectedImage:[[UIImage imageNamed:@"icon_tabbar_addressbook_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *appleCodeNav = [[UINavigationController alloc]initWithRootViewController:[PrincipleViewController new]];
    [self addChildViewController:appleCodeNav];
    [appleCodeNav didMoveToParentViewController:self];
    appleCodeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"寻根溯源" image:[UIImage imageNamed:@"icon_tabbar_discover_normal"] selectedImage:[[UIImage imageNamed:@"icon_tabbar_discover_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *fullScrrenPop_Nav = [[UINavigationController alloc]initWithRootViewController:[MyViewController new]];
    [self addChildViewController:fullScrrenPop_Nav];
    [fullScrrenPop_Nav didMoveToParentViewController:self];
    fullScrrenPop_Nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"icon_tabbar_my_normal"] selectedImage:[[UIImage imageNamed:@"icon_tabbar_my_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"selectedViewController"] ) {
        // wire the interaction controller to the view controller
        [_panInteractionGesture wireToViewController:self.selectedViewController
                                             forOperation:JLInteractionOperationTab];
    }
}



- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC {
    
    NSUInteger fromVCIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSUInteger toVCIndex = [tabBarController.viewControllers indexOfObject:toVC];
    
    _animationController.reverse = fromVCIndex < toVCIndex;
    return _animationController;
}

-(id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return _panInteractionGesture.interactionInProgress ? _panInteractionGesture : nil;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
