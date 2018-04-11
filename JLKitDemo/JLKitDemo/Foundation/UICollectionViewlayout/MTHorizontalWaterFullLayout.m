//
//  MTHorizontalWaterFullLayout.m
//  MiTalk
//
//  Created by wangjianlong on 2018/4/2.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import "MTHorizontalWaterFullLayout.h"

@interface MTHorizontalWaterFullLayout()

@property (nonatomic, strong) NSMutableArray *datasM;
@property (nonatomic, strong) NSMutableArray *attributesArrayM;

@property (nonatomic, assign) CGFloat columnSpacing;
@property (nonatomic, assign) CGFloat rowSpacing;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) NSInteger itemCountPerRow;

/**当前行号*/
@property (nonatomic, assign) NSUInteger currentRowCount;
@property (nonatomic, assign) CGFloat currentRowWidth;
/**当前总高度*/
@property (nonatomic, assign) CGFloat currentContentHeight;
/**<#message#>*/
@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) CGFloat oringnalX;

@property (nonatomic, assign) HorizontalWaterFullLayoutStyle style;


@property (nonatomic, assign) CGFloat oringnalMaxX;

/**<#message#>*/
@property (nonatomic, assign) CGFloat maxWidth;

@end

@implementation MTHorizontalWaterFullLayout

- (void)setColumnSpacing:(CGFloat)columnSpacing rowSpacing:(CGFloat)rowSpacing edgeInsets:(UIEdgeInsets)edgeInsets
{
    self.columnSpacing = columnSpacing;
    self.rowSpacing = rowSpacing;
    self.edgeInsets = edgeInsets;
    
    [self preproccessLayou];
}

- (instancetype)initWithDataes:(NSArray <id<HorizontalWaterFullModelProtocol>>*)dates maxWidth:(CGFloat)maxWidth itemHeight:(CGFloat)itemHeight
{
    return [self initWithDataes:dates maxWidth:maxWidth itemHeight:itemHeight style:HorizontalWaterFullLayoutStyleLeft];
}

- (instancetype)initWithDataes:(NSArray <id<HorizontalWaterFullModelProtocol>>*)dates maxWidth:(CGFloat)maxWidth itemHeight:(CGFloat)itemHeight style:(HorizontalWaterFullLayoutStyle)style
{
    if (self = [super init]) {
        _datasM = [NSMutableArray arrayWithArray:dates];
        _currentRowCount = 0;
        _itemHeight = itemHeight;
        _rowSpacing = 5;
        _columnSpacing = 5;
        _style = style;
        _maxWidth = maxWidth;
        [self preproccessLayou];
    }
    return self;
}


- (void)preproccessLayou
{
    _currentRowCount = 0;
    [self.attributesArrayM removeAllObjects];
    // 从collectionView中获取到有多少个item
    NSInteger itemTotalCount = self.datasM.count;
    
    if (_style == HorizontalWaterFullLayoutStyleLeft) {
        _oringnalX = self.edgeInsets.left + self.columnSpacing;
        _currentRowWidth = _oringnalX;
    } else {
        _oringnalMaxX = _maxWidth - self.edgeInsets.right - self.columnSpacing;
        _currentRowWidth = _oringnalMaxX;
    }
    // 遍历出item的attributes,把它添加到管理它的属性数组中去
    for (int i = 0; i < itemTotalCount; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexpath];
        [self.attributesArrayM addObject:attributes];
    }
    
    _currentContentHeight = (_currentRowCount + 1)*self.rowSpacing + _currentRowCount * self.itemHeight + self.edgeInsets.top + self.edgeInsets.bottom;
}

- (void)prepareLayout
{
    [super prepareLayout];
}

/** 计算collectionView的滚动范围 */
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(_maxWidth,self.currentContentHeight);
}

/** 设置每个item的属性(主要是frame) */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // item的宽高由数据源提供
    CGFloat itemWidth = 0;
    CGFloat itemHeight = 0;
    if (indexPath.item < self.datasM.count) {
        id<HorizontalWaterFullModelProtocol>object = self.datasM[indexPath.item];
        itemWidth = [object widthForModel];
        itemHeight = self.itemHeight;
    }
    CGFloat maxWidth = _maxWidth;
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    if (_style == HorizontalWaterFullLayoutStyleLeft) {
        if (_currentRowWidth + itemWidth +self.columnSpacing + self.edgeInsets.right > maxWidth) {
            itemX = _oringnalX;
            _currentRowCount += 1;
            _currentRowWidth = _oringnalX;
        } else {
            itemX = _currentRowWidth;
        }
        itemY = _currentRowCount * itemHeight + (_currentRowCount + 1)*self.rowSpacing;
        _currentRowWidth += itemWidth;
        _currentRowWidth += self.columnSpacing;
    } else {
        if (_currentRowWidth - itemWidth - self.columnSpacing - self.edgeInsets.left < 0) {
            itemX = _oringnalMaxX - itemWidth;
            _currentRowCount += 1;
            _currentRowWidth = _oringnalMaxX;
        } else {
            itemX = _currentRowWidth - itemWidth;
        }
        itemY = _currentRowCount * itemHeight + (_currentRowCount + 1)*self.rowSpacing;
        _currentRowWidth -= itemWidth;
        _currentRowWidth -= self.columnSpacing;
    }
    
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 每个item的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArrayM;
}


#pragma mark - Lazy
- (NSMutableArray *)attributesArrayM
{
    if (!_attributesArrayM) {
        _attributesArrayM = [NSMutableArray array];
    }
    return _attributesArrayM;
}


@end
