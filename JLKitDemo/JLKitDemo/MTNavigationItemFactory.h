//
//  MTNavigationItemFactory.h
//  MiTalk
//
//  Created by wangjianlong on 2018/3/13.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString *MTNavigationItemAttributeKey;
FOUNDATION_EXPORT MTNavigationItemAttributeKey const MTNavItemNormalTintColorKey;
FOUNDATION_EXPORT MTNavigationItemAttributeKey const MTNavItemHighlightedTintColorKey;
FOUNDATION_EXPORT MTNavigationItemAttributeKey const MTNavItemDisableTintColorKey;
FOUNDATION_EXPORT MTNavigationItemAttributeKey const MTNavItemTitleFontKey;

typedef NSString *MTNavigationItemStateTitleKey;
FOUNDATION_EXPORT MTNavigationItemStateTitleKey const MTNavItemStateHighlightedTitleKey;
FOUNDATION_EXPORT MTNavigationItemStateTitleKey const MTNavItemStateSelectTitleKey;
FOUNDATION_EXPORT MTNavigationItemStateTitleKey const MTNavItemStateDisableTitleKey;

@interface MTNavigationItemFactory : NSObject
//TODO: disabled态暂未开发，待补充！！

//纯文字
+ (NSArray<UIBarButtonItem *> *)createBarItemsWithTitle:(NSString *)title;
+ (NSArray<UIBarButtonItem *> *)createBarItemsWithTitle:(NSString *)title
                                    touchUpInsideTarget:(id)target
                                                 action:(SEL)action;
+ (NSArray<UIBarButtonItem *> *)createBarItemsWithTitle:(NSString *)title
                                   attributesDictionary:(NSDictionary *)attributesDictionary
                                    touchUpInsideTarget:(id)target
                                                 action:(SEL)action;

//纯图标
+ (NSArray<UIBarButtonItem *> *)createBackIconBarItemsWithTouchUpInsideTarget:(id)target
                                                                       action:(SEL)action;
+ (NSArray<UIBarButtonItem *> *)createBarItemsWithImageName:(NSString *)imageName;
+ (NSArray<UIBarButtonItem *> *)createBarItemsWithImageName:(NSString *)imageName
                                        touchUpInsideTarget:(id)target
                                                     action:(SEL)action;
+ (NSArray<UIBarButtonItem *> *)createBarItemsWithImageName:(NSString *)imageName
                                       attributesDictionary:(NSDictionary *)attributesDictionary
                                        touchUpInsideTarget:(id)target
                                                     action:(SEL)action;

//返回
+ (NSArray<UIBarButtonItem *> *)createBackBarItemsWithTitle:(NSString *)title;
+ (NSArray<UIBarButtonItem *> *)createBackBarItemsWithTitle:(NSString *)title
                                        touchUpInsideTarget:(id)target
                                                     action:(SEL)action;
+ (NSArray<UIBarButtonItem *> *)createBackBarItemsWithTitle:(NSString *)title
                                       attributesDictionary:(NSDictionary *)attributesDictionary
                                        touchUpInsideTarget:(id)target
                                                     action:(SEL)action;

@end

