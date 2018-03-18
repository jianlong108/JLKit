//
//  NavigationTranstionEngine.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/12.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Cloudox) <UINavigationBarDelegate, UINavigationControllerDelegate>


- (void)setNeedsNavigationBackground:(CGFloat)alpha;

@end
