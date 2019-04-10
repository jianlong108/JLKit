//
//  JLSetCell.h
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCellItem.h"
#import "OTProtocol.h"


typedef NS_OPTIONS(NSUInteger, ElementType) {
    ElementTypeContainMainImgView                  = 1 << 0,
    ElementTypeContainMainTitleLabel               = 1 << 1,
    ElementTypeContainSubTitleLabel                = 1 << 2,
    ElementTypeContainAccessoryImgView             = 1 << 3,
    ElementTypeContainAccessoryTitleLabel          = 1 << 4,
    ElementTypeContainAccessorySwitch              = 1 << 5,
    ElementTypeContainArrowImgView                 = 1 << 6,
};


extern NSString * const SimpleCell_ReuseIdentifer JLDeprecated("使用方法: +(NSString *)simpleCellReuseIdentiferForElementType: 替换生成");


@interface SimpleCell : UITableViewCell<OTCellProtocol>

/**主视图图像*/
@property (nonatomic, readonly) UIImageView *mainImgView;

/**标题容器*/
@property (nonatomic, readonly) UIView *titleContainer;

/**标题*/
@property (nonatomic, readonly) UILabel *titleLabel;

/**副标题*/
@property (nonatomic, readonly) UILabel *subTitleLabel;

/**分割线*/
@property (nonatomic, readonly) UIView *spliteLineView;

/**辅标题*/
@property (nonatomic, readonly) UILabel *accessoryLabel;

/**自定义辅助视图*/
@property (nonatomic, readonly) UIView *customAccessoryView;

/**辅助视图-开关*/
@property (nonatomic, readonly) UISwitch *switchView;

/**辅助视图-箭头*/
@property (nonatomic, readonly) UIImageView *arrowView;


@property (nonatomic, strong) id <SimpleCellDataProtocol> dataModel;


+ (NSString *)simpleCellReuseIdentiferForElementType:(ElementType)type;

@end
