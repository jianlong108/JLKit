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

@interface SimpleItem : NSObject<
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

@interface SettingSwitchItem : SimpleItem

/**开关是否开启*/
@property (nonatomic, assign)  BOOL on;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title on:(BOOL)isOn;

@end

@interface SettingImgViewArrowItem : SimpleItem

@property (nonatomic, strong) NSString *accessoryImg;

@end

@interface SettingMainImgViewItem : SimpleItem

@property (nonatomic, strong) UIImage *mainImg;

@end

@interface SettingLabelArrowItem : SimpleItem

/**辅助标题*/
@property (nonatomic, copy) NSString *acceoryTitle;
@end

@interface SettingLabelItem : SimpleItem

/**辅助标题*/
@property (nonatomic, copy) NSString *acceoryTitle;
@end

@interface SettingArrowItem : SimpleItem
/**
 *  点击这行cell需要跳转的控制器
 */
@property (nonatomic, assign) Class destVcClass;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;

@end

@interface SettingCustomAccessoryViewItem : SimpleItem

@property (nonatomic, strong) UIView *customAccessoryView;

@end
