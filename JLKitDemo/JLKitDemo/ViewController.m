//
//  ViewController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "ViewController.h"
#import "SettingViewController.h"

@interface ViewController ()
/**数据*/
@property (nonatomic, strong)NSMutableArray *datas;
@end

@implementation ViewController
- (NSMutableArray *)datas{
    if (_datas==nil) {
        _datas = [NSMutableArray arrayWithObjects:
                  @{@"name":@"双面button",@"vc":@"BothsidesBtnViewController"},
                  @{@"name":@"可拖动tableview",@"vc":@"TestTableViewController"},
                  @{@"name":@"可拖动九宫格",@"vc":@"TestDragCollecViewController"},
                  @{@"name":@"菜单view",@"vc":@"BothsidesBtnViewController"},
                  @{@"name":@"简易tableview使用--设置界面",@"vc":@"SettingViewController"}, nil];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jlkit"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jlkit"];
    }
    NSDictionary *dic = self.datas[indexPath.row];
    cell.textLabel.text =dic[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.datas[indexPath.row];
    
    NSString * vcClassName = dic[@"vc"];
    UIViewController *vc = [[NSClassFromString(vcClassName) alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
