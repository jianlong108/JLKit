//
//  UINavigationController+FullScreenPopGesture.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/13.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "UINavigationController+FullScreenPopGesture.h"
#import "NavigationTranstionEngine.h"
#import <objc/runtime.h>

@implementation UINavigationController (FullScreenPopGesture)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidLoad);
        
        SEL swizzledSelector = @selector(XM_FullScreenPopGesture_viewDidLoad);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)XM_FullScreenPopGesture_viewDidLoad
{
    [self XM_FullScreenPopGesture_viewDidLoad];
    
    NavigationTranstionEngine *transtionEngine = [[NavigationTranstionEngine alloc]initWithNavigationController:self];
    [self setNavigationEngine:transtionEngine];
}


#pragma mark - AssociateObject

- (NavigationTranstionEngine *)navigationEngine
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNavigationEngine:(NavigationTranstionEngine *)navigationEngine
{
    objc_setAssociatedObject(self, @selector(navigationEngine), navigationEngine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
