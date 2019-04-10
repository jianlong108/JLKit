//
//  JLSetItemModel.h
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTProtocol.h"
#import "SimpleCellDataProtocol.h"

/*
 只包含主标题
 */
@interface SimpleCellItem : NSObject<
    OTItemProtocol,
    SimpleCellDataProtocol
>

@property (nonatomic, copy) NSString *icon JLDeprecated("父类废除这个属性,改由子类实现");

//主标题
@property (nonatomic, copy) NSString *title;

//是否显示分割线
@property (nonatomic, assign)  BOOL isHiddenSplitelineView;

//cell 高度
@property (nonatomic, assign)  CGFloat cellHeight;

+ (instancetype)itemWithTitle:(NSString *)title;

@end

/*
 包含主标题, 箭头(可控制显示 by showArrowView)
 */
@interface SimpleCellArrowItem : SimpleCellItem

@property (nonatomic, assign) BOOL showArrowView;

@end

/*
 包含主标题, 辅助标题, 箭头(可控制显示 by showArrowView)
 */
@interface SimpleCellLabelArrowItem : SimpleCellArrowItem

/**辅助标题*/
@property (nonatomic, copy) NSString *acceoryTitle;

/**辅助标题大小*/
@property (nonatomic, assign) CGFloat acceoryTitleSize;

/**辅助标题颜色*/
@property (nonatomic, strong) UIColor *acceoryTitleColor;

/**标题颜色*/
@property (nonatomic, strong) UIColor *titleColor;

@end

/*
 包含主标题, 开关
 */
@interface SimpleCellSwitchItem : SimpleCellItem

/**开关是否开启*/
@property (nonatomic, assign)  BOOL on;

/**辅助标题*/
@property (nonatomic, copy) NSString *acceoryTitle;

/**副标题*/
@property (nonatomic, copy) NSString *subTitle;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title on:(BOOL)isOn;

@end


/*
 包含主标题, 辅助图片 箭头
 */
@interface SimpleCellAcceoImgAndArrowItem : SimpleCellItem

@property (nonatomic, strong) NSString *accessoryImg;

@end

/*
 包含主标题,主图片 辅助标题 箭头
 */
@interface SimpleCellMainImgArrowViewItem : SimpleCellLabelArrowItem

//local image name
@property (nonatomic, strong) NSString *mainImgName;
@property (nonatomic, strong) UIImage *mainImage;
/**mainImageView size  defatuleValue:(23,23)*/
@property (nonatomic, assign) CGSize mainImgViewSize;

/**副标题*/
@property (nonatomic, copy) NSString *subTitleText;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;

@end


/*
 包含主标题, 自定义辅助view 箭头
 */
@interface SimpleCellCustomAccessoryViewItem : SimpleCellArrowItem

@property (nonatomic, strong) UIView *customAccessoryView;

@property (nonatomic, strong) UIColor *titleColor;

@end
