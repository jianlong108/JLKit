//
//  MTBaseViewController.m
//  MiTalk
//
//  Created by pingshw on 17/8/2.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "MTBaseViewController.h"
#import "SkinUtil.h" 
#import "UIStackManager.h"
#import "MTNavigationController.h"
#import "UIImage+Colorful.h"
#import "NSAttributedString+Truncate.h"
#import "MBProgressHUD.h"

@interface MTBaseViewController ()

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation MTBaseViewController 

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
    if ([[UIStackManager sharedInstance] isPresentViewController:self]){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.parentViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - NavgiationBarOfViewControllerProtocol

- (NSArray<UIBarButtonItem *> *)navigationBarLeftBarButtonItems
{
    return [MTNavigationItemFactory createBackBarItemsWithTitle:[self backTitle]
                                            touchUpInsideTarget:self
                                                         action:@selector(leftButtonAction:)];
}


- (UIImage *)navigationBarBackgroundImage {
    return [self navigationBarBackgroundImageForHomepage];
}

- (UIImage *)navigationBarBackgroundImageForHomepage {
    return [UIImage createImageWithColor:[UIColor blueColor]];
}

- (NSDictionary *)navigationBarTitleTextAttributes {
    return @{NSForegroundColorAttributeName : [CURRENT_SKIN navigationTitleColor],
             NSFontAttributeName: [CURRENT_SKIN navigationTitleFont]};
}

- (void)setTitle:(NSString *)title {
    if (title) {
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:[self navigationBarTitleTextAttributes]];
        NSAttributedString *newTitle = [attributedTitle newStringTruncateTo:SCREEN_WIDTH / 2.0 beforeIndex:title.length truncatedToken:@"..."];
        [super setTitle:newTitle.string];
    } else {
        [super setTitle:title];
    }
}

- (NSString *)backTitle {
    NSString *backTitle = nil;
    UIViewController *lastVC = [self lastVC];
    if ([lastVC isKindOfClass:[MTBaseViewController class]]) {
        backTitle = ((MTBaseViewController *)lastVC).backTitleForPeakViewController;
    }
    
    if (!backTitle) {
        if (lastVC.title) {
            backTitle = lastVC.title;
            if (backTitle) {
                NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:backTitle attributes:@{NSFontAttributeName : [CURRENT_SKIN navigationItemTitleFont]}];
                NSAttributedString *newTitle = [attributedTitle newStringTruncateTo:SCREEN_WIDTH / 4.0 beforeIndex:backTitle.length truncatedToken:@"..."];
                backTitle = newTitle.string;
            }
        } else {
            backTitle = XMLocalizedString(@"vc_back", @"返回");
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

#pragma mark - interface

- (void)showToast:(NSString *)toast {
    if (self.progressHUD) {
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
    }
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo: [UIApplication sharedApplication].delegate.window animated:YES];
    self.progressHUD.userInteractionEnabled = NO;
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.detailsLabelText = toast;
    self.progressHUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0f];
    [self.progressHUD hide:YES afterDelay:2.0f];
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
