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

#import "SimpleCell.h"

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
    CustomPresentViewControllerProtocol
>

@property (nonatomic, strong) NSMutableArray *dates;

@end

@implementation HomeFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView registerClass:[SimpleCell class] forCellReuseIdentifier:SimpleCell_ReuseIdentifer];
    [self setUpModel];
}

- (void)setUpModel
{
    OTSectionModel *sectionOne = [[OTSectionModel alloc]init];
    sectionOne.footerHeight = 7;
    sectionOne.headerHeight = 7;
    
    SimpleItem *model = [[SimpleItem alloc]init];

    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"基础控件展示";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"可拖动tableview";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"菜单view";
    [sectionOne.items addObject:model];
    
    model = [[SimpleItem alloc]init];
    model.cellClickBlock = ^(id obj, NSIndexPath *indexPath) {
        
    };
    model.reuseableIdentierOfCell = SimpleCell_ReuseIdentifer;
    model.title = @"可拖动九宫格";
    [sectionOne.items addObject:model];
    
    
    [self.sectionItems addObject:sectionOne];
}


- (UIScrollView *)contentScrollView
{
    return self.tableView;
}

- (void)setScrollViewContentInset:(UIEdgeInsets)inset
{
    self.contentScrollView.contentInset = inset;
    
}
- (NSString *)titleForScrollTitleBar
{
    return @"功能";
}

@end
