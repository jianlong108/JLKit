//
//  JLSetSwitchItem.h
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "SettingItem.h"

@interface SettingSwitchItem : SettingItem
/**开关是否开启*/
@property (nonatomic, assign)  BOOL on;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title on:(BOOL)isOn;
@end
