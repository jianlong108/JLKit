//
//  SettingViewController.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/8/13.
//  Copyright © 2017年 JL. All rights reserved.
//
#import "SettingViewController.h"
#import "LoginCell.h"
#import "SimpleItem.h"
#import "SimpleCell.h"
#import "OTSectionModel.h"
#import "UIImage+JL.h"
#import "TagItem.h"
#import "TagCellTableViewCell.h"


@implementation  SettingViewController


- (void)setupGroup1
{
    SimpleItem *pushNotice = [SettingArrowItem itemWithIcon:@"MorePush" title:@"设置" destVcClass:[UIViewController class]];
    pushNotice.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    
    
    OTSectionModel *group = [[OTSectionModel alloc] init];
    
    group.headerHeight = 20;
    group.items = @[pushNotice].mutableCopy;
    [self.sectionItems addObject:group];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[SimpleCell class] forCellReuseIdentifier:SimpleCell_ReuseIdentifer];
    [self.tableView registerClass:[TagCellTableViewCell class] forCellReuseIdentifier:TagCellTableViewCell_ReuseIdentifer];
    // 2.添加数据
    [self setupGroup1];
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
