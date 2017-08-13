//
//  JLSetItemModel.h
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTPotocol.h"

typedef void (^JLSettingItemOption)(id);

@interface JLSetItem : NSObject<OTItemProtocol>
/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  点击那个cell需要做什么事情
 */
@property (nonatomic, copy) JLSettingItemOption option;



+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title;
@end
