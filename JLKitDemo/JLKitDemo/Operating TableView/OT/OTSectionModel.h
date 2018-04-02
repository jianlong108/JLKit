//
//  OTGroupModel.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/17.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTProtocol.h"

@interface OTSectionModel : NSObject<OTSectionItemProtocol>

/** 头部标题*/
@property (nonatomic, copy) NSString *headerTitle;

/** 尾部标题*/
@property (nonatomic, copy) NSString *footerTitle;

/** 头部高度*/
@property (nonatomic, assign) CGFloat headerHeight;

/** 尾部高度*/
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, copy) NSMutableArray<id <OTItemProtocol> > *items;

@end
