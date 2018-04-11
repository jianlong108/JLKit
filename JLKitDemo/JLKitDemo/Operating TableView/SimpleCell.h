//
//  JLSetCell.h
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleItem.h"
#import "OTProtocol.h"

extern NSString * const SimpleCell_ReuseIdentifer;


@interface SimpleCell : UITableViewCell<OTCellProtocol>

/**标题*/
@property (nonatomic, strong,readonly) UILabel *titleLabel;

@property (nonatomic, strong) id <SettingCellDataProtocol> dataModel;

@end
