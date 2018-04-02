//
//  TagItem.m
//  JLKitDemo
//
//  Created by wangjianlong on 2018/4/2.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "TagItem.h"

@implementation TagItemModel

+ (instancetype)modelWithString:(NSString *)str
{
    TagItemModel *model = [[self alloc]init];
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


@interface TagItem ()


@end

@implementation TagItem

@synthesize indexPath;

- (instancetype)init
{
    if (self = [super init]) {
        _layout = [[MTHorizontalWaterFullLayout alloc]initWithDataes:self.dates maxWidth:300 itemHeight:[UIFont systemFontOfSize:14].lineHeight style:HorizontalWaterFullLayoutStyleRight];
    }
    return self;
}

- (CGFloat)heightOfCell{
    return self.layout.collectionViewContentSize.height;
}

- (NSString *)reuseableIdentierOfCell{
    extern NSString * TagCellTableViewCell_ReuseIdentifer;
    return TagCellTableViewCell_ReuseIdentifer;
}

- (NSMutableArray *)dates{
    if (_dates == nil) {
        NSMutableArray *array = @[@"足球",@"乒乓球",@"稀里哗啦",@"无所谓的啦",@"足球",@"乒乓球",@"稀里哗啦",@"无所谓的啦",@"足球",@"乒乓球",@"稀里哗啦",@"无所谓的啦",@"足球",@"乒乓球",@"稀里哗啦",@"无所谓的啦",@"足球",@"乒乓球",@"稀里哗啦",@"无所谓的啦"].mutableCopy;
        _dates = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TagItemModel *model = [TagItemModel modelWithString:obj];
            [_dates addObject:model];
        }];
        
    }
    return _dates;
}

@end
