//
//  OTRowItemModel.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/27.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "OTRowItemModel.h"

@implementation OTRowItemModel

- (NSString *)reuseableIdentierOfCell
{
    return self.cellIdentier;
}


- (CGFloat)heightOfCell
{
    return self.cellHeight;
}

@end
