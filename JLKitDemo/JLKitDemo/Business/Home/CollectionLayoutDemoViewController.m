//
//  CollectionLayoutDemoViewController.m
//  JLKitDemo
//
//  Created by JL on 2023/4/2.
//  Copyright © 2023 JL. All rights reserved.
//

#import "CollectionLayoutDemoViewController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

///简易的左右滑动的布局对象,主要解决间距不准的问题
@interface SingleRowCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableArray *attributeAttay;

@end

@implementation SingleRowCollectionViewFlowLayout

- (NSMutableArray *)attributeAttay
{
    if (!_attributeAttay) {
        _attributeAttay = [NSMutableArray array];
    }
    return _attributeAttay;
}

//适配阿语环境
- (BOOL)flipsHorizontallyInOppositeLayoutDirection {
    return YES;
}

- (void)prepareLayout
{
    [super prepareLayout];
    NSUInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    //计算每一个item的宽度
    CGFloat width = self.itemSize.width;
    CGFloat hight = self.itemSize.height;
    CGFloat lastX = self.sectionInset.left;
    for (int i = 0; i < itemCount; i++) {
        //设置每个item的位置等相关属性
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        //创建一个布局属性类，通过indexPath来创建
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];

        //设置item的位置
        attris.frame = CGRectMake(lastX, 0, width, hight);
        [self.attributeAttay addObject:attris];
        lastX += (self.minimumInteritemSpacing + width);
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributeAttay;
}

// 当collectionView bounds改变时，是否重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//返回collectionView的最终大小
- (CGSize)collectionViewContentSize
{
    NSUInteger itemCount =  [self.collectionView numberOfItemsInSection:0];
    CGFloat insetVal = self.sectionInset.left + self.sectionInset.right;
    return CGSizeMake(insetVal + itemCount * (self.itemSize.width + self.minimumInteritemSpacing) - self.minimumInteritemSpacing,  self.itemSize.height + self.sectionInset.top + self.sectionInset.bottom);
}

@end



@interface CollectionLayoutDemoViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *postEntranceView;
@property (nonatomic, strong) MASConstraint *collConstraint;
@end

@implementation CollectionLayoutDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    SingleRowCollectionViewFlowLayout *flowLayout = [[SingleRowCollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(64.f,64.f);
    flowLayout.minimumInteritemSpacing = 6.0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _postEntranceView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _postEntranceView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [_postEntranceView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"_postEntranceViewCell"];
    _postEntranceView.dataSource = self;
    _postEntranceView.delegate = self;
    [self.view addSubview:_postEntranceView];
    [_postEntranceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(NAVIGATION_BAR_HEIGHT);
        make.leading.equalTo(self.view).offset(16);
        make.trailing.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(64);
        self.collConstraint = make.width.mas_greaterThanOrEqualTo(134);
//        make.width.mas_greaterThanOrEqualTo(flowLayout.collectionViewContentSize.width);
    }];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int a = 3;
    if (a > 2) {
        [self.collConstraint deactivate];
    }
    
    return a;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"_postEntranceViewCell" forIndexPath:indexPath];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imgView];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    [imgView sd_setImageWithURL:[NSURL URLWithString:@"https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2022%2F0210%2Fb0970fa4j00r72grq001qc000hs011kc.jpg&thumbnail=660x2147483647&quality=80&type=jpg"]];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    
    if (indexPath.row == 1) {
        imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return cell;
}
@end
