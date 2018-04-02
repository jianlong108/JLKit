//
//  HomeContainerController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/4/1.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "HomeContainerController.h"
#import "MTScrollContainerViewController.h"
#import "HomeViewController.h"
#import "UIImage+JL.h"
#import "GlobalFunction.h"
#import "HomeFunctionViewController.h"

@interface HomeContainerController ()<
    MTScrollNavigationViewControllerDataSource,
    MTScrollNavigationViewControllerDelegate
>
@property(nonatomic,strong) MTScrollContainerViewController *scrollNavigationController;
@end

@implementation HomeContainerController

- (MTScrollContainerViewController *)scrollNavigationController
{
    if (_scrollNavigationController == nil) {
        _scrollNavigationController = [[MTScrollContainerViewController alloc]init];
        _scrollNavigationController.scrollNavigationDelegate = self;
        _scrollNavigationController.scrollNavigationDataSource = self;
    }
    return _scrollNavigationController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //防止内存占用严重时,view会被释放,会重新调用viewdidload方法.
    [self.scrollNavigationController.view removeFromSuperview];
    [self.view addSubview:self.scrollNavigationController.view];
    
    [self.scrollNavigationController removeFromParentViewController];
    [self addChildViewController:_scrollNavigationController];
    [_scrollNavigationController didMoveToParentViewController:self];
}

- (NSInteger)numberOfTitleInScrollNavigationViewController:(MTScrollContainerViewController *)scrollNavigationVC
{
    return 2;
}


- (NSString *)scrollNavigationViewController:(MTScrollContainerViewController*)scrollNavigationVC titleForIndex:(NSInteger)index
{
    if (index == 0) {
        return @"控件";
    } else {
        return @"功能";
    }
}

- (UIViewController *)scrollNavigationViewController:(MTScrollContainerViewController*)scrollNavigationVC childViewControllerForIndex:(NSInteger)index
{
    if (index == 0) {
        return [[HomeViewController alloc]init];
    } else {
        return [[HomeFunctionViewController alloc]init];
    }
}

#pragma mark - navigationBar

- (NSString *)title
{
    return @"主页";
}

- (NSArray<UIBarButtonItem *> *)navigationBarLeftBarButtonItems
{
    return nil;
}

@end
