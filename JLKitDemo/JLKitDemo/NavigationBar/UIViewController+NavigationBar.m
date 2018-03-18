//
//  UIViewController+NavigationBar.m
//  MiTalk
//
//  Created by wangjianlong on 2018/3/13.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "MTNavigationItemFactory.h"
#import <objc/runtime.h>

#import "UINavigationController+Cloudox.h"
#include "UINavigationBar+BackGroundImage.h"

@implementation UIViewController (NavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        do {
            SEL originalSelector = @selector(viewDidLoad);
            SEL swizzledSelector = @selector(mt_viewDidLoad);
            
            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            
            BOOL didAddMethod =
            class_addMethod(class,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
            
            if (didAddMethod) {
                class_replaceMethod(class,
                                    swizzledSelector,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        } while (0);
        
        do {
            SEL originalSelector = @selector(viewWillAppear:);
            SEL swizzledSelector = @selector(mt_viewWillAppear:);
            
            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            
            BOOL didAddMethod =
            class_addMethod(class,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
            
            if (didAddMethod) {
                class_replaceMethod(class,
                                    swizzledSelector,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        } while (0);
        
        do {
            SEL originalSelector = @selector(viewWillDisappear:);
            SEL swizzledSelector = @selector(mt_viewWillDisappear:);
            
            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            
            BOOL didAddMethod =
            class_addMethod(class,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
            
            if (didAddMethod) {
                class_replaceMethod(class,
                                    swizzledSelector,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        } while (0);
    });
}

- (void)mt_viewDidLoad
{
    [self mt_viewDidLoad];
    
    [self setUpNavigationBarUI];
}

- (void)mt_viewWillAppear:(BOOL)animated
{
    
    NSLog(@"%@ %@",NSStringFromSelector(_cmd),self);
    [self mt_viewWillAppear:animated];
    if (self.needUpdateNavigationBarWhenFullScreenPopFailed) {
        [self updateNavigationBarIfNeed];
        self.needUpdateNavigationBarWhenFullScreenPopFailed = NO;
    }
    if ([self.navigationController.topViewController isEqual:self]) {
        [self.navigationController.navigationBar setNavigationbarCustomBackgroundImage:[self navigationBarBackgroundImage]];
        [self.navigationController setNeedsNavigationBackground:[self alphaOfNavigationBar]];
    }
    
}

- (void)mt_viewWillDisappear:(BOOL)animated
{
    [self mt_viewWillDisappear:animated];
    if ([self needUpdateNavigationBarWhenAttributeChange]) {
        [self.navigationController.topViewController setUpNavigationBarUI];
    }
}


- (void)updateNavigationBarIfNeed
{
    [self setUpNavigationBarUI];
}

- (void)setUpNavigationBarUI
{
    if ([self conformsToProtocol:@protocol(NavgiationBarOfViewControllerProtocol)]) {
        
        if ([self respondsToSelector:@selector(hidesBackButtonOfNavigationBar)]) {
            self.navigationItem.hidesBackButton = [self hidesBackButtonOfNavigationBar];
        }
        
        NSArray *leftItems = [self navigationBarLeftBarButtonItems];
        if (leftItems) {
            [self.navigationItem setLeftBarButtonItems:leftItems animated:NO];
        }
        
        NSArray *rightItems = [self navigationBarRightBarButtonItems];
        if (rightItems) {
            [self.navigationItem setRightBarButtonItems:rightItems animated:NO];
        }
        
        
        NSDictionary *titleTextAttributes = [self navigationBarTitleTextAttributes];
        if (titleTextAttributes) {
            [self.navigationController.navigationBar setTitleTextAttributes:titleTextAttributes];
        }
        
        UIImage *backgroundImage = [self navigationBarBackgroundImage];
        if (backgroundImage) {
            [self.navigationController.navigationBar setNavigationbarCustomBackgroundImage:backgroundImage];
        }
        
        UIImage *shadowImage = [self shadowImage];
        if (shadowImage) {
            [self.navigationController.navigationBar setShadowImage:shadowImage];
        }
        
        if ([self respondsToSelector:@selector(alphaOfNavigationBar)]) {
            [self.navigationController.navigationBar setNavigationbarAlpha:[self alphaOfNavigationBar]];
        }
        
    }
}


- (NSArray<UIBarButtonItem *> *)navigationBarRightBarButtonItems
{
    return nil;
}

- (UIImage *)navigationBarBackgroundImage {
    return nil;
}


- (UIImage *)shadowImage
{
    return nil;
}

- (NSDictionary *)navigationBarTitleTextAttributes {
    return nil;
}

- (NSArray<UIBarButtonItem *> *)navigationBarLeftBarButtonItems
{
    return nil;
}

- (CGFloat)alphaOfNavigationBar
{
    return 1.0;
}

- (BOOL)needUpdateNavigationBarWhenAttributeChange
{
    return NO;
}

#pragma mark - AssociateObject

- (BOOL)needUpdateNavigationBarWhenFullScreenPopFailed
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNeedUpdateNavigationBarWhenFullScreenPopFailed:(BOOL)needUpdateNavigationBarWhenFullScreenPopFailed
{
    objc_setAssociatedObject(self, @selector(needUpdateNavigationBarWhenFullScreenPopFailed), @(needUpdateNavigationBarWhenFullScreenPopFailed), OBJC_ASSOCIATION_ASSIGN);
}


@end
