//
//  TestTableViewController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/1/13.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "TestTableViewController.h"
#import "JLTableView.h"
#import "BLNewMusicListTableViewCell.h"

@interface TestTableViewController ()<
JLTableViewDelegate,
UITableViewDataSource,
BLNewMusicListTableViewCellDelegate
>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) BLNewMusicListTableViewCellModel *lastCellModel;
@property (nonatomic, strong) BLNewMusicListTableViewCell *lastCell;

@property (nonatomic, strong) NSArray *models;
@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _models = @[[BLNewMusicListTableViewCellModel new],[BLNewMusicListTableViewCellModel new],[BLNewMusicListTableViewCellModel new],[BLNewMusicListTableViewCellModel new],[BLNewMusicListTableViewCellModel new]];
    // Do any additional setup after loading the view.
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableview registerClass:BLNewMusicListTableViewCell.class forCellReuseIdentifier:NSStringFromClass(BLNewMusicListTableViewCell.class)];
    tableview.rowHeight = 75;
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableview = tableview;
    [self.view addSubview:tableview];
}

#pragma mark - tableview -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BLNewMusicListTableViewCellModel *model = self.models[indexPath.row];
    BLNewMusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(BLNewMusicListTableViewCell.class)];
    cell.delegate = self;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)JLTableView:(JLTableView *)tableView SwitchFromIndex:(NSUInteger)fromeIndex ToIndex:(NSUInteger)toIndex{
    NSLog(@"FROM -- INDEX %ld  TO  INDEX  %ld",fromeIndex,toIndex);
}

- (void)newMusicListCellDidClickPlayButton:(BLNewMusicListTableViewCell *)cell model:(BLNewMusicListTableViewCellModel *)model
{
//    BLNewMusicListTableViewCellModel *model = cell.model;
    model.cellIsPlaying = !model.cellIsPlaying;
    NSMutableArray *arr = [NSMutableArray array];
    if (self.lastCellModel) {
        self.lastCellModel.cellIsPlaying = !self.lastCellModel.cellIsPlaying;

        NSInteger idx = [self.models indexOfObject:self.lastCellModel];
        [arr addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }
    self.lastCellModel = model;
    NSInteger idx = [self.models indexOfObject:model];
    [arr addObject:[NSIndexPath indexPathForRow:idx inSection:0]];

    [self.tableview reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];

    //设置动画执行时间
//    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:0.3];
//        [CATransaction setCompletionBlock:^{
//            [self.tableview reloadData];
//        }];
//        self.lastCell.isPlaying = !self.lastCell.isPlaying;
//        cell.isPlaying = !cell.isPlaying;
//
//        self.lastCell = cell;
//        [CATransaction commit];
//    }completion:^(BOOL finished) {
//
//    }];
}


- (void)cellAnimationAfterReloadData:(BOOL)cellIsPlay {
    [CATransaction begin];

    [CATransaction setCompletionBlock:^{

    }];
    [self.tableview reloadData];
    [CATransaction commit];
}

@end
