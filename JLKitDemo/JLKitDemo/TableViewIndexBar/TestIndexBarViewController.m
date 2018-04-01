//
//  TestIndexBarViewController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/1.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "TestIndexBarViewController.h"
#import "UITableView+IndexBar.h"

@interface TestIndexBarViewController ()<
    UITableViewDelegate,
    UITableViewDataSource
>
@property(nonatomic,strong) NSArray *datas;
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation TestIndexBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView addCustomSectionTitles:@[@"火",@"a",@"b",@"h",@"j",@"z"]];
    [self.tableView showTitlesContentView];
}
- (NSArray *)datas{
    if (_datas == nil) {
        _datas = @[@[@"火",@"火",@"火",@"火",@"火",@"火"],
                   @[@"a",@"a",@"a",@"a",@"a",@"a"],
                   @[@"b",@"b",@"b",@"b",@"b",@"b"],
                   @[@"h",@"h",@"h",@"h",@"h",@"h"],
                   @[@"j",@"j",@"j",@"j",@"j",@"j"],
                   @[@"z",@"z",@"z",@"z",@"z",@"z"],
                   ];
        
    }
    return _datas;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datas[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [self.datas[indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = str;
    return cell;
}
@end
