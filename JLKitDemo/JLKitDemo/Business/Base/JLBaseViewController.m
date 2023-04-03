//
//  JLBaseViewController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/11.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "JLBaseViewController.h"
#import "UIImage+JL.h"
#import "MTNavigationItemFactory.h"
#import "GlobalFunction.h"

@interface JLBaseViewController ()

//@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation JLBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - 旋屏相关

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


#pragma mark - 电池条默认样式

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


#pragma mark - action

- (void)leftButtonAction:(id)sender {
//    if ([[UIStackManager sharedInstance] isPresentViewController:self]){
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else if (self.parentViewController) {
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma mark - NavgiationBarOfViewControllerProtocol

- (void)setUpNavigationBarUI {
    
}

- (NSArray<UIBarButtonItem *> *)navigationBarLeftBarButtonItems
{
    return [MTNavigationItemFactory createBackBarItemsWithTitle:[self backTitle]
                                            touchUpInsideTarget:self
                                                         action:@selector(leftButtonAction:)];
}

- (NSArray<UIBarButtonItem *> *)navigationBarRightBarButtonItems
{
    return nil;
}

- (UIImage *)navigationBarBackgroundImage {
    return [self navigationBarBackgroundImageForHomepage];
}

- (UIImage *)navigationBarBackgroundImageForHomepage {
    return [UIImage imageWithUIColor:UIColorFromIntValue_rgba(55, 149, 250, 1.0)];
}

- (NSDictionary *)navigationBarTitleTextAttributes {
    
    return @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                               NSFontAttributeName:[UIFont systemFontOfSize:15] };
}
- (CGFloat)alphaOfNavigationBar
{
    return 1.0;
}

- (NSString *)title
{
    return @" ";
}

- (void)setTitle:(NSString *)title {
    if (title) {
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:[self navigationBarTitleTextAttributes]];
//        NSAttributedString *newTitle = [attributedTitle newStringTruncateTo:[UIScreen mainScreen].bounds.size.width / 2.0 beforeIndex:title.length truncatedToken:@"..."];
        [super setTitle:attributedTitle.string];
    } else {
        [super setTitle:title];
    }
}

- (NSString *)backTitle {
    NSString *backTitle = nil;
    UIViewController *lastVC = [self lastVC];
    if ([lastVC isKindOfClass:[JLBaseViewController class]]) {
        backTitle = ((JLBaseViewController *)lastVC).backTitleForPeakViewController;
    }
    
    if (!backTitle) {
        if (![lastVC.title isEqualToString:@" "] && lastVC.title) {
            backTitle = lastVC.title;
            if (backTitle) {
                NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:backTitle attributes:@{NSFontAttributeName : [[UIColor blackColor] colorWithAlphaComponent:0.6f]}];
                
                backTitle = attributedTitle.string;
            }
        } else {
            backTitle = @"返回";
        }
    }
    return backTitle;
}

- (NSString *)backTitleForPeakViewController {
    return nil;
}

- (BOOL)hidesBackButtonOfNavigationBar
{
    return YES;
}


#pragma mark - private

- (UIViewController *)lastVC
{
    __block UIViewController *vc = nil;
    
    NSArray *vcArray = self.navigationController.viewControllers;
    [vcArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *tmpvc = obj;
        if (tmpvc == self) {
            return;
        }
        
        vc = tmpvc;
        *stop = YES;
    }];
    
    return vc;
}
@end
