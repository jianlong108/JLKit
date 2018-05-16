//
//  HomeContainerController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/4/1.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "HomeContainerController.h"
#import "MTScrollNavigationController.h"
#import "HomeViewController.h"
#import "UIImage+JL.h"
#import "GlobalFunction.h"
#import "HomeFunctionViewController.h"
#import "NavgiationBarOfViewControllerProtocol.h"

@interface HomeContainerController ()<
    MTScrollNavigationControllerDataSource,
    MTScrollNavigationControllerDelegate
>
@property(nonatomic,strong) MTScrollNavigationController *scrollNavigationController;
@end

@implementation HomeContainerController

- (MTScrollNavigationController *)scrollNavigationController
{
    if (_scrollNavigationController == nil) {
        _scrollNavigationController = [[MTScrollNavigationController alloc]init];
        _scrollNavigationController.scrollNavigationDelegate = self;
        _scrollNavigationController.scrollNavigationDataSource = self;
        _scrollNavigationController.topTitleStyle = MTScrollTitleBarElementStyleAvarge;
        _scrollNavigationController.scrollTitleBar.backgroundColor = [UIColor whiteColor];
        _scrollNavigationController.hidesTitleBarWhenScrollToTop = NO;
        _scrollNavigationController.headScrollEnable = NO;
        
        _scrollNavigationController.scrollTitleBarItemColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _scrollNavigationController.scrollTitleBarItemSelectColor = UIColorFromRGB(0x14b9c7);
        _scrollNavigationController.scrollTitleBarLineViewSelectColor = UIColorFromRGB(0x14b9c7);
        _scrollNavigationController.scrollTitleBarItemFont = [UIFont systemFontOfSize:15];
        _scrollNavigationController.scrollTitleBarLineViewHeight = 3;
    }
    return _scrollNavigationController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    //防止内存占用严重时,view会被释放,会重新调用viewdidload方法.
    [self.scrollNavigationController.view removeFromSuperview];
    [self.view addSubview:self.scrollNavigationController.view];
    
    [self.scrollNavigationController removeFromParentViewController];
    [self addChildViewController:_scrollNavigationController];
    [_scrollNavigationController didMoveToParentViewController:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollNavigationController.view.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 20);
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



- (NSInteger)numberOfTitleInScrollNavigationController:(MTScrollNavigationController *)scrollNavigationController {
    return 2;
}

- (UIViewController<MTScrollNavigationChildControllerProtocol> *)scrollNavigationController:(MTScrollNavigationController *)scrollNavigationController childViewControllerForIndex:(NSInteger)index {
    if (index == 0) {
        return [[HomeViewController alloc]init];
    } else {
        return [[HomeFunctionViewController alloc]init];
    }
}

- (NSString *)scrollNavigationController:(MTScrollNavigationController *)scrollNavigationController titleForIndex:(NSInteger)index {
    if (index == 0) {
        return @"控件";
    } else {
        return @"功能";
    }
}

- (BOOL)hiddenNavigationBar
{
    return YES;
}

@end
