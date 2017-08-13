//
//  JLSetGroupModel.m
//  我的控件集合
//
//  Created by Wangjianlong on 16/1/7.
//  Copyright © 2016年 autohome. All rights reserved.
//

#import "JLSetGroupModel.h"

@implementation JLSetGroupModel

- (CGFloat )heightOfGroupHeader{
    return self.headerHeight;
}
- (CGFloat )heightOfGroupFooter{
    return self.footerHeight;
}
- (NSString *)headerOfGroup{
    return self.header;
}
- (NSString *)footerOfGroup{
    return self.footer;
}

- (NSArray<id<OTItemProtocol>> *)itemsOfGroup{
    return self.items;
}

@end
