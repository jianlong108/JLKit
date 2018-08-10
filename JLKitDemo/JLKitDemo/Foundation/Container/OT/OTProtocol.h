//
//  OTProtocol.h
//  我的控件集合
//
//  Created by Wangjianlong on 2017/8/12.
//  Copyright © 2017年 Wangjianlong. All rights reserved.
//  Operating TableView 简单方便使用TableView


#import <UIKit/UIKit.h>

#ifndef SetCell_h
#define SetCell_h

typedef void (^OTCellClickBlock)(id obj,NSIndexPath *indexPath);

/**
 *  数据对象协议,单纯存放数据
 */
@protocol OTItemProtocol <NSObject>

@required

@property (nonatomic, copy) NSString *reuseableIdentierOfCell;
- (CGFloat)heightOfCell;

@optional

@property (nonatomic, assign) BOOL lastRow;
@property (nonatomic, copy) OTCellClickBlock cellClickBlock;
@property (nonatomic, copy) OTCellClickBlock switchClickBlock;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configCellWhenCellIsCreated:(UITableViewCell *)cell;

@end

/**
 *  布局对象协议,它由数据对象驱动
 */
@protocol OTLayoutItemProtocol <OTItemProtocol>

@optional

/**元素与cell之间间距*/
@property (nonatomic, assign)  UIEdgeInsets outerMargin;
/**元素与元素之间间距*/
@property (nonatomic, assign)  UIEdgeInsets innerMargin;

@end


/**
 *  组对象协议,它由数据对象驱动
 */
@protocol OTSectionItemProtocol <NSObject>

@required
- (NSArray< id<OTLayoutItemProtocol> > *)itemsOfSection;

@optional
- (CGFloat )heightOfGroupHeader;
- (CGFloat )heightOfGroupFooter;
- (NSString *)headerOfGroup;
- (NSString *)footerOfGroup;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

@end


////cell协议
@protocol OTCellProtocol <NSObject>

@required


/**
 为内容视图配置数据

 @param item 为cell配置对应的数据模型对象
 */
- (void)setUpItem:(id<OTItemProtocol>)item;


@optional

/**数据模型*/
@property (nonatomic, strong)  id<OTItemProtocol> item;

/**元素与cell之间间距*/
@property (nonatomic, assign)  UIEdgeInsets outerMargin;

/**元素与元素之间间距*/
@property (nonatomic, assign)  UIEdgeInsets innerMargin;


/**
 为cell设置delegate
 @param delegate 代理
 */
- (void)setDelegateObjectForSelf:(id)delegate;

/**
 初始化内容视图
 @option 在此方法中初始化子视图
 */
- (void)initlizeContentViews;

/**
 布局内容视图
 @warning 此方法适合frame 布局视图时使用
 @warning 此方法在layoutSubViews 方法中调用
 */
- (void)layoutContentViews;


@end


#endif /* SetCell_h */
