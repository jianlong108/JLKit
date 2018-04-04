//
//  UIViewController+NavigationBar.h
//  MiTalk
//
//  Created by wangjianlong on 2018/3/13.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)

@property (nonatomic, assign) BOOL needUpdateNavigationBarWhenFullScreenPopFailed;



/**
如果想要实现navigationBar背景透明,返回0

 @return 背景透明度
 */
- (CGFloat)alphaOfNavigationBar;

/**
 返回中心标题栏的字体属性.主要为以下两个特性:
 NSForegroundColorAttributeName;NSFontAttributeName
 
 @return attritbute
 */
- (NSDictionary *)navigationBarTitleTextAttributes;

/**
 返回标题栏的背景图片
 
 @return 背景图片
 */
- (UIImage *)navigationBarBackgroundImage;

/*
 *若实现了下面这两个方法，每次更新navigationbar UI的都会被触发。
 *若navigationbar左右两侧的barItem不会根据交互行为产生变化的，请不要实现这两个方法，以便提高效率。
 */
- (NSArray<UIBarButtonItem *> *)navigationBarLeftBarButtonItems;
- (NSArray<UIBarButtonItem *> *)navigationBarRightBarButtonItems;


/**
 navigationBar 返回标题
 返回 nil.或者 @"" 代表不显示leftBarButtonItems
 @return 返回标题
 */
- (NSString *)backTitle;

/**
 自己本身的页面title不适合作为backTitle时使用
 
 @return 返回标题
 */
- (NSString *)backTitleForPeakViewController;


/**
 隐藏navigationBar上的返回按钮.只保留leftBaritem

 @return 默认YES
 */
- (BOOL)hidesBackButtonOfNavigationBar;


/**
 当自身页面对应的navigationBar的backgroundImage font color等属性 与主题属性不一致时,需要将此属性置为YES.便于及时刷新
 */
- (BOOL)needUpdateNavigationBarWhenAttributeChange;

/**
 在全屏滑动返回 中途 取消时,需要调用此方法,重新设置NavigationBar
 */
- (void)updateNavigationBarIfNeed;

@end
