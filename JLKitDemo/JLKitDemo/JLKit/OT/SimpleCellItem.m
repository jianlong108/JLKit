//
//  JLSetItemModel.m
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "SimpleCellItem.h"

@implementation SimpleCellItem

@synthesize indexPath,cellClickBlock, switchClickBlock, reuseableIdentierOfCell;

+ (instancetype)itemWithTitle:(NSString *)title
{
    SimpleCellItem *item = [[self alloc] init];
    item.title = title;
    return item;
}


- (CGFloat)heightOfCell
{
    return self.cellHeight == 0 ? 52 : self.cellHeight;
}


- (NSString *)titleLabelText_protocol
{
    return self.title;
}

- (BOOL)hiddenSpliteLineView_protocol
{
    return self.isHiddenSplitelineView;
}

@end


@implementation SimpleCellArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    SimpleCellArrowItem *item = [self itemWithTitle:title];
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass
{
    return [self itemWithIcon:nil title:title destVcClass:destVcClass];
}

- (instancetype)init
{
    if (self = [super init]) {
        _showArrowView = YES;
    }
    return self;
}

- (BOOL)showArrowImgView_protocol
{
    return _showArrowView;
}

@end


@implementation SimpleCellLabelArrowItem

- (CGFloat)heightOfCell
{
    
    return  self.cellHeight < 52 ? 52 : self.cellHeight;
}


- (NSString *)acceoryTitleLabelText_protocol
{
    return self.acceoryTitle;
}

- (UIColor *)subTitleColor_protocol
{
    return self.acceoryTitleColor == 0 ? [[UIColor blackColor] colorWithAlphaComponent:0.3] : self.acceoryTitleColor;
}

- (UIColor *)mainTitleColor_protocol {
    return self.titleColor == 0 ? [[UIColor blackColor] colorWithAlphaComponent:0.8] : self.titleColor;
}

- (CGFloat) subTitleSize_protocol
{
    return self.acceoryTitleSize == 0 ? 13 : self.acceoryTitleSize;
}

@end


@implementation SimpleCellSwitchItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title on:(BOOL)isOn
{
    SimpleCellSwitchItem *item = [super itemWithTitle:title];
    item.on = isOn;
    return item;
}


#pragma mark - SettingCellDataProtocol
- (NSString *)subTitleLabelText_protocol
{
    return self.subTitle;
}
- (NSString *)acceoryTitleLabelText_protocol
{
    return self.acceoryTitle;
}

- (BOOL)showSwitchView_protocol
{
    return YES;
}

- (BOOL)selectionStyleNone_protocol
{
    return YES;
}

-(BOOL)switchOn_protocol
{
    return self.on;
}

#pragma mark - OTItemProtocol
- (CGFloat)heightOfCell
{
    return  self.cellHeight == 0 ? 63 : self.cellHeight;
}

@end

@implementation SimpleCellAcceoImgAndArrowItem

#pragma mark - SettingCellDataProtocol

- (BOOL)showArrowImgView_protocol
{
    return YES;
}

- (NSString *)accessoryImageSourece_protocol
{
    return self.accessoryImg;
}

@end



@implementation SimpleCellMainImgArrowViewItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    SimpleCellMainImgArrowViewItem *item = [[self alloc] init];
    item.mainImgViewSize = CGSizeMake(23,23);
    item.mainImgName = icon;
    item.title = title;
    return item;
}

- (UIImage *)mainImage_protocol
{
    if (!_mainImage) {
        return [UIImage imageNamed:self.mainImgName];
    }
    
    return _mainImage;
}

- (NSString *)subTitleLabelText_protocol
{
    return self.subTitleText;
}

@end



@implementation SimpleCellCustomAccessoryViewItem

- (UIColor *)mainTitleColor_protocol
{
    return self.titleColor == 0 ? [[UIColor blackColor] colorWithAlphaComponent:0.8] : self.titleColor;
}

- (UIView *)customAccessoryView_protocol
{
    return self.customAccessoryView;
}

@end
