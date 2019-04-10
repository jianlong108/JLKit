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
@property(nonatomic,weak) InfiniteLoops *loop;
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
        _scrollNavigationController.hidesTitleBarWhenScrollToTop = NO;
        _scrollNavigationController.headScrollEnable = YES;
        
        _scrollNavigationController.scrollTitleBarItemColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _scrollNavigationController.scrollTitleBarItemSelectColor = [UIColor whiteColor];
        _scrollNavigationController.scrollTitleBarLineViewSelectColor = [UIColor whiteColor];
        _scrollNavigationController.scrollTitleBarItemFont = [UIFont systemFontOfSize:15];
        _scrollNavigationController.scrollTitleBarLineViewHeight = 3;

        _scrollNavigationController.scrollStyle = JLScrollNaviContentControllerScrollStyle_selfPriority;
    }
    return _scrollNavigationController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //防止内存占用严重时,view会被释放,会重新调用viewdidload方法.
    [self.scrollNavigationController.view removeFromSuperview];
    self.scrollNavigationController.view.frame = self.view.bounds;
    [self.view addSubview:self.scrollNavigationController.view];
    self.scrollNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [self.scrollNavigationController removeFromParentViewController];
    [self addChildViewController:_scrollNavigationController];
    [_scrollNavigationController didMoveToParentViewController:self];
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

- (void)headerTableViewController:(JLScrollNavigationController *)controller offsetHasReachCriticalValueWithScrollDirectionUp:(BOOL)isUp
{
    NSLog(@"offsetHasReachCriticalValueWithScrollDirectionUp %d",isUp);
    CGFloat offsetY = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    if (isUp) {
        
        CGRect rect = controller.scrollTitleBar.frame;
        if (!CGRectEqualToRect(rect, CGRectMake(0, 170, CGRectGetWidth(rect), 44+offsetY))) {
            _loop.frame = CGRectMake(0, 0, CGRectGetWidth(rect), 170 - offsetY);
            controller.scrollTitleBar.frame = CGRectMake(0, CGRectGetMaxY(_loop.frame), CGRectGetWidth(rect), 44+offsetY);
        }
        
    } else {
        CGRect rect = controller.scrollTitleBar.frame;
        
        if (!CGRectEqualToRect(rect, CGRectMake(0, 170 , CGRectGetWidth(rect), 44))) {
            _loop.frame = CGRectMake(0, 0, CGRectGetWidth(rect), 170);
            controller.scrollTitleBar.frame = CGRectMake(0, CGRectGetMaxY(_loop.frame), CGRectGetWidth(rect), 44);
        }
    }
}

- (UIView *)headerViewForScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController
{
    
    InfiniteLoops *loop = [[InfiniteLoops alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 170) scrollDuration:3.f];
    [loop setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:loop];
    loop.imageURLStrings = @[
                             @"http://youimg1.c-ctrip.com/target/tg/380/211/325/c4c9ed50a1d54aabb827ccad5a6bbde0.jpg",
                             @"http://youimg1.c-ctrip.com/target/tg/380/211/325/c4c9ed50a1d54aabb827ccad5a6bbde0.jpg",
                             @"http://youimg1.c-ctrip.com/target/tg/380/211/325/c4c9ed50a1d54aabb827ccad5a6bbde0.jpg"
                             ];
    loop.clickAction = ^(NSInteger index) {
        
    };
    _loop = loop;
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


- (NSInteger)gapForEachItemInTitleBarOfScrollNavigationController:(JLScrollNavigationController *)scrollNavigationController
{
    return 22;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)hiddenNavigationBar
{
    return YES;
}

@end
