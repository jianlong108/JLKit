//
//  JLSetCell.m
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "SimpleCell.h"
#import "GlobalFunction.h"
//#import "UIImageView+WebCache.h"

NSString  * const SimpleCell_ReuseIdentifer = @"SimpleCell_ReuseIdentifer";

@interface SimpleCell()

/**
 主视图图像
 */
@property (nonatomic, strong) UIImageView *mainImgView;

/**
 主标题
 */
@property (nonatomic, strong,readwrite) UILabel *titleLabel;

/**
 *  辅助视图-标题
 */
@property (nonatomic, strong) UILabel *accessoryLabel;

/**
 *  辅助视图-箭头
 */
@property (nonatomic, strong) UIImageView *arrowView;

/**
 *  辅助视图-开关
 */
@property (nonatomic, strong) UISwitch *switchView;

/**
 *  辅助视图-图片
 */
@property (nonatomic, strong) UIImageView *accessoryImgView;

/**
 自定义辅助视图
 */
@property (nonatomic, strong) UIView *customAccessoryView;

/**
 分割线
 */
@property (nonatomic, weak) UIView *spliteLineView;


@end

@implementation SimpleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initlizeContentViews];
    }
    return self;
}

- (void)setDataModel:(id<SettingCellDataProtocol>)dataModel
{
    if (![_dataModel isEqual:dataModel]) {
        _dataModel = dataModel;
        // 1.设置右边的内容
        [self setUpSubviews];
        [self layoutContentViews];
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutContentViews];
}

- (void)setUpSubviews
{
    //主标题
    _titleLabel.text = [_dataModel titleLabelText];
    
    //主image
    if ([_dataModel respondsToSelector:@selector(mainImage)]) {
        [self.contentView addSubview:self.mainImgView];
        
        self.mainImgView.image = [_dataModel mainImage];
    }
    
    if ([_dataModel respondsToSelector:@selector(mainImageSourece)]) {
        [self.contentView addSubview:self.mainImgView];
        
        NSString *imgURLStr = [_dataModel mainImageSourece];
        if ([imgURLStr hasPrefix:@"http"] || [imgURLStr hasPrefix:@"https"]) {
//            [self.mainImgView sd_setImageWithURL:[NSURL URLWithString:imgURLStr] placeholderImage:nil];
            
        }else{
            [self.mainImgView setImage:[UIImage imageNamed:imgURLStr]];
            
        }
    }
    
    //分割线
    if ([_dataModel respondsToSelector:@selector(hiddenSpliteLineView)]) {
        [self.contentView addSubview:self.spliteLineView];
        self.spliteLineView.hidden = [_dataModel hiddenSpliteLineView];
    }
    
    //辅助开关
    if ([_dataModel respondsToSelector:@selector(showSwitchView)]) {
        [self.contentView addSubview:self.switchView];
        self.switchView.hidden = ![_dataModel showSwitchView];
    }
    
    //辅助箭头view
    if ([_dataModel respondsToSelector:@selector(showArrowImgView)]) {
        [self.contentView addSubview:self.arrowView];
        self.arrowView.hidden = ![_dataModel showArrowImgView];
    }
    
    //辅助标题
    if ([_dataModel respondsToSelector:@selector(subTitleLabelText)]) {
        [self.customAccessoryView addSubview:self.accessoryLabel];
        self.accessoryLabel.text = [_dataModel subTitleLabelText];
        self.accessoryLabel.hidden = NO;
    }
    
    //辅助视图-图片
    if ([_dataModel respondsToSelector:@selector(accessoryImage)]) {
        [self.customAccessoryView addSubview:self.accessoryImgView];
        self.accessoryImgView.image = [_dataModel accessoryImage];
        
    }
    if ([_dataModel respondsToSelector:@selector(accessoryImageSourece)]) {
        [self.customAccessoryView addSubview:self.accessoryImgView];
        NSString *imgURLStr = [_dataModel accessoryImageSourece];
        if ([imgURLStr hasPrefix:@"http"] || [imgURLStr hasPrefix:@"https"]) {
//            [self.accessoryImgView sd_setImageWithURL:[NSURL URLWithString:imgURLStr] placeholderImage:nil];
            
        }else{
            [self.accessoryImgView setImage:[UIImage imageNamed:imgURLStr]];
            
        }
    }
    
    if ([_dataModel respondsToSelector:@selector(customAccessoryView)]) {
        self.accessoryView = [_dataModel customAccessoryView];
    }
    
}


- (void)setUpItem:(id)item
{
    self.dataModel = item;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_mainImgView removeFromSuperview];
    _mainImgView = nil;
    [_arrowView removeFromSuperview];
    _arrowView = nil;
    [_switchView removeFromSuperview];
    _switchView = nil;
    [_accessoryLabel removeFromSuperview];
    _accessoryLabel = nil;
    [_accessoryImgView removeFromSuperview];
    _accessoryImgView = nil;
    _titleLabel.text = @"";
    _dataModel = nil;
}


- (void)initlizeContentViews
{
    UIView *spliteLineView = [[UIView alloc]init];
    spliteLineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self addSubview:spliteLineView];
    _spliteLineView = spliteLineView;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIView *customAccessoryView = [[UIView alloc]init];
    [self.contentView addSubview:customAccessoryView];
    _customAccessoryView = customAccessoryView;
    
}

- (void)layoutContentViews
{
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    _titleLabel.frame = CGRectMake(10, 10, 200, 20);
    _spliteLineView.frame = CGRectMake(0, maxY - 0.5, w, 0.5);
//    [_mainImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.left.equalTo(self.contentView).offset(10);
//        make.size.mas_equalTo(CGSizeMake(34, 40));
//    }];
//    
//    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        if (_mainImgView) {
//            make.centerY.equalTo(self.contentView);
//            make.left.equalTo(_mainImgView.mas_right).offset(10);
//        } else {
//            make.centerY.equalTo(self.contentView);
//            make.left.equalTo(self.contentView).offset(10);
//        }
//    }];
//    
//    [_spliteLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self);
//        make.left.equalTo(self.contentView.mas_left).offset(10);
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.height.mas_equalTo(0.5);
//    }];
//    
//    [_customAccessoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.top.bottom.equalTo(self);
//        make.left.equalTo(_titleLabel.mas_right).offset(10);
//    }];
//    
//    [_arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_customAccessoryView).offset(-16);
//        make.centerY.equalTo(_customAccessoryView);
//    }];
//    
//    [_accessoryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        if (_arrowView) {
//            make.right.equalTo(_arrowView.mas_left).offset(-10);
//        } else {
//            make.right.equalTo(_customAccessoryView).offset(-10);
//        }
//        
//        make.centerY.equalTo(_customAccessoryView);
//        make.width.mas_lessThanOrEqualTo(200*UI_SCALE_Width);
//    }];
//    
//    [_accessoryImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        if (_arrowView) {
//            make.right.equalTo(_arrowView.mas_left).offset(-10);
//        } else {
//            make.right.equalTo(_customAccessoryView).offset(-10);
//        }
//        
//        make.centerY.equalTo(_customAccessoryView);
//    }];
//    
//    [_switchView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_customAccessoryView).offset(-10);
//        make.centerY.equalTo(_customAccessoryView);
//    }];
}

- (void)clickSwitch:(UISwitch *)sender
{
    NSNumber *state = [NSNumber numberWithBool:[sender isOn]];
    if (self.item.cellClickBlock) {
        self.item.cellClickBlock(state,nil);
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
        _accessoryLabel.numberOfLines = 0;
        _accessoryLabel.bounds = CGRectMake(0, 0, 100, 30);
        _accessoryLabel.font = [UIFont systemFontOfSize:15.0];
        _accessoryLabel.textAlignment = NSTextAlignmentRight;
        _accessoryLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        _accessoryLabel.hidden = YES;
    }
    return _accessoryLabel;
}

@end
