//
//  PrincipleViewController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2019/3/4.
//  Copyright © 2019 JL. All rights reserved.
//

#import "PrincipleViewController.h"
#import "SimpleCell.h"
#import "SimpleCellItem.h"

@interface PrincipleViewController ()

@end

@implementation PrincipleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[SimpleCell class] forCellReuseIdentifier:[SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel]];
    
    OTSectionModel *section = [[OTSectionModel alloc]init];
    SimpleCellItem *item = [[SimpleCellItem alloc]init];
    item.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    item.title = @"消息转发";
    item.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        UIViewController *vc = [[NSClassFromString(@"MethodForwardVC") alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section.items addObject:item];
    
    item = [[SimpleCellItem alloc]init];
    item.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    item.title = @"class解惑";
    item.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        UIViewController *vc = [[NSClassFromString(@"ClassLayoutVC") alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section.items addObject:item];
    
    item = [[SimpleCellItem alloc]init];
    item.title = @"自己实现KVO";
    item.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    item.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        UIViewController *vc = [[NSClassFromString(@"CustomKVOVC") alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section.items addObject:item];
    
    [self.sectionItems addObject:section];
    
    [self.tableView reloadData];
}

@end
