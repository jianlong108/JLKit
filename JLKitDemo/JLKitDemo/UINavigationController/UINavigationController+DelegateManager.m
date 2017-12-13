//
//  UINavigationController+DelegateContainer.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/12/13.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "UINavigationController+DelegateManager.h"
#import <objc/runtime.h>

static NSString *const KDelegatObject = @"UINavigationController+DelegateManager+DelegatObject";
static NSString *const KDelegatQueue = @"UINavigationController+DelegateManager+DelegatQueue";

@interface UINavigationController ()

- (NSMutableArray *)delegateContainer;

@end



@implementation _UINavigationControllerDelegateManager

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSMutableArray *delegateSet = navigationController.delegateContainer;
    [delegateSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<UINavigationControllerDelegate> delegate = [obj objectForKey:KDelegatObject];
        dispatch_queue_t queue = [obj objectForKey:KDelegatQueue];
        
        dispatch_async(queue, ^{
            [delegate navigationController:navigationController willShowViewController:viewController animated:animated];
        });
    }];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSMutableArray *delegateSet = navigationController.delegateContainer;
    [delegateSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<UINavigationControllerDelegate> delegate = [obj objectForKey:KDelegatObject];
        dispatch_queue_t queue = [obj objectForKey:KDelegatQueue];
        
        dispatch_async(queue, ^{
            [delegate navigationController:navigationController didShowViewController:viewController animated:animated];
        });
    }];
    
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED
{
    NSMutableArray *delegateSet = navigationController.delegateContainer;
    NSMapTable *obj = [delegateSet lastObject];
    id<UINavigationControllerDelegate> delegate = [obj objectForKey:KDelegatObject];
    if ([delegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]){
        return [delegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED
{
    NSMutableArray *delegateSet = navigationController.delegateContainer;
    NSMapTable *obj = [delegateSet lastObject];
    id<UINavigationControllerDelegate> delegate = [obj objectForKey:KDelegatObject];
    if ([delegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]){
        return [delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }else{
        return UIInterfaceOrientationUnknown;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0)
{
    NSMutableArray *delegateSet = navigationController.delegateContainer;
    NSMapTable *obj = [delegateSet lastObject];
    id<UINavigationControllerDelegate> delegate = [obj objectForKey:KDelegatObject];
    if ([delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]){
        return [delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }else{
        return nil;
    }
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    NSMutableArray *delegateSet = navigationController.delegateContainer;
    NSMapTable *obj = [delegateSet lastObject];
    id<UINavigationControllerDelegate> delegate = [obj objectForKey:KDelegatObject];
    if ([delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]){
        return [delegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    }else{
        return nil;
    }
}

@end

@implementation UINavigationController (DelegateManager)

#pragma mark - Interface

- (void)addDelegate:(id<UINavigationControllerDelegate>)delegate queue:(dispatch_queue_t )queue
{
    NSMutableArray *delegateSet = [self delegateContainer];
    if (delegateSet == nil) {
        delegateSet = [NSMutableArray array];
        [self setDelegateContainer:delegateSet];
    }
    if (delegate) {
        NSMapTable *map = [NSMapTable strongToWeakObjectsMapTable];
        [map setObject:delegate forKey:KDelegatObject];
        if (queue == nil) {
            queue = dispatch_get_main_queue();
        }
        [map setObject:queue forKey:KDelegatQueue];
        [delegateSet addObject:map];
    }
    
}

- (void)removeDelegate:(id<UINavigationControllerDelegate>)delegate queue:(dispatch_queue_t)queue
{
    NSMutableArray *delegateSet = [self delegateContainer];
    if (delegateSet == nil) {
        return;
    }
    
    __block NSMapTable *willDeleteObj;
    [delegateSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj objectForKey:KDelegatObject] isEqual:delegate]) {
            willDeleteObj = obj;
            *stop = YES;
        }
    }];
    if (willDeleteObj) {
        [delegateSet removeObject:willDeleteObj];
    }
}

#pragma mark - AssociatedObject

- (void)setDelegateContainer:(NSMutableArray *)delegateContainer {
    objc_setAssociatedObject(self, @selector(delegateContainer), delegateContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)delegateContainer {
    return objc_getAssociatedObject(self, @selector(delegateContainer));
}

- (void)setDelegateManager:(_UINavigationControllerDelegateManager *)delegateManager {
    objc_setAssociatedObject(self, @selector(delegateContainer), delegateManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (_UINavigationControllerDelegateManager *)delegateManager {
    return objc_getAssociatedObject(self, @selector(delegateManager));
}

@end
