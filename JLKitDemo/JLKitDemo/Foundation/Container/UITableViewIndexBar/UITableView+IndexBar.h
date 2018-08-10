//
//  UITableView+IndexBar.h
//  MiTalk
//
//  Created by 王建龙 on 2017/11/29.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//


#import "MTTableViewSectionIndexBar.h"

@interface UITableView (IndexBar)<
    MTTableViewSectionIndexBarDelegate
>

- (void)addCustomSectionTitles:(NSArray *)titles;

- (void)updateTitles:(NSArray *)tities;

- (void) hidenTitlesContentView;

- (void) showTitlesContentView;

@end
