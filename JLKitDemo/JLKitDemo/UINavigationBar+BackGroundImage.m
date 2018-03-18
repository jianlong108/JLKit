//
//  UINavigationBar+BackGroundImage.m
//  MiTalk
//
//  Created by wangjianlong on 2018/3/16.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import "UINavigationBar+BackGroundImage.h"
#import <objc/runtime.h>

@implementation UINavigationBar (BackGroundImage)

- (void)setMt_backGroundImageView:(UIImageView *)mt_backGroundImageView
{
     objc_setAssociatedObject(self, @selector(mt_backGroundImageView), mt_backGroundImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// NavigationBar背景图片
- (UIImageView *)mt_backGroundImageView
{
   return objc_getAssociatedObject(self, _cmd);
}

- (void)setMt_lineView:(UIImageView *)mt_lineView
{
    objc_setAssociatedObject(self, @selector(mt_lineView), mt_lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)mt_lineView
{
     return objc_getAssociatedObject(self, _cmd);
}
- (void)setNavigationbarAlpha:(CGFloat)alpha
{
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if (alpha > 1.0f) {
        alpha = 1.0f;
    }
    if (alpha < 0.0f) {
        alpha = 0.0f;
    }
    
    if (self.mt_backGroundImageView) {
        [self.mt_backGroundImageView setAlpha:alpha];
    }
}
- (void)setNavigationbarCustomBackgroundImage:(UIImage *)image
{
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if (!self.mt_backGroundImageView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        
        if (@available(iOS 11.0, *)) {
            UIView *view = self.subviews.firstObject;
            self.mt_backGroundImageView = [[UIImageView alloc] initWithFrame:view.bounds];
            self.mt_backGroundImageView.userInteractionEnabled = NO;
            self.mt_backGroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            
            self.mt_lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.mt_backGroundImageView.frame.size.height, [UIScreen mainScreen].bounds.size.width, 1)];
            self.mt_lineView.userInteractionEnabled = NO;
            self.mt_lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [self.mt_backGroundImageView addSubview:self.mt_lineView];
            
            [self.subviews.firstObject insertSubview:self.mt_backGroundImageView atIndex:0];
        }else{
            self.mt_backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
            self.mt_backGroundImageView.userInteractionEnabled = NO;
            self.mt_backGroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            
            self.mt_lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.mt_backGroundImageView.frame.size.height, [UIScreen mainScreen].bounds.size.width, 1)];
            self.mt_lineView.userInteractionEnabled = NO;
            self.mt_lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [self.mt_backGroundImageView addSubview:self.mt_lineView];
            
            [self insertSubview:self.mt_backGroundImageView atIndex:0];
        }
        
    }else {
//#warning 修复iPhone 5 导航栏被遮挡问题
        dispatch_async(dispatch_get_main_queue(), ^{
            if (@available(iOS 11.0, *)) {
                [self.subviews.firstObject insertSubview:self.mt_backGroundImageView atIndex:0];
            }else{
                [self insertSubview:self.mt_backGroundImageView atIndex:0];
            }
        });
        
    }
    
    [self.mt_backGroundImageView setImage:image];
}


@end
