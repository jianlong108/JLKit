//
//  OTGroupModel.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/17.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "OTSectionModel.h"

@implementation OTSectionModel

- (CGFloat )heightOfGroupHeader
{
    return self.headerHeight;
}

- (CGFloat )heightOfGroupFooter
{
    return self.footerHeight;
}

- (NSString *)headerOfGroup
{
    return self.headerTitle;
}

- (NSString *)footerOfGroup
{
    return self.footerTitle;
}

- (NSArray<id<OTItemProtocol>> *)itemsOfSection
{
    return self.items;
}

- (NSMutableArray<id<OTItemProtocol>> *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
