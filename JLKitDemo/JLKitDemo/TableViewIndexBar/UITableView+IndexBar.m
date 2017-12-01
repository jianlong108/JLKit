//
//  UITableView+IndexBar.m
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/1.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "UITableView+IndexBar.h"


#define indexBarId 20171130

@implementation UITableView (IndexBar)
- (void)addCustomSectionTitles:(NSArray *)titles{
    
    UITableViewIndexBar *indexBar = [self.superview viewWithTag:indexBarId];
    if (indexBar) {
        [indexBar updateTitles:titles];
        indexBar.hidden = NO;
    }else{
        indexBar = [[UITableViewIndexBar alloc] initWith:self andTitles:titles];
        indexBar.tag = indexBarId;
        indexBar.delegate = self;
    }
    
}

- (void)updateTitles:(NSArray *)tities
{
    UITableViewIndexBar *indexBar = [self.superview viewWithTag:indexBarId];
    indexBar.hidden = NO;
    [indexBar updateTitles:tities];
}

- (void)sectionIndexBar:(UITableViewIndexBar *)sectionIndexBar sectionDidSelected:(NSUInteger)index title:(NSString *)title{
    if ([self.dataSource numberOfSectionsInTableView:self] > index) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
}

- (void) hidenTitlesContentView {
    [(UITableViewIndexBar *)[self.superview viewWithTag:indexBarId] setHidden:YES];
}

- (void) showTitlesContentView {
    [(UITableViewIndexBar *)[self.superview viewWithTag:indexBarId] setHidden:NO];
    
}

@end
