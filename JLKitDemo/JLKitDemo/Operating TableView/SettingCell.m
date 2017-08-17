//
//  JLSetCell.m
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "SettingCell.h"

NSString  * const settingCell_ReuseIdentifer = @"SettingCell_ReuseIdentifer";

@interface SettingCell()
/**
 *  箭头
 */
@property (nonatomic, strong) UIImageView *arrowView;
/**
 *  开关
 */
@property (nonatomic, strong) UISwitch *switchView;
/**
 *  标签
 */
@property (nonatomic, strong) UILabel *labelView;

@property(nonatomic,strong) SettingItem *item;

@end

@implementation SettingCell
- (UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    return _arrowView;
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UILabel *)labelView
{
    if (_labelView == nil) {
        _labelView = [[UILabel alloc] init];
        _labelView.bounds = CGRectMake(0, 0, 100, 30);
        _labelView.backgroundColor = [UIColor redColor];
    }
    return _labelView;
}

- (void)setUpItem:(SettingItem *)item
{
    _item = item;
    
    // 1.设置数据
    [self setupData];
    
    // 2.设置右边的内容
    [self setupRightContent];
}

/**
 *  设置右边的内容
 */
- (void)setupRightContent
{
    if ([self.item isKindOfClass:[SettingArrowItem class]]) { // 箭头
        self.accessoryView = self.arrowView;
    } else if ([self.item isKindOfClass:[SettingSwitchItem class]]) { // 开关
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([self.item isKindOfClass:[SettingLabelItem class]]) { // 标签
        self.accessoryView = self.labelView;
    } else {
        self.accessoryView = nil;
    }
}

/**
 *  设置数据
 */
- (void)setupData
{
    if (self.item.icon) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
    self.textLabel.text = self.item.title;
}

- (void)clickSwitch:(UISwitch *)sender{
    NSNumber *state = [NSNumber numberWithBool:[sender isOn]];
    if (self.item.option) {
        self.item.option(state);
    }
}

@end
