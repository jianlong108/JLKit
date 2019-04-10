//
//  MTTableViewSectionIndexBar.h
//  MiTalk
//
//  Created by 王建龙 on 2017/11/29.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTIndexViewConfiguration.h"

@class MTTableViewSectionIndexBar;

@protocol MTTableViewSectionIndexBarDelegate <NSObject>

@optional

/**
 当点击或者滑动索引视图时，回调这个方法

 @param indexView 索引视图
 @param section   索引位置
 */
- (void)indexView:(MTTableViewSectionIndexBar *)indexView didSelectAtSection:(NSUInteger)section;

/**
 当滑动tableView时，索引位置改变，你需要自己返回索引位置时，实现此方法。
 不实现此方法，或者方法的返回值为 SCIndexViewInvalidSection 时，索引位置将由控件内部自己计算。

 @param indexView 索引视图
 @param tableView 列表视图
 @return          索引位置
 */
- (NSUInteger)sectionOfIndexView:(MTTableViewSectionIndexBar *)indexView tableViewDidScroll:(UITableView *)tableView;

@end

//TODO 需要优化，sublayer 的处理有问题。扩展性不好
@interface MTTableViewSectionIndexBar : UIControl

@property (nonatomic, weak) id<MTTableViewSectionIndexBarDelegate> delegate;

// 索引视图数据源
@property (nonatomic, copy) NSArray<NSString *> *dataSource;

// 当前索引位置
@property (nonatomic, assign) NSInteger currentSection;

// tableView在NavigationBar上是否半透明
@property (nonatomic, assign) BOOL translucentForTableViewInNavigationBar;

// 索引视图的配置
@property (nonatomic, strong, readonly) MTIndexViewConfiguration *configuration;

// SCIndexView 会对 tableView 进行 strong 引用，请注意，防止“循环引用”
- (instancetype)initWithTableView:(UITableView *)tableView configuration:(MTIndexViewConfiguration *)configuration;

@end
