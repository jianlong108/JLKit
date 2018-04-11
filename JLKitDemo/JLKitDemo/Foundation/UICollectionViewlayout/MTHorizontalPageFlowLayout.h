//
//  MTHorizontalPageFlowLayout.h
//  MiTalk
//
//  Created by wangjianlong on 2018/3/28.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 适用于单组(section == 1) 的横向分页流水布局
 */
@interface MTHorizontalPageFlowLayout : UICollectionViewFlowLayout


/** 列间距 */
@property (nonatomic, readonly) CGFloat columnSpacing;

/** 行间距 */
@property (nonatomic, readonly) CGFloat rowSpacing;

/** collectionView的内边距 */
@property (nonatomic, readonly) UIEdgeInsets edgeInsets;

/** 多少行 */
@property (nonatomic, readonly) NSInteger rowCount;

/** 每行展示多少个item */
@property (nonatomic, readonly) NSInteger itemCountPerRow;

/** 所有item的属性数组 */
@property (nonatomic, readonly) NSMutableArray *attributesArrayM;

/**
 快速创建布局对象

 @param rowCount 行数
 @param itemCountPerRow 每页展示的列数
 @return 实例
 */
+ (instancetype)horizontalPageFlowlayoutWithRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow;

/**
 创建布局对象

 @param rowCount 行数
 @param itemCountPerRow 每页展示的列数
 @return 实例
 */
- (instancetype)initWithRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow;


/**
 配置每个cell间的行,列间距..及sectionInset

 @param columnSpacing 列间距
 @param rowSpacing 行间距
 @param edgeInsets contentInset
 */
- (void)setColumnSpacing:(CGFloat)columnSpacing rowSpacing:(CGFloat)rowSpacing edgeInsets:(UIEdgeInsets)edgeInsets;



/**
 设置多少行.及每页的列数

 @param rowCount 行数
 @param itemCountPerRow 每页的列数
 */
- (void)setRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow;

@end
