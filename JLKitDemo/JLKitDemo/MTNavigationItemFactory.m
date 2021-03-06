//
//  MTNavigationItemFactory.m
//  MiTalk
//
//  Created by wangjianlong on 2018/3/13.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import "MTNavigationItemFactory.h"
#import "GlobalFunction.h"
//#import "UIImage+Tint.h"


typedef NS_ENUM(NSInteger, MTNavigationItemType) {
    MTNavigationItemTypeText,
    MTNavigationItemTypeImage,
    MTNavigationItemTypeBack,
};

MTNavigationItemAttributeKey const MTNavItemNormalTintColorKey          = @"MTNavItemNormalTintColorKey";
MTNavigationItemAttributeKey const MTNavItemHighlightedTintColorKey     = @"MTNavItemHighlightedTintColorKey";
MTNavigationItemAttributeKey const MTNavItemDisableTintColorKey         = @"MTNavItemDisableTintColorKey";
MTNavigationItemAttributeKey const MTNavItemTitleFontKey                = @"MTNavItemTitleFontKey";

MTNavigationItemStateTitleKey const MTNavItemStateHighlightedTitleKey = @"MTNavItemStateHighlightedTitleKey";
MTNavigationItemStateTitleKey const MTNavItemStateSelectTitleKey = @"MTNavItemStateSelectTitleKey";
MTNavigationItemStateTitleKey const MTNavItemStateDisableTitleKey = @"MTNavItemStateDisableTitleKey";

@implementation MTNavigationItemFactory

+ (NSArray<UIBarButtonItem *> *)createBarItemsWithTitle:(NSString *)title {
    return [self createBarItemsWithTitle:title touchUpInsideTarget:nil action:nil];
}

+ (NSArray<UIBarButtonItem *> *)createBarItemsWithTitle:(NSString *)title
                                    touchUpInsideTarget:(id)target
                                                 action:(SEL)action {
    return [self createBarItemsWithString:title type:MTNavigationItemTypeText touchUpInsideTarget:target action:action];
}

+ (NSArray<UIBarButtonItem *> *)createBarItemsWithTitle:(NSString *)title
                                   attributesDictionary:(NSDictionary *)attributesDictionary
                                    touchUpInsideTarget:(id)target
                                                 action:(SEL)action {
    return [self createBarItemsWithString:title
                                     type:MTNavigationItemTypeText
                     attributesDictionary:attributesDictionary
                      touchUpInsideTarget:target
                                   action:action];
}

+ (NSArray<UIBarButtonItem *> *)createBackIconBarItemsWithTouchUpInsideTarget:(id)target action:(SEL)action {
    return [self createBarItemsWithImageName:@"icon_common_nav_back_button_big" touchUpInsideTarget:target action:action];
}

+ (NSArray<UIBarButtonItem *> *)createBarItemsWithImageName:(NSString *)imageName {
    return [self createBarItemsWithImageName:imageName touchUpInsideTarget:nil action:nil];
}

+ (NSArray<UIBarButtonItem *> *)createBarItemsWithImageName:(NSString *)imageName
                                        touchUpInsideTarget:(id)target
                                                     action:(SEL)action {
    return [self createBarItemsWithString:imageName type:MTNavigationItemTypeImage touchUpInsideTarget:target action:action];
}

+ (NSArray<UIBarButtonItem *> *)createBarItemsWithImageName:(NSString *)imageName
                                       attributesDictionary:(NSDictionary *)attributesDictionary
                                        touchUpInsideTarget:(id)target
                                                     action:(SEL)action {
    return [self createBarItemsWithString:imageName
                                     type:MTNavigationItemTypeImage
                     attributesDictionary:attributesDictionary
                      touchUpInsideTarget:target
                                   action:action];
}

+ (NSArray<UIBarButtonItem *> *)createBackBarItemsWithTitle:(NSString *)title {
    return [self createBarItemsWithTitle:title touchUpInsideTarget:nil action:nil];
}

+ (NSArray<UIBarButtonItem *> *)createBackBarItemsWithTitle:(NSString *)title
                                        touchUpInsideTarget:(id)target
                                                     action:(SEL)action {
    return [self createBarItemsWithString:title type:MTNavigationItemTypeBack touchUpInsideTarget:target action:action];
}

+ (NSArray<UIBarButtonItem *> *)createBackBarItemsWithTitle:(NSString *)title
                                       attributesDictionary:(NSDictionary *)attributesDictionary
                                        touchUpInsideTarget:(id)target
                                                     action:(SEL)action {
    
    return [self createBarItemsWithString:title
                                     type:MTNavigationItemTypeBack
                     attributesDictionary:attributesDictionary
                      touchUpInsideTarget:target
                                   action:action];
}

+ (NSDictionary *)autoRepairAttributeKeyDictionary:(NSDictionary *)originalDic
{
    NSMutableDictionary *newDicTionary = [originalDic mutableCopy];
    if (![originalDic objectForKey:MTNavItemNormalTintColorKey]) {
        [newDicTionary setObject:[UIColor whiteColor] forKey:MTNavItemNormalTintColorKey];
    }
    if (![originalDic objectForKey:MTNavItemHighlightedTintColorKey]) {
        [newDicTionary setObject:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5]  forKey:MTNavItemHighlightedTintColorKey];
    }
    if (![originalDic objectForKey:MTNavItemDisableTintColorKey]) {
        [newDicTionary setObject:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forKey:MTNavItemDisableTintColorKey];
    }
    if (![originalDic objectForKey:MTNavItemTitleFontKey]) {
        [newDicTionary setObject:[UIFont systemFontOfSize:15] forKey:MTNavItemTitleFontKey];
    }
    
    return [newDicTionary copy];
}

+ (NSArray<UIBarButtonItem *> *)createBarItemsWithString:(NSString *)str
                                                    type:(MTNavigationItemType)type
                                     touchUpInsideTarget:(id)target
                                                  action:(SEL)action {
    NSDictionary *dict = [MTNavigationItemFactory autoRepairAttributeKeyDictionary:[NSDictionary dictionary]];
    return [self createBarItemsWithString:str
                                     type:type
                     attributesDictionary:dict
                      touchUpInsideTarget:target
                                   action:action];
}

+ (NSArray<UIBarButtonItem *> *)createBarItemsWithString:(NSString *)str
                                                    type:(MTNavigationItemType)type
                                    attributesDictionary:(NSDictionary *)attributesDictionary
                                     touchUpInsideTarget:(id)target
                                                  action:(SEL)action {
    if (String_is_invalide(str)) {
        return nil;
    }

    if (Dictionary_is_invalide(attributesDictionary)) {
        NSAssert(0, @"attributesDictionary is NULL!!");
    }

    if ((target != nil && action == nil) || (target == nil && action != nil)) {
        NSAssert(0, @"target and action SEL is NOT match!!");
    }
    attributesDictionary = [MTNavigationItemFactory autoRepairAttributeKeyDictionary:attributesDictionary];

    UIColor *normalTintColor = attributesDictionary[MTNavItemNormalTintColorKey];
    UIColor *highlightedTintColor = attributesDictionary[MTNavItemHighlightedTintColorKey];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (type == MTNavigationItemTypeText || type == MTNavigationItemTypeBack) {
        btn.titleLabel.font = attributesDictionary[MTNavItemTitleFontKey];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitle:attributesDictionary[MTNavItemStateHighlightedTitleKey] ?attributesDictionary[MTNavItemStateHighlightedTitleKey] :str  forState:UIControlStateHighlighted];
        [btn setTitle:attributesDictionary[MTNavItemStateSelectTitleKey] ?attributesDictionary[MTNavItemStateSelectTitleKey] :str  forState:UIControlStateSelected];
        [btn setTitle:attributesDictionary[MTNavItemStateDisableTitleKey] ?attributesDictionary[MTNavItemStateDisableTitleKey] :str  forState:UIControlStateDisabled];
        [btn setTitleColor:normalTintColor forState:UIControlStateNormal];
        [btn setTitleColor:highlightedTintColor forState:UIControlStateHighlighted];
        [btn sizeToFit];
    }

    if (type == MTNavigationItemTypeImage) {
        UIImage *normalImage = [UIImage imageNamed:str];
//                                tintedImageWithColor:normalTintColor];
        UIImage *highlightedImage = normalImage;
//        [[UIImage imageNamed:str] tintedImageWithColor:highlightedTintColor];
        [btn setImage:normalImage forState:UIControlStateNormal];
        [btn setImage:highlightedImage forState:UIControlStateHighlighted];
        [btn sizeToFit];
    }

    if (type == MTNavigationItemTypeBack) {
        UIImage *normalImage = [UIImage imageNamed:@"icon_common_nav_back_button"];
//    tintedImageWithColor:normalTintColor];
        UIImage *highlightedImage = normalImage;
//        [[UIImage imageNamed:@"icon_common_nav_back_button"] tintedImageWithColor:highlightedTintColor];
        [btn setImage:normalImage forState:UIControlStateNormal];
        [btn setImage:highlightedImage forState:UIControlStateHighlighted];

        CGFloat offset = 10;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, offset, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -offset, 0, 0);
        [btn sizeToFit];

        CGRect tmp = btn.bounds;
        btn.bounds = CGRectMake(0, 0, tmp.size.width + offset, tmp.size.height);
    }


    if (target != nil) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    [spacer setWidth:-1];
    return @[spacer, buttonItem];
    return nil;
}

@end

