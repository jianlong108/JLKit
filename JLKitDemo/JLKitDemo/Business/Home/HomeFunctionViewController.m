//
//  HomeFunctionViewController.m
//  JLKitDemo
//
//  Created by wangjianlong on 2018/4/2.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "HomeFunctionViewController.h"
#import "MTHorizontalWaterFullLayout.h"
#import "IOS11Adapter.h"
#import "JLScrollNavigationChildControllerProtocol.h"

#import "InfiniteLoops.h"

@interface StringItemModel :NSObject<HorizontalWaterFullModelProtocol,JLScrollNavigationChildControllerProtocol>

@property (nonatomic, copy) NSString *str;

@end

@implementation StringItemModel

+ (instancetype)modelWithString:(NSString *)str
{
    StringItemModel *model = [[self alloc]init];
    model.str = str;
    return model;
}

- (CGFloat)widthForModel
{
    NSAttributedString *attritbuteString = [[NSAttributedString alloc]initWithString:self.str attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    CGRect bounds = [attritbuteString boundingRectWithSize:CGSizeMake(MAXFLOAT, [UIFont systemFontOfSize:14].lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return CGRectGetWidth(bounds);
}

@end

@interface StringCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;

@end

@implementation StringCollectionViewCell

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

@interface HomeFunctionViewController ()<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    CustomPresentViewControllerProtocol
>

@property (nonatomic, strong) NSMutableArray *dates;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HomeFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    InfiniteLoops *loop = [[InfiniteLoops alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 300) scrollDuration:3.f];
    loop.backgroundColor = [UIColor blackColor];
    [self.view addSubview:loop];
    loop.imageURLStrings = @[@"1.jpg", @"2.jpg", @"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg",@"9.jpg",@"10.jpg"];
    loop.clickAction = ^(NSInteger index) {
        NSLog(@"curIndex: %ld", index);
    };
    
    // Do any additional setup after loading the view.
    MTHorizontalWaterFullLayout *layout = [[MTHorizontalWaterFullLayout alloc]initWithDataes:self.dates maxWidth:300 itemHeight:[UIFont systemFontOfSize:14].lineHeight];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 400, 300, 300) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[StringCollectionViewCell class] forCellWithReuseIdentifier:@"flowlayout"];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dates.count;
}

- (__kindof StringCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StringCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"flowlayout" forIndexPath:indexPath];
    cell.label.text = [(StringItemModel *)[self.dates objectAtIndex:indexPath.item] str];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (NSMutableArray *)dates{
    if (_dates == nil) {
        NSMutableArray *array = @[@"足球",@"乒乓球",@"稀里哗啦",@"无所谓的啦",@"足球",@"乒乓球",@"稀里哗啦",@"无所谓的啦",@"足球",@"乒乓球",@"稀里哗啦",@"无所谓的啦",@"足球",@"乒乓球",@"稀里哗啦",@"无所谓的啦",@"足球",@"乒乓球",@"稀里哗啦",@"无所谓的啦"].mutableCopy;
        _dates = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            StringItemModel *model = [StringItemModel modelWithString:obj];
            [_dates addObject:model];
        }];
        
    }
    return _dates;
}

- (CGRect)contentViewFrame
{
    return CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 300)/2, (CGRectGetHeight([UIScreen mainScreen].bounds) - 300)/2, 300, 300);
}

- (UIScrollView *)contentScrollView
{
    return self.collectionView;
}

- (void)setScrollViewContentInset:(UIEdgeInsets)inset
{
    self.collectionView.contentInset = inset;
    
}
- (NSString *)titleForScrollTitleBar
{
    return @"功能";
}

@end
