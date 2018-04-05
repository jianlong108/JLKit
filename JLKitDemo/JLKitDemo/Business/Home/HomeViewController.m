//
//  ViewController.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+PresentController.h"
#import "HomeFunctionViewController.h"
#import "SimpleModel.h"
#import "OTSectionModel.h"

#import "SimpleCell.h"
#import "BothsidesBtnViewController.h"
#import "TestTableViewController.h"
#import "TestDragCollecViewController.h"
#import "TestMenuViewController.h"
#import "TestIndexBarViewController.h"
#import "UIWebViewController.h"

#import "NSBundle+JL.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[SimpleCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    [self setUpModel];
}

- (void)setUpModel
{
    __weak typeof(self)weakSelf = self;
    OTSectionModel *sectionOne = [[OTSectionModel alloc]init];
    sectionOne.footerHeight = 7;
    sectionOne.headerHeight = 7;
    SimpleModel *model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        BothsidesBtnViewController *vc = [[BothsidesBtnViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"基础控件展示";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestTableViewController *vc = [[TestTableViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"可拖动tableview";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestMenuViewController *vc = [[TestMenuViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"菜单view";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestDragCollecViewController *vc = [[TestDragCollecViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"可拖动九宫格";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestIndexBarViewController *vc = [[TestIndexBarViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"indexbar";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        HomeFunctionViewController *home = [[HomeFunctionViewController alloc]init];
        [weakSelf customPresentViewController:home animated:YES completion:nil];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"presentController_中部";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *docDir = [paths objectAtIndex:0];
        NSMutableString *str_m = [NSMutableString stringWithString:docDir];
        
//        NSURL *url = [NSURL fileURLWithPath:[str_m stringByAppendingPathComponent:@"one.html"]];
//        NSURL *url = [NSURL fileURLWithPath:@"/Users/dalong/Desktop/one.html"];
        NSString *pathResource = [[NSBundle mainBundle] pathForResource:@"one" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:pathResource];
        UIWebViewController *webVc = [[UIWebViewController alloc]initWithURL:url];
        [weakSelf.navigationController pushViewController:webVc animated:YES];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"UIWebViewController";
    [sectionOne.items addObject:model];
    
    [self.data addObject:sectionOne];
}



- (CGFloat)contentViewHeight
{
    return 300;
}

@end
