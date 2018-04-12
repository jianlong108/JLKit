//
//  ViewController.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPresentViewControllerProtocol.h"
#import "OTTableViewController.h"
#import "MTScrollNavigationChildControllerProtocol.h"

@interface HomeViewController : OTTableViewController<
    CustomPresentViewControllerProtocol,
    MTScrollNavigationChildControllerProtocol
>


@end

