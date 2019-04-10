//
//  XMNavigationController+Stack.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "XMNavigationController+Stack.h"
#import "UIViewController+XMNavigationController.h"

@interface UIViewController ()

@property (nonatomic,readonly,strong) NSString *identifier;

@property(nullable, nonatomic,strong) XMNavigationController *myNavigationController;

@end


@implementation XMNavigationController (Stack)

#if USE_XMNavigationController == 1

- (UIViewController *)topViewController
{
    
    int count = [self.viewControllers count];
    for (int i = count - 1;i >= 0; i--)
    {
        UIViewController *viewController = [self.viewControllers objectAtIndex:i];
        
        if (![self.willPopControllerIdentifierArray containsObject:viewController.identifier])
        {
            return viewController;
        }
    }
    
    return [self.viewControllers lastObject];
}

- (UIViewController *)belowViewController
{
    
    if (self.viewControllers.count < 2)
    {
        return nil;
    }
    return [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
}

- (void)addController:(UIViewController *)controller
{
    if (controller)
    {
        [self.viewControllers addObject:controller];
        
        if (controller.parentViewController != self)
        {
            [self addChildViewController:controller];
            
            // addChildViewController回调用[child willMoveToParentViewController:self] ，但是不会调用didMoveToParentViewController，所以需要显示调用
            
            [controller didMoveToParentViewController:self];
        }
        
    }
}

- (void)removeController:(UIViewController *)controller
{
    if (controller)
    {
        [self.viewControllers removeObject:controller];
        controller.myNavigationController = nil;
        
        // removeFromParentViewController在移除child前不会调用[self willMoveToParentViewController:nil] ，所以需要显示调用
        
        [controller willMoveToParentViewController:nil];
        [controller removeFromParentViewController];
        if (controller.isViewLoaded)
        {
            UIView *view = controller.view;
            view.userInteractionEnabled = NO;
            controller.view = nil;
            
            [view removeFromSuperview];
            controller.view = view;
            view.userInteractionEnabled = YES;
        }
    }
}


- (void)removeToController:(UIViewController *)controller
{
    NSArray *removeControllers = [self viewControllersAfterViewController:controller];
    for (UIViewController *viewController in removeControllers)
    {
        [self removeController:viewController];
    }
    
}


- (NSArray *)viewControllersAfterViewController:(UIViewController *)viewController;
{
    if (![self.viewControllers containsObject:viewController])
    {
        return nil;
    }
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    
    return [self.viewControllers subarrayWithRange:NSMakeRange(index+1, self.viewControllers.count-index-1)];
    
}

#else

- (UIViewController *)belowViewController
{
    NSLog(@"此属性仅限 XMNavigationController 正常使用的前提下");
    return nil;
}

- (void)removeController:(UIViewController *)controller
{
    NSLog(@"此方法仅限 XMNavigationController 正常使用的前提下");
}

- (NSArray *)viewControllersAfterViewController:(UIViewController *)viewController;
{
    return nil;
    NSLog(@"此属性仅限 XMNavigationController 正常使用的前提下");
}

- (UIViewController *)topViewController
{
    return [super topViewController];
}

- (void)addController:(UIViewController *)controller
{
    NSLog(@"此方法仅限 XMNavigationController 正常使用的前提下");
}

- (void)removeToController:(UIViewController *)controller
{
    NSLog(@"此方法仅限 XMNavigationController 正常使用的前提下");
}

#endif

@end
