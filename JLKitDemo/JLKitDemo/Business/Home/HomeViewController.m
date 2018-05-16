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
#import "SimpleItem.h"
#import "OTSectionModel.h"

#import "SimpleCell.h"
#import "BothsidesBtnViewController.h"
#import "TestTableViewController.h"
#import "TestDragCollecViewController.h"
#import "TestMenuViewController.h"
#import "TestIndexBarViewController.h"
#import "UIWebViewController.h"

#import "NSBundle+JL.h"

#import "CWStatusBarNotification.h"
#import "IOS11Adapter.h"
#import "MTScrollNavigationChildControllerProtocol.h"

@interface HomeViewController ()<MTScrollNavigationChildControllerProtocol>

@property (nonatomic, strong) CWStatusBarNotification *notification;
@property (nonatomic, strong) UIActivityViewController *activityVC;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // initialize CWNotification
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    self.notification = [CWStatusBarNotification new];
    
    // set default blue color (since iOS 7.1, default window tintColor is black)
    self.notification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [self.tableView registerClass:[SimpleCell class] forCellReuseIdentifier:SimpleCell_ReuseIdentifer];
    [self setUpModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setUpModel
{
    __weak typeof(self)weakSelf = self;
    OTSectionModel *sectionOne = [[OTSectionModel alloc]init];
    sectionOne.footerHeight = 7;
    sectionOne.headerHeight = 7;
    
    SimpleItem *model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        BothsidesBtnViewController *vc = [[BothsidesBtnViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"基础控件展示";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestTableViewController *vc = [[TestTableViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"可拖动tableview";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestMenuViewController *vc = [[TestMenuViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"菜单view";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestDragCollecViewController *vc = [[TestDragCollecViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"可拖动九宫格";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestIndexBarViewController *vc = [[TestIndexBarViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"indexbar";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        HomeFunctionViewController *home = [[HomeFunctionViewController alloc]init];
        [weakSelf customPresentViewController:home animated:YES completion:nil];
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"presentController_中部";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        
        NSString *pathResource = [[NSBundle mainBundle] pathForResource:@"one" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:pathResource];
        UIWebViewController *webVc = [[UIWebViewController alloc]initWithURL:url];
        [weakSelf.navigationController pushViewController:webVc animated:YES];
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"UIWebViewController";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        
        [self displayShare];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HomeViewController *home = [[HomeViewController alloc]init];
            [_activityVC presentViewController:home animated:YES completion:nil];
//            UIButton *customView = [UIButton buttonWithType:UIButtonTypeCustom];
//            customView.backgroundColor = [UIColor orangeColor];
//            [customView addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
//            [self.notification displayNotificationWithView:customView forDuration:3];
        });
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"UIActivityViewController";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"HomeViewController 被present";
    [sectionOne.items addObject:model];
    
    [self.sectionItems addObject:sectionOne];
}
- (void)tap
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HomeViewController *home = [[HomeViewController alloc]init];
        [self presentViewController:home animated:YES completion:nil];
    });
    
}
- (void)displayShare
{
    NSString *textToShare = @"请大家登录《iOS云端与网络通讯》服务网站";
    
    UIImage *imageToShare = [UIImage imageNamed:@"1"];
    
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.iosbook3.com"];
    
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    
    _activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                            
                                                                            applicationActivities:nil];
    
    //不出现在活动项目
    
    _activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                         
                                         UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    _activityVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:_activityVC animated:TRUE completion:nil];
    
}


- (CGFloat)contentViewHeight
{
    return 300;
}

- (UIScrollView *)contentScrollView
{
    return self.tableView;
}

- (void)setScrollViewContentInset:(UIEdgeInsets)inset
{
    self.tableView.contentInset = inset;
}

- (NSString *)titleForScrollTitleBar
{
    return @"控件";
}

@end
