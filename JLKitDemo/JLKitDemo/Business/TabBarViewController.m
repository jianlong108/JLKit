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
    
    
    UINavigationController *homeNav = [[JLNavigationController alloc]initWithRootViewController:[HomeContainerController new]];
    [self addChildViewController:homeNav];
    homeNav.title = @"主页";
    
    UINavigationController *fullScrrenPop_Nav = [[JLNavigationController alloc]initWithRootViewController:[MyViewController new]];
    [self addChildViewController:fullScrrenPop_Nav];
    fullScrrenPop_Nav.title = @"我的";
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedViewController"] )
    {
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

-(id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return _panInteractionGesture.interactionInProgress ? _panInteractionGesture : nil;
}

@end
