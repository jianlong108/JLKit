//
//  JLDragOrderCollectionViewLayout.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/1/15.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 允许拖动排序的拖动方向

 - SupportDragOrientationAll: 不限制拖动方向
 - SupportDragOrientationHorizontal 只能横向拖动
 - SupportDragOrientationVertical 只能纵向拖动
 */
typedef NS_ENUM(NSInteger, SupportDragOrientation)
{
    SupportDragOrientationAll = 0,
    SupportDragOrientationHorizontal =1,
    SupportDragOrientationVertical =2
};


/**
 override 数据源,为了实现版本间兼容
 */
@protocol JLDragOrderCollectionViewLayoutDataSource<UICollectionViewDataSource>

@required

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

@optional

/** 记录cell滑动时，原始cell的透明度。默认为0。 一般情况下，外部不需进行设置。*/
- (CGFloat)reorderingItemAlpha:(UICollectionView * )collectionview inSection:(NSInteger)section;

/** 以下2个方法为CollectionView的代理方法进行的封装，可以在CollctionView中进行自定义。一般情况下，外部不需进行设置。*/
- (UIEdgeInsets)scrollTrigerEdgeInsetsInCollectionView:(UICollectionView *)collectionView;

- (UIEdgeInsets)scrollTrigerPaddingInCollectionView:(UICollectionView *)collectionView;

- (CGFloat)scrollSpeedValueInCollectionView:(UICollectionView *)collectionView;

@end

@protocol JLDragOrderCollectionViewLayoutDelegate <UICollectionViewDelegateFlowLayout>

@optional

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath;


- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath;

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;


- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;


- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JLDragOrderCollectionViewLayout : UICollectionViewFlowLayout<UIGestureRecognizerDelegate>

@property (nonatomic, weak)id<JLDragOrderCollectionViewLayoutDelegate> delegate;
@property (nonatomic, weak)id<JLDragOrderCollectionViewLayoutDataSource> dataSource;
@property (nonatomic, strong)UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong)UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign)SupportDragOrientation dragDirection;

@end
