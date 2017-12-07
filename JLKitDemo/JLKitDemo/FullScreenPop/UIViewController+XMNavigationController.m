//
//  UIViewController+XMNavigationController.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "UIViewController+XMNavigationController.h"
#import "NSObject+AssociateObj.h"
#import "XMNavigationController.h"

@implementation UIViewController (XMNavigationController)

- (NSString *)identifier
{
    return [NSString stringWithFormat:@"identifier_%p_%lu", self,(unsigned long)[self hash]];
}

- (XMNavigationController *)myNavigationController
{
#if USEXMNavigationController == 0
    return self.navigationController;
#else
    XMNavigationController *navigationController =  [self.weakDictionary objectForKey:@"myNavigationController"];
    return  navigationController?navigationController:[self.parentViewController myNavigationController];
#endif
}


- (void)setMyNavigationController:(XMNavigationController * _Nullable)myNavigationController
{
    if (myNavigationController)
    {
        [self.weakDictionary setObject:myNavigationController
                                forKey:@"myNavigationController"];
    }
    else
    {
        [self.weakDictionary removeObjectForKey:@"myNavigationController"];
    }
}


- (XMNavigationViewAnimationType)pushAnimationType
{
    return (XMNavigationViewAnimationType)[[self.strongDictionary objectForKey:@"pushAnimationType"] integerValue];
}


- (void)setPushAnimationType:(XMNavigationViewAnimationType)pushAnimationType
{
    [self.strongDictionary setObject:[NSNumber numberWithInteger:pushAnimationType]
                              forKey:@"pushAnimationType"];
}


- (BOOL)isViewOnNavigationTopViewController
{
    XMNavigationController *nav = self.myNavigationController;
    if (!nav)
    {
        return NO;
    }
    
    UIViewController *topViewController = nav.topViewController;
    
    return ([self.view isDescendantOfView:topViewController.view]);
}

@end
