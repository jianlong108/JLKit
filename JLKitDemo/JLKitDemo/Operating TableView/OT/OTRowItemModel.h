//
//  OTRowItemModel.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/27.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTProtocol.h"

@interface OTRowItemModel : NSObject<OTItemProtocol>

@property (nonatomic, copy) NSString *cellIdentier;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) NSString *title;

@end
