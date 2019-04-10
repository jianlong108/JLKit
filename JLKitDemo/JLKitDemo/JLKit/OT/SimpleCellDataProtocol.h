//
//  SettingCellDataProtocol.h
//  MiTalk
//
//  Created by wangjianlong on 2018/2/28.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol SimpleCellDataProtocol <NSObject>

- (NSString *)titleLabelText_protocol;

@optional

- (NSString *)subTitleLabelText_protocol;
- (NSString *)acceoryTitleLabelText_protocol;

- (UIImage *)accessoryImage_protocol;
- (NSString *)accessoryImageSourece_protocol;

- (UIImage *)mainImage_protocol;
- (NSString *)mainImageSourece_protocol;

- (UIView *)customAccessoryView_protocol;

- (BOOL)showSwitchView_protocol;
- (BOOL)showArrowImgView_protocol;

- (BOOL)hiddenSpliteLineView_protocol;
- (BOOL)selectionStyleNone_protocol;
- (BOOL)switchOn_protocol;
- (UIColor *)subTitleColor_protocol;
- (CGFloat) subTitleSize_protocol;
- (UIColor *)mainTitleColor_protocol;

@end
