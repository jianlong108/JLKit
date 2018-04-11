//
//  JLSetItemModel.m
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "SettingItem.h"

@interface SettingItem ()

@end

@implementation SettingItem

@synthesize indexPath,cellClickBlock,reuseableIdentierOfCell;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    SettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithIcon:nil title:title];
}


#pragma mark - OTItemProtocol

- (CGFloat)heightOfCell
{
    return self.cellHeight == 0 ? 49 : self.cellHeight;
}

#pragma mark - SettingCellDataProtocol

- (NSString *)titleLabelText
{
    return self.title;
}

@end


@implementation SettingSwitchItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title on:(BOOL)isOn
{
    SettingSwitchItem *item = [super itemWithIcon:icon title:title];
    item.on = isOn;
    return item;
}


#pragma mark - SettingCellDataProtocol

- (BOOL)showSwitchView
{
    return YES;
}

@end

@implementation SettingImgViewArrowItem

#pragma mark - SettingCellDataProtocol

- (BOOL)hiddenSpliteLineView
{
    return self.isHiddenSplitelineView;
}

- (BOOL)showArrowImgView
{
    return YES;
}
- (NSString *)accessoryImageSourece
{
    return self.accessoryImg;
}

@end

@implementation SettingMainImgViewItem

@end

@implementation SettingLabelArrowItem

- (CGFloat)heightOfCell
{
    CGFloat estimateHeight = [self.acceoryTitle boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.height;
    
    return  estimateHeight < 49 ? 49 : estimateHeight;
}

#pragma mark - SettingCellDataProtocol

- (NSString *)subTitleLabelText
{
    return self.acceoryTitle;
}

- (BOOL)showArrowImgView
{
    return YES;
}

@end

@implementation SettingLabelItem

#pragma mark - SettingCellDataProtocol

- (NSString *)subTitleLabelText
{
    return self.acceoryTitle;
}


@end

@implementation SettingArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    SettingArrowItem *item = [self itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass
{
    return [self itemWithIcon:nil title:title destVcClass:destVcClass];
}

#pragma mark - SettingCellDataProtocol

- (BOOL)showArrowImgView
{
    return YES;
}

@end

@implementation SettingCustomAccessoryViewItem



@end
