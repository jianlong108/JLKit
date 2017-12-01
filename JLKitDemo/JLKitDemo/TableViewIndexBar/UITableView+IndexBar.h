//
//  UITableView+IndexBar.h
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/1.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewIndexBar.h"

@interface UITableView (IndexBar)<
    UITableViewIndexBarDelegate
>

/**
 @wargning一定要确保调用此方法时，tableview。superview存在
 */
- (void)addCustomSectionTitles:(NSArray *)titles;

- (void)updateTitles:(NSArray *)tities;

- (void) hidenTitlesContentView;

- (void) showTitlesContentView;

@end
