//
//  UINavigationController+FullScreenPopGesture.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/13.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NavigationTranstionEngine;

@interface UINavigationController (FullScreenPopGesture)

- (NavigationTranstionEngine *)navigationEngine;

@end
