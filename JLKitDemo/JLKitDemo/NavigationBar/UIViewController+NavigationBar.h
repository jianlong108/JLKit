//
//  UIViewController+NavigationBar.h
//  MiTalk
//
//  Created by wangjianlong on 2018/3/13.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavgiationBarOfViewControllerProtocol.h"

@interface UIViewController (NavigationBar)<NavgiationBarOfViewControllerProtocol>

@property (nonatomic, assign) BOOL needUpdateNavigationBarWhenFullScreenPopFailed;



@end
