//
//  TestTableViewController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/1/13.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "TestTableViewController.h"
#import "JLTableView.h"

@interface TestTableViewController ()<JLTableViewDelegate,UITableViewDataSource>

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JLTableView *tableview = [[JLTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
}

#pragma mark - tableview -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testttt"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testttt"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld",indexPath.section,indexPath.row];
    return cell;
}

- (void)JLTableView:(JLTableView *)tableView SwitchFromIndex:(NSUInteger)fromeIndex ToIndex:(NSUInteger)toIndex{
    NSLog(@"FROM -- INDEX %ld  TO  INDEX  %ld",fromeIndex,toIndex);
}



@end
