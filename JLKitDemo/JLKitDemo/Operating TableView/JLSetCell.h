//
//  JLSetCell.h
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLSetLabelItem.h"
#import "JLSetSwitchItem.h"
#import "JLSetArrowItem.h"
#import "JLSetItem.h"
#import "OTPotocol.h"

@interface JLSetCell : UITableViewCell<OTCellProtocol>

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
