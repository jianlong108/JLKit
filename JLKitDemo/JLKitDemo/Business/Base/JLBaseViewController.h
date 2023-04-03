//
//  JLBaseViewController.h
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/11.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLNavigationController.h"
#import "NavgiationBarOfViewControllerProtocol.h"


/**
 默认遵守并实现了NavgiationBarOfViewControllerProtocol 实现了对Navigationbar的UI默认定制
 
 对电池条(statusbar) 和横竖屏的支持,提供了默认的定制
 
 */
@interface JLBaseViewController : UIViewController<NavgiationBarOfViewControllerProtocol>

/**
 以下方法子类可以实现自身对navigationBar的定制

 */
- (NSString *)backTitle;
- (NSString *)backTitleForPeakViewController; // 自己本身的页面title不适合作为backTitle时使用
- (NSDictionary *)navigationBarTitleTextAttributes;
- (UIImage *)navigationBarBackgroundImage;
- (NSArray<UIBarButtonItem *> *)navigationBarLeftBarButtonItems;
- (NSArray<UIBarButtonItem *> *)navigationBarRightBarButtonItems;


- (void)leftButtonAction:(id)sender;

@end
