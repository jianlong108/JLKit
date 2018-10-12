//
//  HomeFunctionViewController.h
//  JLKitDemo
//
//  Created by wangjianlong on 2018/4/2.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPresentViewControllerProtocol.h"
#import "JLScrollNavigationChildControllerProtocol.h"
#import "OTTableViewController.h"

@interface HomeFunctionViewController : OTTableViewController<
    CustomPresentViewControllerProtocol,
    JLScrollNavigationChildControllerProtocol
>

@end
