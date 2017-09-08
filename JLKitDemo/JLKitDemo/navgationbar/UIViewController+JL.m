//
//  UIViewController+MT.m
//  MiTalk
//
//  Created by wangjianlong on 2017/8/30.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "UIViewController+JL.h"
#import "UINavigationController+JL.h"
#import <objc/runtime.h>

@implementation UIViewController (JL)

static char *navgationBarAlphaKey = "navgationBarAlphaKey";

- (void)setNavBarBgAlpha:(CGFloat)navBarBgAlpha {
   
    objc_setAssociatedObject(self, navgationBarAlphaKey, @(navBarBgAlpha), OBJC_ASSOCIATION_ASSIGN);
    
    // 设置导航栏透明度（利用Category自己添加的方法）
    [self.navigationController setNeedsNavigationBackground:navBarBgAlpha];
}

- (CGFloat)navBarBgAlpha {
    id alphavalue = objc_getAssociatedObject(self, navgationBarAlphaKey);
    return alphavalue  ? [alphavalue floatValue] : 1.0;
}
@end
