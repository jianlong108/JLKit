//
//  WeatherTableViewCell.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/9/16.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "WeatherTableViewCell.h"
#import "UIImage+GIF.h"

NSString  * const WeatherTableViewCell_ReuseIdentifer = @"WeatherTableViewCell_ReuseIdentifer";

@interface WeatherTableViewCell()

@property(nonatomic, strong) UIImageView *weatherImgView;
@property(nonatomic, strong) UILabel *cityLabel;
@property(nonatomic, strong) UILabel *temperatureLabel;
@property(nonatomic, strong) UILabel *windLabel;

@end

@implementation WeatherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initlizeContentView];
    }
    return self;
}

- (void)_initlizeContentView
{
    self.contentView.backgroundColor = [[UIColor colorWithRed:96/255.0 green:185/255.0 blue:228/255.0 alpha:1.0f] colorWithAlphaComponent:0.3];
    [_weatherImgView removeFromSuperview];
    _weatherImgView = nil;
    _weatherImgView = [[UIImageView alloc]init];
//    UIImage *img = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537083671529&di=72a8e004179a898ac1804360b759f2e0&imgtype=0&src=http%3A%2F%2Fd.ifengimg.com%2Fw128%2Fp0.ifengimg.com%2Fpmop%2F2017%2F0619%2F86FCE612270A654ADA0333D2DC2F4C9C5A8BA346_size1006_w500_h260.gif"]]];
//    _weatherImgView.image = img;
    [self.contentView addSubview:_weatherImgView];
    
    [_temperatureLabel removeFromSuperview];
    _temperatureLabel = nil;
    _temperatureLabel = [[UILabel alloc]init];
    _temperatureLabel.textColor = [UIColor whiteColor];
    _temperatureLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:_temperatureLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _weatherImgView.frame = CGRectMake(5, 5, 180, 80);
    
    _temperatureLabel.frame = CGRectMake(CGRectGetMaxX(_weatherImgView.frame), CGRectGetMinY(_weatherImgView.frame), 100, 50);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpItem:(id<OTItemProtocol>)item
{
    _cellModel = (id<WeatherTableViewCellModelProtocol,OTItemProtocol>)item;
    _temperatureLabel.text = [NSString stringWithFormat:@"温度:%@",_cellModel.temperature];
}

@end
