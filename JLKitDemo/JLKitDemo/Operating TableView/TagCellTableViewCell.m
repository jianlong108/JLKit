//
//  TagCellTableViewCell.m
//  JLKitDemo
//
//  Created by wangjianlong on 2018/4/2.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "TagCellTableViewCell.h"
#import "MTHorizontalWaterFullLayout.h"

NSString  * const TagCellTableViewCell_ReuseIdentifer = @"TagCellTableViewCell_ReuseIdentifer";


@interface TagCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;

@end

@implementation TagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _label = [[UILabel alloc]initWithFrame:self.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_label];
        _label.backgroundColor = [UIColor blueColor];
    }
    return self;
}


@end

@interface TagCellTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
/**<#message#>*/
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation TagCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc]init];
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 300, 300) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[TagCollectionViewCell class] forCellWithReuseIdentifier:@"flowlayout"];
        [self.contentView addSubview:collectionView];
        self.collectionView = collectionView;
    }
    return self;
}

- (void)setUpItem:(TagItem *)item
{
    _item = item;
    
    self.collectionView.collectionViewLayout = _item.layout;
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(CGRectGetWidth(self.frame) - self.item.layout.maxWidth, 0, self.item.layout.collectionViewContentSize.width, self.item.layout.collectionViewContentSize.height);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.item.dates.count;
}

- (__kindof TagCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"flowlayout" forIndexPath:indexPath];
    cell.label.text = [(TagItemModel *)[self.item.dates objectAtIndex:indexPath.item] str];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

@end
