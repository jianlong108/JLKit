//
//  JLSetCell.m
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "SimpleCell.h"
#import "UIImageView+WebCache.h"
#import "SimpleCellItem.h"
#import "View+MASAdditions.h"

#define CellisEmptyMask         0
#define MainImageViewMask       1
#define MainTitleLabelMask      2
#define SubTitleLabelMask       4
#define AccessoryImgViewMask    8
#define AccessoryTitleLabelMask 16
#define AccessorySwitchMask     32
#define ArrowImgViewMask        64

NSString * const SimpleCell_ReuseIdentifer = @"SimpleCell_ReuseIdentifer";

@interface SimpleCell()

@property (nonatomic, strong) UIImageView *mainImgView;

@property (nonatomic, strong) UIView *titleContainer;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *accessoryLabel;

@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) UISwitch *switchView;

@property (nonatomic, strong) UIImageView *accessoryImgView;

@property (nonatomic, strong) UIView *spliteLineView;

@property (nonatomic, assign) ElementType type;

@end

@implementation SimpleCell

+ (NSString *)simpleCellReuseIdentiferForElementType:(ElementType)type
{
    return [NSString stringWithFormat:@"%@$$%lu",@"SimpleCell_ReuseIdentifer",type];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSArray *array = [reuseIdentifier componentsSeparatedByString:@"$$"];
    if (array.count < 2) return nil;
    NSString *typeStr = array.lastObject;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _type = (ElementType)typeStr.integerValue;
        [self initlizeContentViews];
        [self layoutContentViews];
    }
    return self;
}

- (void)initlizeContentViews
{
    if (_type == CellisEmptyMask) {
        return;
    }
    UIView *spliteLineView = [[UIView alloc]init];
    spliteLineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:spliteLineView];
    _spliteLineView = spliteLineView;
    
    if ((_type & MainImageViewMask) == MainImageViewMask) {
        [self.contentView addSubview:self.mainImgView];
    }
    
    BOOL haveMainTitle = ((_type & MainTitleLabelMask) == MainTitleLabelMask);
    BOOL haveSubTitle = ((_type & SubTitleLabelMask) == SubTitleLabelMask);
    
    if (haveMainTitle || haveSubTitle) {
        [self.contentView addSubview:self.titleContainer];
    }
    
    if (haveMainTitle) {
        [self.titleContainer addSubview:self.titleLabel];
    }
    
    if (haveSubTitle) {
        [self.titleContainer addSubview:self.subTitleLabel];
    }
    
    if ((_type & AccessorySwitchMask) == AccessorySwitchMask) {
        [self.contentView addSubview:self.switchView];
    }
    
    if ((_type & ArrowImgViewMask) == ArrowImgViewMask) {
        [self.contentView addSubview:self.arrowView];
    }
    
    if ((_type & AccessoryTitleLabelMask) == AccessoryTitleLabelMask) {
        [self.contentView addSubview:self.accessoryLabel];
    }
    if ((_type & AccessoryImgViewMask) == AccessoryImgViewMask) {
        [self.contentView addSubview:self.accessoryImgView];
    }
}


- (void)layoutContentViews
{
    [_spliteLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.leading.equalTo(self.contentView.mas_trailing).offset(15);
        make.trailing.equalTo(self.mas_trailing).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [_mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    
    [_titleContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_mainImgView) {
            make.leading.equalTo(_mainImgView.mas_trailing).offset(15);
            make.centerY.equalTo(_mainImgView);
        } else {
            make.leading.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }
        
        if (_subTitleLabel) {
            make.bottom.equalTo(_subTitleLabel);
        } else {
            make.bottom.equalTo(_titleLabel);
        }
        
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(_titleContainer);
        make.trailing.lessThanOrEqualTo(_titleContainer);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_titleContainer);
        if (_titleLabel) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(2.5);
        } else {
            make.top.equalTo(_titleContainer);
        }
        make.trailing.lessThanOrEqualTo(self.titleContainer);
    }];
    
    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-14);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_accessoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_arrowView) {
            make.trailing.equalTo(_arrowView.mas_leading).offset(-10);
        } else {
            make.trailing.equalTo(self.contentView).offset(-15);
        }
        
        make.centerY.equalTo(self.contentView);
        make.width.mas_lessThanOrEqualTo(200 * UI_SCALE_Width);
    }];

    [_accessoryImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!_arrowView.hidden) {
            make.trailing.equalTo(_arrowView.mas_leading).offset(-10);
        } else {
            make.trailing.equalTo(self.contentView).offset(-10);
        }
        
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setDataModel:(id<SimpleCellDataProtocol>)dataModel
{
    if (![_dataModel isEqual:dataModel]) {
        _dataModel = dataModel;
        // 1.设置右边的内容
        [self setUpSubviews];
    }
}

- (void)setUpSubviews
{
    //主标题
    _titleLabel.text = [_dataModel titleLabelText_protocol];
    
    //主标题颜色
    if ([_dataModel respondsToSelector:@selector(mainTitleColor_protocol)]) {
        _titleLabel.textColor = [_dataModel mainTitleColor_protocol];
    }
    //副标题
    if ([_dataModel respondsToSelector:@selector(subTitleLabelText_protocol)]) {
        _subTitleLabel.text = [_dataModel subTitleLabelText_protocol];
    }
    //主image
    if ([_dataModel respondsToSelector:@selector(mainImage_protocol)]) {
        _mainImgView.image = [_dataModel mainImage_protocol];
    }
    
    if ([_dataModel respondsToSelector:@selector(mainImageSourece_protocol)]) {
        NSString *imgURLStr = [_dataModel mainImageSourece_protocol];
        if ([imgURLStr hasPrefix:@"http"] || [imgURLStr hasPrefix:@"https"]) {
            [_mainImgView sd_setImageWithURL:[NSURL URLWithString:imgURLStr] placeholderImage:nil];
        }else{
            [_mainImgView setImage:[UIImage imageNamed:imgURLStr]];
        }
    }
    
    //分割线
    if ([_dataModel respondsToSelector:@selector(hiddenSpliteLineView_protocol)]) {
        _spliteLineView.hidden = [_dataModel hiddenSpliteLineView_protocol];
    }
    
    //辅助开关
    if ([_dataModel respondsToSelector:@selector(showSwitchView_protocol)]) {
        _switchView.hidden = ![_dataModel showSwitchView_protocol];
    }
    
    //辅助箭头view
    if ([_dataModel respondsToSelector:@selector(showArrowImgView_protocol)]) {
        _arrowView.hidden = ![_dataModel showArrowImgView_protocol];
        if (_arrowView.hidden) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;//禁止响应
        }
    }
    
    //辅助标题
    if ([_dataModel respondsToSelector:@selector(acceoryTitleLabelText_protocol)]) {
        _accessoryLabel.text = [_dataModel acceoryTitleLabelText_protocol];
        if (!IS_STR_NIL(_accessoryLabel.text)) {
            _accessoryLabel.hidden = NO;
        } else {
            _accessoryLabel.hidden = YES;
        }
    }
    //辅助标题大小
    if ([_dataModel respondsToSelector:@selector(subTitleSize_protocol)]) {
        _accessoryLabel.font = [UIFont systemFontOfSize:[_dataModel subTitleSize_protocol]];
    }
    
    //辅助标题颜色
    if ([_dataModel respondsToSelector:@selector(subTitleColor_protocol)]) {
        self.accessoryLabel.textColor = [_dataModel subTitleColor_protocol];
    }

    //辅助视图-图片
    if ([_dataModel respondsToSelector:@selector(accessoryImage_protocol)]) {
        self.accessoryImgView.image = [_dataModel accessoryImage_protocol];
        
    }
    if ([_dataModel respondsToSelector:@selector(accessoryImageSourece_protocol)]) {
        NSString *imgURLStr = [_dataModel accessoryImageSourece_protocol];
        if ([imgURLStr hasPrefix:@"http"] || [imgURLStr hasPrefix:@"https"]) {
            [self.accessoryImgView sd_setImageWithURL:[NSURL URLWithString:imgURLStr] placeholderImage:nil];
            
        }else{
            [self.accessoryImgView setImage:[UIImage imageNamed:imgURLStr]];
            
        }
    }
    
    if ([_dataModel respondsToSelector:@selector(customAccessoryView_protocol)]) {
        self.accessoryView = [_dataModel customAccessoryView_protocol];
    }
    
    if ([_dataModel respondsToSelector:@selector(switchOn_protocol)]) {
        [_switchView setOn:[_dataModel switchOn_protocol] animated:NO];
    }

    if ([_dataModel respondsToSelector:@selector(selectionStyleNone_protocol)]) {
        if([_dataModel selectionStyleNone_protocol]) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;//含switch控件的cell 点击cell不变灰
        }
    }
}


- (void)setUpItem:(id)item
{
    self.dataModel = item;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _titleLabel.text = @"";
    _dataModel = nil;
}

- (void)clickSwitch:(UISwitch *)sender
{
    NSNumber *state = [NSNumber numberWithBool:[sender isOn]];
    SimpleCellSwitchItem *switchItem = ((SimpleCellSwitchItem *)self.dataModel);
    if (switchItem.switchClickBlock) {
        switchItem.switchClickBlock(state,nil);
    }
}

#pragma mark - subViews

- (UIImageView *)mainImgView
{
    if (_mainImgView == nil) {
        _mainImgView = [[UIImageView alloc]init];
        _mainImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _mainImgView;
}

- (UIView *)titleContainer{
    if (!_titleContainer) {
        _titleContainer = [[UIView alloc] init];
    }
    return _titleContainer;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = [UIFont systemFontOfSize:13.0];
        _subTitleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return _subTitleLabel;
}

- (UIImageView *)accessoryImgView
{
    if (_accessoryImgView == nil) {
        _accessoryImgView = [[UIImageView alloc] init];
        _accessoryImgView.contentMode = UIViewContentModeCenter;
    }
    return _accessoryImgView;
}

- (UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_b_normal"]];
        _arrowView.contentMode = UIViewContentModeCenter;
    }
    return _arrowView;
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
        _switchView.hidden = YES;
    }
    return _switchView;
}

- (UILabel *)accessoryLabel
{
    if (_accessoryLabel == nil) {
        _accessoryLabel = [[UILabel alloc] init];
        _accessoryLabel.bounds = CGRectMake(0, 0, 100, 30);
        _accessoryLabel.font = [UIFont systemFontOfSize:13.0];
        _accessoryLabel.textAlignment = NSTextAlignmentRight;
        _accessoryLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _accessoryLabel.hidden = YES;
    }
    return _accessoryLabel;
}

@end
