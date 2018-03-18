//
//  SettingViewController.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/8/13.
//  Copyright © 2017年 JL. All rights reserved.
//
#import "SettingViewController.h"
#import "LoginCell.h"
#import "SettingCustonItem.h"
#import "SettingCell.h"
#import "SettingGroupModel.h"
#import "UIImage+JL.h"


@implementation  SettingViewController

/**
 *  第0组数据
 */
- (void)setupGroup0
{
    SettingItem *pushNotice = [SettingArrowItem itemWithIcon:@"MorePush" title:@"我的车库" destVcClass:[UIViewController class]];
    SettingGroupModel *group = [[SettingGroupModel alloc] init];
    group.headerHeight = 20;
    group.footerHeight = 40;
    group.footer =@"免费获取车辆违章提醒,车主认证服务";
    group.items = @[pushNotice];
    [self.data addObject:group];
}
- (void)setupGroup1
{
    SettingItem *pushNotice = [SettingArrowItem itemWithIcon:@"MorePush" title:@"设置" destVcClass:[UIViewController class]];
    
    SettingGroupModel *group = [[SettingGroupModel alloc] init];
    
    group.headerHeight = 20;
    group.items = @[pushNotice];
    [self.data addObject:group];
}
- (void)setupGroup2
{
    SettingItem *pushNotice = [SettingArrowItem itemWithIcon:@"MorePush" title:@"我的订单" destVcClass:[UIViewController class]];
    SettingItem *pushNotice1 = [SettingArrowItem itemWithIcon:@"MorePush" title:@"我的好友" destVcClass:[UIViewController class]];
    SettingItem *pushNotice2 = [SettingArrowItem itemWithIcon:@"MorePush" title:@"我的收藏" destVcClass:[UIViewController class]];
    SettingItem *pushNotice3 = [SettingArrowItem itemWithIcon:@"MorePush" title:@"我的主贴" destVcClass:[UIViewController class]];
    SettingItem *pushNotice4 = [SettingArrowItem itemWithIcon:@"MorePush" title:@"我的口碑" destVcClass:[UIViewController class]];
    SettingItem *pushNotice5 = [SettingArrowItem itemWithIcon:@"MorePush" title:@"车主价格" destVcClass:[UIViewController class]];
    SettingGroupModel *group = [[SettingGroupModel alloc] init];
    group.headerHeight = 20;
    group.items = @[pushNotice,pushNotice1,pushNotice2,pushNotice3,pushNotice4,pushNotice5];
    [self.data addObject:group];
}
- (void)setupGroup3
{
    SettingItem *pushNotice = [SettingArrowItem itemWithIcon:@"MorePush" title:@"浏览历史" destVcClass:[UIViewController class]];
    SettingItem *pushNotice1 = [SettingArrowItem itemWithIcon:@"MorePush" title:@"草稿箱" destVcClass:[UIViewController class]];
    SettingGroupModel *group = [[SettingGroupModel alloc] init];
    group.headerHeight = 30;
    group.items = @[pushNotice,pushNotice1];
    [self.data addObject:group];
}
- (void)setupGroup4
{
    SettingCustonItem *login = [[SettingCustonItem alloc]init];
    login.reuseableIdentifer = @"loginCell";
    login.cellHeight = 64;
    login.option = ^(id objct){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"退出登录" message:@"确定退出登录吗" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"%@",objct);
    };
    
    SettingGroupModel *group = [[SettingGroupModel alloc] init];
    group.headerHeight = 10;
    group.items = @[login];
    [self.data addObject:group];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[LoginCell class] forCellReuseIdentifier:@"loginCell"];
    [self.tableView registerClass:[SettingCell class] forCellReuseIdentifier:@"settingCell"];
    // 2.添加数据
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    [self setupGroup4];
}
- (void)entryLoginVc{
    
}

- (UIImage *)navigationBarBackgroundImage
{
    return [UIImage imageWithUIColor:[UIColor redColor]];
}

- (CGFloat)alphaOfNavigationBar
{
    return 1.0;
}

@end
