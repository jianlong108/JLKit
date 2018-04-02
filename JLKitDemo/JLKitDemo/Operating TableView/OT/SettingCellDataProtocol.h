//
//  SettingCellDataProtocol.h
//  MiTalk
//
//  Created by wangjianlong on 2018/2/28.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol SettingCellDataProtocol <NSObject>

- (NSString *)titleLabelText;

@optional

- (NSString *)subTitleLabelText;

- (UIImage *)accessoryImage;
- (NSString *)accessoryImageSourece;

- (UIImage *)mainImage;
- (NSString *)mainImageSourece;

- (UIView *)customAccessoryView;

- (BOOL)showSwitchView;
- (BOOL)showArrowImgView;

- (BOOL)hiddenSpliteLineView;

@end
