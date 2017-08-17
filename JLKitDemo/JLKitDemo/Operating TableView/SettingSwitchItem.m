//
//  JLSetSwitchItem.m
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "SettingSwitchItem.h"

@implementation SettingSwitchItem
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title on:(BOOL)isOn{
    SettingSwitchItem *item = [super itemWithIcon:icon title:title];
    item.on = isOn;
    return item;
}
- (BOOL)switchStateOfCell{
    return self.on;
}
@end
