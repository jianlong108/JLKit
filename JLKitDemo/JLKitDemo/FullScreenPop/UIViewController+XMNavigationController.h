//
//  UIViewController+XMNavigationController.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMNavigationGlobalDefines.h"


@class XMNavigationController;

@interface UIViewController (XMNavigationController)

/**
 *  @brief 控制器唯一标示
 */
@property (nullable,nonatomic,readonly,strong) NSString *identifier;

/**
 *  @brief AHNavigationController
 */
@property(nullable, nonatomic,readonly,strong) XMNavigationController *myNavigationController;


/**
 *  @brief push时的动画类型
 */
@property(nonatomic,assign) XMNavigationViewAnimationType pushAnimationType;



@property(nonatomic,readonly) BOOL isViewOnNavigationTopViewController;

@end
