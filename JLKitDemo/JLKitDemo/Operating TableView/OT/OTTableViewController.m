//
//  JLBaseSetViewController.m
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "OTTableViewController.h"


@interface OTTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong,readwrite)UITableView *tableView;

@end


@implementation OTTableViewController

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    _tableView = tableView;
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (NSArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<OTGroupItemProtocol> group = self.data[section];
    return [[group itemsOfGroup] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<OTGroupItemProtocol> group = self.data[indexPath.section];
    
    id<OTItemProtocol> item = [group itemsOfGroup][indexPath.row];
    
    UITableViewCell<OTCellProtocol> *cell;
    
//    if ([item respondsToSelector:@selector(reuseableIdentierOfCell)]) {
        NSString *identifer = [item reuseableIdentierOfCell];
        cell = [tableView dequeueReusableCellWithIdentifier:identifer];
//    }else{
//        cell = [tableView dequeueReusableCellWithIdentifier:defaultReuseIdentifer];
//    }
    
    [cell setUpItem:[group itemsOfGroup][indexPath.row]];
    
    // 3.返回cell
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     id<OTGroupItemProtocol> group = self.data[section];
    return [group heightOfGroupHeader];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    id<OTGroupItemProtocol> group = self.data[section];
    return [group heightOfGroupFooter];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    id<OTGroupItemProtocol> group = self.data[indexPath.section];
    id <OTItemProtocol> item = [group itemsOfGroup][indexPath.row];
    
    if ([item doSomeThingOfClickCell]) { // block有值(点击这个cell,.有特定的操作需要执行)
        [item doSomeThingOfClickCell](indexPath);
    } 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<OTGroupItemProtocol> group = self.data[indexPath.section];
    
    id<OTItemProtocol> item = [group itemsOfGroup][indexPath.row];
    return [item heightOfCell];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<OTGroupItemProtocol> group = self.data[section];
    return [group headerOfGroup];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    id<OTGroupItemProtocol> group = self.data[section];
    return [group footerOfGroup];
}
@end
