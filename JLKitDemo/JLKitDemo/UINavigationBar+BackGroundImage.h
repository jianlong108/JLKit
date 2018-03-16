//
//  UINavigationBar+BackGroundImage.h
//  MiTalk
//
//  Created by wangjianlong on 2018/3/16.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BackGroundImage)


/**
 底部线
 */
@property (nonatomic, strong) UIImageView *mt_lineView;

/**背景图*/
@property (nonatomic, strong) UIImageView *mt_backGroundImageView;


- (void)setNavigationbarCustomBackgroundImage:(UIImage *)image;

- (void)setNavigationbarAlpha:(CGFloat)alpha;
/// 恢复默认设置
//- (void)mt_reSet;

@end
