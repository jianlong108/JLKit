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
<<<<<<< HEAD
        _scrollNavigationController.hidesTitleBarWhenScrollToTop = NO;
        _scrollNavigationController.headScrollEnable = YES;
=======
>>>>>>> master
        
        _scrollNavigationController.scrollTitleBarItemColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _scrollNavigationController.scrollTitleBarItemSelectColor = [UIColor whiteColor];//UIColorFromRGB(0x14b9c7);
        _scrollNavigationController.scrollTitleBarLineViewSelectColor = [UIColor whiteColor];//UIColorFromRGB(0x14b9c7);
        _scrollNavigationController.scrollTitleBarItemFont = [UIFont systemFontOfSize:15];
        _scrollNavigationController.scrollTitleBarLineViewHeight = 3;
<<<<<<< HEAD
=======
        
        _scrollNavigationController.hidesTitleBarWhenScrollToTop = NO;
        _scrollNavigationController.headScrollEnable = YES;
>>>>>>> master
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

- (UIView *)headerViewForScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController
{
    
    InfiniteLoops *loop = [[InfiniteLoops alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 170) scrollDuration:3.f];
    [loop setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:loop];
    loop.imageURLStrings = @[@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1537025576&di=b83dea80577620cfe93972ddc5361298&src=http://x.itunes123.com/uploadfiles/3e5f9baf62af8980e6d8727f86fc9255.jpg", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537035661333&di=75c393ea857d31921d82362ddbd28f53&imgtype=0&src=http%3A%2F%2Fi6.qhimg.com%2Ft017d518491f0aa0869.jpg", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537035661333&di=9bad9481b07a7cc14c12e66f01488fcf&imgtype=0&src=http%3A%2F%2F01.imgmini.eastday.com%2Fmobile%2F20180801%2Fab115051b9871c67a9a408764eadf50a_wmk.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537035661330&di=92f0326acb21ff7b23ce7439b60f044b&imgtype=0&src=http%3A%2F%2Fliaocheng.dzwww.com%2Fyule%2Fylxt%2F201808%2FW020180817341168342768.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537036077815&di=fbb8c236e25a10f171212d82a57c5d3a&imgtype=0&src=http%3A%2F%2Fwww.wownews.tw%2Fupload_images_b%2F2015%2F10%2F23%2F016%2F5629fad047fd4.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537036077812&di=c06bf13af87688977a62c04a6e3ac65f&imgtype=0&src=http%3A%2F%2Fs7.sinaimg.cn%2Fmw690%2F0060RFVZzy7klvAosku46%26690"];
    loop.clickAction = ^(NSInteger index) {
        
    };
    return loop;
}

- (CGFloat)scrollTitleBarHeightOfScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController
{
    return 44;
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

<<<<<<< HEAD
- (BOOL)prefersStatusBarHidden{
    return YES;
=======
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
>>>>>>> master
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
