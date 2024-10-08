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
#import "SimpleCellItem.h"
#import "OTSectionModel.h"

#import "SimpleCell.h"
#import "BothsidesBtnViewController.h"
#import "TestTableViewController.h"
#import "TestDragCollecViewController.h"
#import "TestMenuViewController.h"
#import "TestIndexBarViewController.h"
#import "UIWebViewController.h"

#import "NSBundle+JL.h"
#import "WeatherTableViewCell.h"

#import "CWStatusBarNotification.h"
#import "JLScrollNavigationChildControllerProtocol.h"
#import "WeatherModel.h"
#import "AFNetworking.h"
#import "MasonryDemoViewController.h"
#import "CollectionLayoutDemoViewController.h"
#import "ContainerDemoViewController.h"


#import "OpenGLOneViewController.h"
#import "OpenGLTwoViewController.h"
#import "OpenGLMultitextureViewController.h"
#import "OpenGLTextureDynamicViewController.h"
#import "OpenGL1ViewController.h"
#import "OpenGL2ViewController.h"
#import "JLKitDemo-Swift.h"

@interface HomeViewController ()<JLScrollNavigationChildControllerProtocol>

@property (nonatomic, strong) CWStatusBarNotification *notification;
@property (nonatomic, strong) UIActivityViewController *activityVC;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // initialize CWNotification
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.notification = [CWStatusBarNotification new];
//    self.tableView.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 0, 0, 0);
    // set default blue color (since iOS 7.1, default window tintColor is black)
    self.notification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [self.tableView registerClass:[SimpleCell class] forCellReuseIdentifier:[SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel]];
    [self.tableView registerClass:[WeatherTableViewCell class] forCellReuseIdentifier:WeatherTableViewCell_ReuseIdentifer];
    [self setUpModel];
    
//    [self requesetData];
}

- (void)requesetData
{
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    [session GET:@"https://www.sojson.com/open/api/weather/json.shtml" parameters:@{@"city":@"北京"} progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
}

- (void)setUpModel
{
    __weak typeof(self)weakSelf = self;
    OTSectionModel *sectionOne = [[OTSectionModel alloc]init];
    sectionOne.footerHeight = 7;
    sectionOne.headerHeight = 7;
    
    SimpleCellItem *model;
    
//    model = [[WeatherModel alloc]init];
//    model.reuseableIdentierOfCell = WeatherTableViewCell_ReuseIdentifer;
//    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        JLBlurViewController *vc = [[JLBlurViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"毛玻璃(不触发离屏渲染)";
    [sectionOne.items addObject:model];


    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        JLSwiftAsyncViewController *vc = [[JLSwiftAsyncViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"Swift异步处理";
    [sectionOne.items addObject:model];

    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        MasonryDemoViewController *vc = [[MasonryDemoViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"Masonry相关";
    [sectionOne.items addObject:model];

    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        CollectionLayoutDemoViewController *vc = [[CollectionLayoutDemoViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"collectionviewLayou展示";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        ContainerDemoViewController *vc = [[ContainerDemoViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"容器VC展示";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        BothsidesBtnViewController *vc = [[BothsidesBtnViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"基础控件展示";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestTableViewController *vc = [[TestTableViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"可拖动tableview";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestMenuViewController *vc = [[TestMenuViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"菜单view";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestDragCollecViewController *vc = [[TestDragCollecViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"可拖动九宫格";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        TestIndexBarViewController *vc = [[TestIndexBarViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"indexbar";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        HomeFunctionViewController *home = [[HomeFunctionViewController alloc]init];
        [weakSelf customPresentViewController:home animated:YES completion:nil];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"presentController_中部";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        
        NSString *pathResource = [[NSBundle mainBundle] pathForResource:@"one" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:pathResource];
        UIWebViewController *webVc = [[UIWebViewController alloc]initWithURL:url];
        [weakSelf.navigationController pushViewController:webVc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"UIWebViewController";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        
//        [self displayShare];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            HomeViewController *home = [[HomeViewController alloc]init];
//            [_activityVC presentViewController:home animated:YES completion:nil];
//            UIButton *customView = [UIButton buttonWithType:UIButtonTypeCustom];
//            customView.backgroundColor = [UIColor orangeColor];
//            [customView addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
//            [self.notification displayNotificationWithView:customView forDuration:3];
//        });
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"UIActivityViewController";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"HomeViewController 被present";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        OpenGL1ViewController *vc = [[OpenGL1ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"0-显示";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        OpenGLOneViewController *vc = [[OpenGLOneViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"1-基础绘制,三角形";
    [sectionOne.items addObject:model];
    
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        OpenGL2ViewController *vc = [[OpenGL2ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"1-基础绘制,三角形_shader";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        OpenGLTwoViewController *vc = [[OpenGLTwoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"2-纹理绘图";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        OpenGLMultitextureViewController *vc = [[OpenGLMultitextureViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"3-多纹理绘图";
    [sectionOne.items addObject:model];
    
    model = [[SimpleCellItem alloc]init];
    model.isHiddenSplitelineView = NO;
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        OpenGLTextureDynamicViewController *vc = [[OpenGLTextureDynamicViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    model.reuseableIdentierOfCell = [SimpleCell simpleCellReuseIdentiferForElementType:ElementTypeContainMainTitleLabel];
    model.title = @"4-多纹理动态绘图";
    [sectionOne.items addObject:model];
    
    [self.sectionItems addObject:sectionOne];
}
+ (void)tap
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HomeViewController *home = [[HomeViewController alloc]init];
        [[UIApplication.sharedApplication keyWindow].rootViewController presentViewController:home animated:YES completion:nil];
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
