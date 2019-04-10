//
//  UITableView+IndexBar.h
//  MiTalk
//
//  Created by 王建龙 on 2017/11/29.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTIndexViewConfiguration.h"

//UITableViewIndexSearch
UIKIT_EXTERN NSString *const UITableViewIndexLike;

@protocol MTTableViewSectionIndexDelegate

/**
 当点击或者滑动索引视图时，回调这个方法
 
 @param tableView 列表视图
 @param section   索引位置
 */
- (void)tableView:(UITableView *)tableView didSelectIndexViewAtSection:(NSUInteger)section;

/**
 当滑动tableView时，索引位置改变，你需要自己返回索引位置时，实现此方法。
 不实现此方法，或者方法的返回值为 SCIndexViewInvalidSection 时，索引位置将由控件内部自己计算。
 
 @param tableView 列表视图
 @return          索引位置
 */
- (NSUInteger)sectionOfTableViewDidScroll:(UITableView *)tableView;

@end

@interface UITableView (IndexBar)

@property (nonatomic, weak) id<MTTableViewSectionIndexDelegate> mtSectionIndexBarDelegate;

// 索引视图数据源
@property (nonatomic, copy) NSArray<NSString *> *mtSectionIndexBarDataSource;

// tableView在NavigationBar上是否半透明
@property (nonatomic, assign) BOOL mtSectionIndexBarTranslucentForTableViewInNavigationBar;

// 索引视图的配置
@property (nonatomic, strong) MTIndexViewConfiguration *mtSectionIndexBarConfiguration;


@end
