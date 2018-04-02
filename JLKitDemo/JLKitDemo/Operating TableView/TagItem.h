//
//  TagItem.h
//  JLKitDemo
//
//  Created by wangjianlong on 2018/4/2.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTPotocol.h"
#import "MTHorizontalWaterFullLayout.h"

@interface TagItemModel :NSObject<HorizontalWaterFullModelProtocol>

@property (nonatomic, copy) NSString *str;

@end




@class MTHorizontalWaterFullLayout;

@interface TagItem : NSObject<OTItemProtocol>

@property (nonatomic, strong) MTHorizontalWaterFullLayout *layout;

@property (nonatomic, strong) NSMutableArray *dates;
@end
