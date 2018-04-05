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
#import "Test_MenuViewController.h"
#import "TestIndexBarViewController.h"
#import "UIWebViewController.h"


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
    OTSectionModel *sectionOne = [[OTSectionModel alloc]init];
    sectionOne.footerHeight = 7;
    sectionOne.headerHeight = 7;
    SimpleModel *model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        BothsidesBtnViewController *vc = [[BothsidesBtnViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"基础控件展示";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestTableViewController *vc = [[TestTableViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"可拖动tableview";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        Test_MenuViewController *vc = [[Test_MenuViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"可拖动九宫格";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestDragCollecViewController *vc = [[TestDragCollecViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"菜单view";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestIndexBarViewController *vc = [[TestIndexBarViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"indexbar";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        HomeFunctionViewController *home = [[HomeFunctionViewController alloc]init];
        [self customPresentViewController:home animated:YES completion:nil];
    };
    model.reuseableIdentierOfCell = NSStringFromClass([self class]);
    model.title = @"presentController_中部";
    [sectionOne.items addObject:model];
    
    model = [[SimpleModel alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *docDir = [paths objectAtIndex:0];
        NSMutableString *str_m = [NSMutableString stringWithString:docDir];
        
        NSURL *url = [NSURL fileURLWithPath:[str_m stringByAppendingPathComponent:@"one.html"]];
//        NSURL *url = [NSURL fileURLWithPath:@"/Users/dalong/Desktop/one.html"];
        UIWebViewController *webVc = [[UIWebViewController alloc]initWithURL:url];
        [self.navigationController pushViewController:webVc animated:YES];
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
