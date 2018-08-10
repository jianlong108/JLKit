//
//  UITableView+IndexBar.m
//  MiTalk
//
//  Created by 王建龙 on 2017/11/29.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "UITableView+IndexBar.h"

#define indexBarId 20171130

@implementation UITableView (IndexBar)
- (void)addCustomSectionTitles:(NSArray *)titles{
    
    MTTableViewSectionIndexBar *indexBar = [self.superview viewWithTag:indexBarId];
    if (indexBar) {
        [indexBar updateTitles:titles];
    }else{
        indexBar = [[MTTableViewSectionIndexBar alloc] initWith:self andTitles:titles];
        indexBar.tag = indexBarId;
        indexBar.delegate = self;
    }
    
}

- (void)updateTitles:(NSArray *)tities
{
    MTTableViewSectionIndexBar *indexBar = [self.superview viewWithTag:indexBarId];
    indexBar.hidden = NO;
    [indexBar updateTitles:tities];
}

- (void)sectionIndexBar:(MTTableViewSectionIndexBar *)sectionIndexBar sectionDidSelected:(NSUInteger)index title:(NSString *)title{
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void) hidenTitlesContentView {
    [(MTTableViewSectionIndexBar *)[self.superview viewWithTag:indexBarId] setHidden:YES];
}

- (void) showTitlesContentView {
    [(MTTableViewSectionIndexBar *)[self.superview viewWithTag:indexBarId] setHidden:NO];
    
}
@end
