//
//  JLBaseSetViewController.m
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "OTTableViewController.h"
#import "OTTableViewCore.h"


@interface OTTableViewController ()

@property(nonatomic,strong,readwrite)UITableView *tableView;
@property(nonatomic,strong) OTTableViewCore *tableViewCore;

@end


@implementation OTTableViewController

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _tableViewCore = [[OTTableViewCore alloc]init];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = _tableViewCore;
    tableView.delegate = _tableViewCore;
    _tableView = tableView;
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (NSMutableArray *)data
{
    return _tableViewCore.items;
}

@end
