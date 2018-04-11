//
//  AHTabMoreView.m

//  Created by Wangjianlong on 16/6/13.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import "JLTabMoreView.h"
#import "JLDragOrderCollectionViewLayout.h"

@interface JLTabMoreView ()<UICollectionViewDelegate,JLDragOrderCollectionViewLayoutDataSource,JLDragOrderCollectionViewLayoutDelegate>


/**布局对象*/
@property (nonatomic, strong)JLDragOrderCollectionViewLayout *flowLayout;

/**contentView*/
@property (nonatomic, strong)UICollectionView *contentView;

/***/
@property (nonatomic, strong)NSIndexPath *fromIndex;

/***/
@property (nonatomic, strong)NSIndexPath *toIndex;

@end


@implementation JLTabMoreView


- (instancetype)initMoreTabViewWithItems:(NSArray *)items Frame:(CGRect)rect{
    if (self = [super initWithFrame:rect]) {
        self.items = [NSMutableArray arrayWithArray:items];
        self.column = 3;
        [self initializeSubviewsWithRect:rect];
    }
    return self;
}
- (void)initializeSubviewsWithRect:(CGRect)rect{
    if (_flowLayout == nil) {
        _flowLayout = [[JLDragOrderCollectionViewLayout alloc]init];
        _flowLayout.longPress.minimumPressDuration = 0.3;
        _flowLayout.delegate = self;
        _flowLayout.dataSource = self;
    }
    if (_contentView == nil) {
        _contentView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:_flowLayout];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        [_contentView setBackgroundColor:[UIColor lightGrayColor]];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        [_contentView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AHTabMoreViewCell"];
        [self addSubview:_contentView];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
    }
    
    
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:4 inSection:0];
//    [self.contentView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AHTabMoreViewCell" forIndexPath:indexPath];
    if (self.items.count > indexPath.item) {
        JLCellitem *item = self.items[indexPath.item];
        item.userInteractionEnabled = NO;
        item.frame = cell.bounds;
        [cell.contentView addSubview:item];
    }
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGFloat margin = 1;
    
    CGFloat itemWidth = floor((collectionView.frame.size.width - (self.column-1)*margin)/self.column);
    CGFloat itemHeight = itemWidth *125/110;
    return CGSizeMake(itemWidth, itemHeight);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (self.items.count > indexPath.item) {
        JLCellitem *item = self.items[indexPath.item];
        if (item.prohibitUse) {
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabMoreView:didSelectItemAtIndex:tabBarItem:)]) {
            [self.delegate tabMoreView:self didSelectItemAtIndex:indexPath.item tabBarItem:item];
        }
        
    }
}
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath{
//    NSLog(@"from%ld---to%ld",fromIndexPath.item,toIndexPath.item);
//    [self.items exchangeObjectAtIndex:fromIndexPath.item withObjectAtIndex:toIndexPath.item];
    
   
    
}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(tabMoreView:willBeginDraggingItemAtIndexPath:)]) {
        [self.delegate tabMoreView:self willBeginDraggingItemAtIndexPath:indexPath.item];
    }
}

/*!
 @method
 @abstract   长按后触发的回调，一般情况下，外部不需进行设置。
 */
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath{
    self.fromIndex = indexPath;
    if ([self.delegate respondsToSelector:@selector(tabMoreView:didBeginDraggingItemAtIndexPath:)]) {
        [self.delegate tabMoreView:self didBeginDraggingItemAtIndexPath:indexPath.item];
    }
}

/*!
 @method
 @abstract   will取消drag
 */
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(tabMoreView:willEndDraggingItemAtIndexPath:)]) {
        [self.delegate tabMoreView:self willEndDraggingItemAtIndexPath:indexPath.item];
    }
}

/*!
 @method
 @abstract   did取消drag
 */
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath{
    self.toIndex = indexPath;
    [self cacluteData];
    [self reloadItems];
//
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabMoreView:didMoveItemFromIndex:ToIndex:)]) {
        [self.delegate tabMoreView:self didMoveItemFromIndex:self.fromIndex.item ToIndex:self.toIndex.item];
    }
    if ([self.delegate respondsToSelector:@selector(tabMoreView:didEndDraggingItemAtIndexPath:)]) {
        [self.delegate tabMoreView:self didEndDraggingItemAtIndexPath:indexPath.item];
    }
}
- (void)cacluteData{
    for (int i = 0;  i <= abs((int)(self.toIndex.item - self.fromIndex.item)); i++) {
        NSLog(@"%ld %ld",self.fromIndex.item,self.toIndex.item);
        
        if (self.fromIndex.item > self.toIndex.item) {
//            NSLog(@"%ld  %ld",self.fromIndex.item,self.toIndex.item + i);
            [self.items exchangeObjectAtIndex:self.fromIndex.item withObjectAtIndex:self.toIndex.item + i];
        }else {
//            NSLog(@"%ld  %ld",self.fromIndex.item,self.toIndex.item - i);
            [self.items exchangeObjectAtIndex:self.fromIndex.item withObjectAtIndex:self.toIndex.item - i];
        }
        
    }
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item < self.items.count) {
        JLCellitem *item = self.items[indexPath.item];
        if (item.prohibitUse == YES || item.onlyClick == YES) {
            return NO;
        }else {
            return YES;
        }
    }
    return NO;
}

/*!
 @method
 @abstract   是否可以移动到指定的位置
 */
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath{
    if (toIndexPath.item < self.items.count) {
        JLCellitem *item = self.items[toIndexPath.item];
        if (item.prohibitUse == YES) {
            return NO;
        }else {
            return YES;
        }
    }
    return NO;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.contentView) {
        [self reloadItems];
    }
}

- (void)reloadItems{
    if (self.items) {
        int last = (self.items.count % (int)_column);
        if (last > 0) {
            for (int i = 0 ; i< _column - last ; i++) {
                JLCellitem *item = [[JLCellitem alloc]init];
                item.prohibitUse = YES;
                [self.items addObject:item];
            }
        }
        
        [self.contentView reloadData];
    }
}
- (void)setItems:(NSArray *)items{
    if (_items != items) {
        _items = (NSMutableArray *)items;
        if (self.contentView == nil) {
            [self initializeSubviewsWithRect:self.bounds];
        }else {
            [self reloadItems];
        }
        
    }
}
- (void)setColumn:(NSInteger)column{
    if (_column != column) {
        _column = column;
    }
    
}
@end
