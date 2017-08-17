//
//  JLSetCell.h
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingLabelItem.h"
#import "SettingSwitchItem.h"
#import "SettingArrowItem.h"
#import "SettingItem.h"
#import "OTPotocol.h"

extern NSString * const settingCell_ReuseIdentifer;

@interface SettingCell : UITableViewCell<OTCellProtocol>


@end
