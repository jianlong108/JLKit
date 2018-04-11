//
//  AHTabMoreView.h
//  AHUI
//
//  Created by Wangjianlong on 16/6/13.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLCellitem.h"

@class JLTabMoreView;

@protocol AHTabMoreViewDelegate<NSObject>


/**
 *  点击事件回调
 *
 *  @param tabMoreView AHTabMoreView
 *  @param index  当前Tap在items中的位置
 *  @param item   点击的Tap
 */
- (void)tabMoreView:(JLTabMoreView *)tabMoreView didSelectItemAtIndex:(NSUInteger)index tabBarItem:(JLCellitem *)item;
- (void)tabMoreView:(JLTabMoreView *)tabMoreView didMoveItemFromIndex:(NSUInteger)FromIndex ToIndex:(NSUInteger)toIndex;

@optional
- (void)tabMoreView:(JLTabMoreView *)tabMoreView willBeginDraggingItemAtIndexPath:(NSUInteger)indexPath;

/*!
 @method
 @abstract   长按后触发的回调，一般情况下，外部不需进行设置。
 */
- (void)tabMoreView:(JLTabMoreView *)tabMoreView didBeginDraggingItemAtIndexPath:(NSUInteger)indexPath;

/*!
 @method
 @abstract   will取消drag
 */
- (void)tabMoreView:(JLTabMoreView *)tabMoreView willEndDraggingItemAtIndexPath:(NSUInteger)indexPath;

/*!
 @method
 @abstract   did取消drag
 */
- (void)tabMoreView:(JLTabMoreView *)tabMoreView didEndDraggingItemAtIndexPath:(NSUInteger)indexPath;

@end


@interface JLTabMoreView : UIView
/**代理*/
@property (nonatomic, weak)id<AHTabMoreViewDelegate> delegate;

/**
 *  提供的视图源，每一下均为JLCellitem或其子类的实例对象
 */
@property (nonatomic, strong) NSMutableArray <JLCellitem *>*items;
/**
 *  获取当前选中的TapItem
 */
@property (nonatomic, readonly) JLCellitem *selectedItem;

/**
 *  获取当前选中的TapItem 在Items中的索引
 */
@property (nonatomic, readonly) NSInteger selectedIndex;
/**
 *  设置列数(根据此属性和frame计算出每个单元格的宽)
 */
@property (nonatomic, assign) NSInteger column;


- (instancetype)initMoreTabViewWithItems:(NSArray <JLCellitem *>*)items Frame:(CGRect)rect;

//重新绘制
- (void)reloadItems;

@end
