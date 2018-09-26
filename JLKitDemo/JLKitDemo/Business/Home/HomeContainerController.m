//
//  HomeContainerController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/4/1.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "HomeContainerController.h"
#import "JLScrollNavigationController.h"
#import "HomeViewController.h"
#import "UIImage+JL.h"
#import "GlobalFunction.h"
#import "HomeFunctionViewController.h"
#import "NavgiationBarOfViewControllerProtocol.h"


#import "InfiniteLoops.h"

@interface HomeContainerController ()<
    JLScrollNavigationControllerDataSource,
    JLScrollNavigationControllerDelegate
>
@property(nonatomic,strong) JLScrollNavigationController *scrollNavigationController;


@property (nonatomic, weak) HomeViewController *homeVc;
@property (nonatomic, weak) HomeFunctionViewController *homeFunctionVc;

@end

@implementation HomeContainerController

- (JLScrollNavigationController *)scrollNavigationController
{
    if (_scrollNavigationController == nil) {
        _scrollNavigationController = [[JLScrollNavigationController alloc]init];
        _scrollNavigationController.scrollNavigationDelegate = self;
        _scrollNavigationController.scrollNavigationDataSource = self;
        _scrollNavigationController.topTitleStyle = JLScrollTitleBarElementStyleCenter;
        _scrollNavigationController.scrollTitleBar.backgroundColor = [UIColor whiteColor];
        
        _scrollNavigationController.scrollTitleBarItemColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _scrollNavigationController.scrollTitleBarItemSelectColor = [UIColor whiteColor];//UIColorFromRGB(0x14b9c7);
        _scrollNavigationController.scrollTitleBarLineViewSelectColor = [UIColor whiteColor];//UIColorFromRGB(0x14b9c7);
        _scrollNavigationController.scrollTitleBarItemFont = [UIFont systemFontOfSize:15];
        _scrollNavigationController.scrollTitleBarLineViewHeight = 3;
        
        _scrollNavigationController.hidesTitleBarWhenScrollToTop = NO;
        _scrollNavigationController.headScrollEnable = YES;
        _scrollNavigationController.scrollStyle = JLScrollNaviContentControllerScrollStyle_contentControllerPriority;
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollNavigationController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
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

- (UIColor *)scrollNavigationController:(JLScrollNavigationController *)scrollNavigationController scrollTitleBarBackgroundColorWithIndex:(NSUInteger)index
{
    if (index == 0) {
        return [UIColor colorWithRed:151/255.0 green:234/255.0 blue:250/255.0 alpha:1.0f];
    }
    return [UIColor colorWithRed:115/255.0 green:248/255.0 blue:95/255.0 alpha:1.0f];
}

- (NSInteger)numberOfTitleInScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController {
    return 2;
}

- (UIViewController<JLScrollNavigationChildControllerProtocol> *)scrollNavigationController:(JLScrollNavigationController *)scrollNavigationController childViewControllerForIndex:(NSInteger)index {
    if (index == 0) {
        if (_homeVc) {
            return _homeVc;
        }
        HomeViewController *home = [[HomeViewController alloc]init];
        _homeVc = home;
        return _homeVc;
    } else {
        if (_homeFunctionVc) {
            return _homeFunctionVc;
        }
        HomeFunctionViewController *home = [[HomeFunctionViewController alloc]init];
        _homeFunctionVc = home;
        return _homeFunctionVc;
    }
}

- (NSString *)scrollNavigationController:(JLScrollNavigationController *)scrollNavigationController titleForIndex:(NSInteger)index {
    if (index == 0) {
        return @"控件";
    } else {
        return @"功能";
    }
}

- (CGFloat)scrollTitleBarHeightOfScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController
{
    return 44;
}

- (NSInteger)gapForEachItemInTitleBarOfScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController
{
    return 22;
}

- (UIView *)headerViewForScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController
{
    InfiniteLoops *loop = [[InfiniteLoops alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300) scrollDuration:3.f];
    loop.backgroundColor = [UIColor blackColor];
    
    loop.imageURLStrings = @[@"1.jpg", @"2.jpg", @"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg",@"9.jpg",@"10.jpg"];
    loop.clickAction = ^(NSInteger index) {
        NSLog(@"curIndex: %ld", index);
    };
     return loop;
}

- (BOOL)hiddenNavigationBar
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
