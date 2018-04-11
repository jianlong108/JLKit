//
//  JLSetItemModel.h
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTProtocol.h"
#import "SettingCellDataProtocol.h"

typedef NS_OPTIONS(NSUInteger, CellItemElementType) {
    CellItemElementTypeAccessoryTitleLabel = 0,
    CellItemElementTypeArrow               = 1 << 0,
    CellItemElementTypeAccessoryLabel      = 1 << 1,
    CellItemElementTypeAccessoryImgView    = 1 << 2,
    CellItemElementTypeMainImgView         = 1 << 3,
    CellItemElementTypeSwitch              = 1 << 4,
    CellItemElementTypeSimple = (CellItemElementTypeAccessoryTitleLabel | CellItemElementTypeArrow)
};

@interface SettingItem : NSObject<
    OTItemProtocol,
    SettingCellDataProtocol
>
/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**是否显示分割线*/
@property (nonatomic, assign)  BOOL isHiddenSplitelineView;

/**cell 高度*/
@property (nonatomic, assign)  CGFloat cellHeight;


+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;

+ (instancetype)itemWithTitle:(NSString *)title;

@end

@interface SettingSwitchItem : SettingItem

/**开关是否开启*/
@property (nonatomic, assign)  BOOL on;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title on:(BOOL)isOn;

@end

@interface SettingImgViewArrowItem : SettingItem

@property (nonatomic, strong) NSString *accessoryImg;

@end

@interface SettingMainImgViewItem : SettingItem

@property (nonatomic, strong) UIImage *mainImg;

@end

@interface SettingLabelArrowItem : SettingItem

/**辅助标题*/
@property (nonatomic, copy) NSString *acceoryTitle;
@end

@interface SettingLabelItem : SettingItem

/**辅助标题*/
@property (nonatomic, copy) NSString *acceoryTitle;
@end

@interface SettingArrowItem : SettingItem
/**
 *  点击这行cell需要跳转的控制器
 */
@property (nonatomic, assign) Class destVcClass;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;

@end

@interface SettingCustomAccessoryViewItem : SettingItem

@property (nonatomic, strong) UIView *customAccessoryView;

@end
