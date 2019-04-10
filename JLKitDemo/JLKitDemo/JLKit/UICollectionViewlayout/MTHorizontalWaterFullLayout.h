//
//  MTHorizontalWaterFullLayout.h
//  MiTalk
//
//  Created by wangjianlong on 2018/4/2.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HorizontalWaterFullLayoutStyle) {
    HorizontalWaterFullLayoutStyleLeft,
    HorizontalWaterFullLayoutStyleRight
};

@protocol HorizontalWaterFullModelProtocol <NSObject>

- (CGFloat)widthForModel;

@end

@interface MTHorizontalWaterFullLayout : UICollectionViewLayout

@property (nonatomic, readonly) CGFloat maxWidth;

@property (nonatomic, readonly) NSMutableArray<id<HorizontalWaterFullModelProtocol>> *dataes;

- (instancetype)initWithDataes:(NSArray <id<HorizontalWaterFullModelProtocol>>*)dates maxWidth:(CGFloat)maxWidth itemHeight:(CGFloat)itemHeight style:(HorizontalWaterFullLayoutStyle)style;

- (instancetype)initWithDataes:(NSArray <id<HorizontalWaterFullModelProtocol>>*)dates maxWidth:(CGFloat)maxWidth itemHeight:(CGFloat)itemHeight;

- (void)setColumnSpacing:(CGFloat)columnSpacing rowSpacing:(CGFloat)rowSpacing edgeInsets:(UIEdgeInsets)edgeInsets;

@end
