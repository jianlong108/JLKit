//
//  JLBaseSetViewController.h
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLBaseViewController.h"
#import "OTProtocol.h"

@interface OTTableViewController : JLBaseViewController

@property(nonatomic,strong) NSMutableArray<id <OTSectionItemProtocol>> *data;

@property(nonatomic,strong,readonly)UITableView *tableView;


@end
