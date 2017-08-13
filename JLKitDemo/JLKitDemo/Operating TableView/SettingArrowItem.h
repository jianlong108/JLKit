//
//  JLSetArrowItem.h
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "SettingItem.h"

@interface SettingArrowItem : SettingItem
/**
 *  点击这行cell需要跳转的控制器
 */
@property (nonatomic, assign) Class destVcClass;


+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;
@end
