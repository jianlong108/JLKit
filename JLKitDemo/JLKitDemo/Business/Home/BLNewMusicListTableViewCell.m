//
//  BLNewMusicListTableViewCell.m
//  BLCommunityModule
//
//  Created by JL on 2023/5/10.
//

#import "BLNewMusicListTableViewCell.h"
#import <Masonry/Masonry.h>

@implementation BLNewMusicListTableViewCellModel

@end

@interface BLNewMusicListTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIControl *playButton;
@property (nonatomic, strong) UIImageView *playIcon;
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) UIButton *goOriginSoundButton;
@property (nonatomic, strong) UIButton *useButton;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic) UILabel *useingLabel;
@property (nonatomic, strong) MASConstraint *useingLabelLeftCons;
@property (nonatomic, strong) MASConstraint *useBtnRightCons;
@end


@implementation BLNewMusicListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (BOOL)hiddenGoOriginSoundEntranceView
{
    return NO;
}
- (BOOL)hiddenFavoriteEntranceView
{
    return NO;
}

- (void)setupView {
    self.layer.masksToBounds = YES;
    self.coverImgView = [[UIImageView alloc] init];
    self.coverImgView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    self.coverImgView.layer.cornerRadius = 6;
    self.coverImgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.coverImgView];
    
    self.playIcon = [[UIImageView alloc] initWithImage:[BLNewMusicListTableViewCell imageWithNamed:@"ic_music_play"]];
    [self.contentView addSubview:self.playIcon];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.hidesWhenStopped = YES;
    [self.indicatorView stopAnimating];
    [self.contentView addSubview:self.indicatorView];
   
    self.useButton = [[UIButton alloc] init];
    self.useButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
    self.useButton.layer.cornerRadius = 14;
    self.useButton.layer.masksToBounds = YES;
    [self.useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.useButton setTitle:@"Use" forState:UIControlStateNormal];
    [self.useButton addTarget:self action:@selector(onTapUseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.useButton];
  
    self.goOriginSoundButton = [[UIButton alloc] init];
    self.goOriginSoundButton.hidden = self.hiddenGoOriginSoundEntranceView;
    [self.goOriginSoundButton setImage:[BLNewMusicListTableViewCell imageWithNamed:@"ic_gosound"] forState:UIControlStateNormal];
    [self.goOriginSoundButton setImage:[BLNewMusicListTableViewCell imageWithNamed:@"ic_gosound_disable"] forState:UIControlStateDisabled];
    [self.goOriginSoundButton addTarget:self action:@selector(onGoToOriginSoundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.goOriginSoundButton];

    self.favoriteButton = [[UIButton alloc] init];
    self.favoriteButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.favoriteButton.hidden = self.hiddenFavoriteEntranceView;
    [self.favoriteButton setImage:[BLNewMusicListTableViewCell imageWithNamed:@"ic_favorite"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[BLNewMusicListTableViewCell imageWithNamed:@"ic_music_favorite_high"] forState:UIControlStateSelected];
    [self.favoriteButton setImage:[BLNewMusicListTableViewCell imageWithNamed:@"ic_music_favorite_high_unable"] forState:UIControlStateDisabled];
    [self.favoriteButton addTarget:self action:@selector(onGoToFavoriteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.favoriteButton];
 
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"sound sound";
    self.titleLabel.textColor = [UIColor purpleColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titleLabel];

    self.authorLabel = [[UILabel alloc] init];
    self.authorLabel.text = @"wjl";
    self.authorLabel.textColor = [[UIColor greenColor] colorWithAlphaComponent:0.7];
    self.authorLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.authorLabel];

    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.text = @"01:10";
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.timeLabel.textColor = [UIColor purpleColor];
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.timeLabel];

    self.useingLabel = [[UILabel alloc] init];
    self.useingLabel.text = @"Using";
//    self.useingLabel.contentInsets = UIEdgeInsetsMake(2, 3, 2, 3);
    self.useingLabel.hidden = YES;
    [self.useingLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.useingLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.useingLabel.textColor = [UIColor purpleColor];
    self.useingLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightMedium];
    self.useingLabel.backgroundColor = [UIColor purpleColor];
    self.useingLabel.layer.cornerRadius = 9;
    self.useingLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.useingLabel];
    
    self.playButton = [[UIControl alloc] init];
    self.playButton.backgroundColor = [UIColor clearColor];
    [self.playButton addTarget:self action:@selector(onTapPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.playButton];
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.offset(16);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.leading.offset(16);
        make.trailing.equalTo([self rightLayoutReferenceView].mas_leading);
    }];
    
    [self.playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverImgView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.useingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        self.useingLabelLeftCons = make.leading.equalTo(self.titleLabel.mas_trailing).offset(3);
        make.trailing.lessThanOrEqualTo([self rightLayoutReferenceView].mas_leading).offset(-12);
        make.height.mas_equalTo(18);
    }];
    [self.useingLabelLeftCons deactivate];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverImgView);
    }];
    
    [self.useButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        self.useBtnRightCons = make.trailing.equalTo(self.contentView.mas_trailing).offset(70);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(70, 28));
    }];
    UIView *rightConsultView = self.useButton;
    if (!self.hiddenGoOriginSoundEntranceView) {
        [self.goOriginSoundButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(rightConsultView.mas_leading).offset(-16);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        rightConsultView = self.goOriginSoundButton;
    }
    if (!self.hiddenFavoriteEntranceView) {
        [self.favoriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(rightConsultView.mas_leading).offset(-16);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
    }
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.coverImgView.mas_trailing).offset(12);
        make.top.equalTo(self.coverImgView).offset(6);
        make.trailing.lessThanOrEqualTo([self rightLayoutReferenceView].mas_leading).offset(-3);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.leading.equalTo(self.titleLabel);
        make.trailing.equalTo(self.timeLabel.mas_leading);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
//        make.leading.equalTo(self.authorLabel.mas_trailing).offset(4);
//        make.leading.greaterThanOrEqualTo(self.titleLabel);
//        make.trailing.lessThanOrEqualTo([self rightLayoutReferenceView].mas_leading).offset(-12);
    }];
}

- (void)onTapUseBtn {

}

- (void)onGoToOriginSoundButtonClick:(UIControl *)sender {

}

- (void)onGoToFavoriteButtonClick:(UIControl *)sender {
    sender.selected = !sender.selected;

}

- (void)onTapPlayBtn:(UIControl *)sender {
    if ([self.delegate respondsToSelector:@selector(newMusicListCellDidClickPlayButton:model:)]) {
        [self.delegate newMusicListCellDidClickPlayButton:self model:self.model];
    }
}

- (void)setIsPlaying:(BOOL)isPlaying {
    if (_isPlaying != isPlaying) {
        _isPlaying = isPlaying;
        if (isPlaying) {
            self.playIcon.image = [BLNewMusicListTableViewCell imageWithNamed:@"ic_pause"];
        } else {
            self.playIcon.image = [BLNewMusicListTableViewCell imageWithNamed:@"ic_music_play"];
        }
        [self updateUIWhenPlay:isPlaying completion:^(BOOL finish) {
            if (finish) {
                
            }
        }];
    }
}

- (void)setIsInUse:(BOOL)isInUse {
    _isInUse = isInUse;
    self.useingLabel.hidden = !isInUse;
    if (self.useingLabel.hidden) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.lessThanOrEqualTo([self rightLayoutReferenceView].mas_leading).offset(-12);
        }];
        [self.useingLabelLeftCons deactivate];
    } else {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.lessThanOrEqualTo([self rightLayoutReferenceView].mas_leading).offset(-(self.useingLabel.intrinsicContentSize.width+3));
        }];
        [self.useingLabelLeftCons activate];
    }
    [self.contentView layoutIfNeeded];
}




- (void)prepareForReuse
{
    [super prepareForReuse];
//    self.useBtnRightCons.offset = 70;
//    [self.useingLabelLeftCons deactivate];
//    self.coverImgView.image = nil;
//    _isPlaying = NO;
    self.playIcon.image = [BLNewMusicListTableViewCell imageWithNamed:@"ic_music_play"];
//    self.timeLabel.textColor = [UIColor purpleColor];
//    self.authorLabel.textColor = [UIColor purpleColor];
//    self.titleLabel.textColor = [UIColor purpleColor];
//    self.goOriginSoundButton.enabled = YES;
//    self.favoriteButton.enabled = YES;
//    self.playIcon.hidden = NO;
//    self.isInUse = NO;
}

- (UIView *)rightLayoutReferenceView
{
    if ([self hiddenFavoriteEntranceView]) return self.useButton;
    return self.favoriteButton;
}

- (void)updateUIWhenPlay:(BOOL)play completion:(void(^)(BOOL))completion
{
    if (play) {
//        [self.contentView setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.2 animations:^{
            self.useBtnRightCons.offset = -16;
            [self.contentView layoutIfNeeded];
        } completion:completion];
    } else {
//        [self.contentView setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.2 animations:^{
        
            self.useBtnRightCons.offset = 70;
            [self.contentView layoutIfNeeded];
        } completion:completion];
    }
}

+ (CGFloat)rowHeight {
    return 75;
}

+ (UIImage *)imageWithNamed:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleWithPath:[NSBundle mainBundle].resourcePath];
    UIImage *img = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return img;
}

- (void)setModel:(BLNewMusicListTableViewCellModel *)model{
    _model = model;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isPlaying = _model.cellIsPlaying;
//    });

}

@end
