//
//  JLBaseSetViewController.m
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "OTTableViewController.h"
#import "OTTableViewPivot.h"


@interface OTTableViewController ()

@property(nonatomic,strong,readwrite)UITableView *tableView;
@property(nonatomic,strong) OTTableViewPivot *tableViewCore;

@end


@implementation OTTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableViewCore = [[OTTableViewPivot alloc]init];
    
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (NSMutableArray *)data
{
    return _tableViewCore.sectionItems;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = _tableViewCore;
        _tableView.delegate = _tableViewCore;
    }
    return _tableView;
}

@end
