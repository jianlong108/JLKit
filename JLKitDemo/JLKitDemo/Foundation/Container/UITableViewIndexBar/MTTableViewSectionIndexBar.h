//
//  MTTableViewSectionIndexBar.h
//  MiTalk
//
//  Created by 王建龙 on 2017/11/29.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTTableViewSectionIndexBar;

@protocol MTTableViewSectionIndexBarDelegate <NSObject>

@optional

- (void)sectionIndexBar:(MTTableViewSectionIndexBar *)sectionIndexBar sectionDidSelected:(NSUInteger)index title:(NSString *) title;

@end

@interface MTTableViewSectionIndexBar : UIView

@property (nonatomic,readonly) NSArray *titles;

@property (nonatomic, weak) id<MTTableViewSectionIndexBarDelegate> delegate;

@property (nonatomic, strong) NSString *textColorKey;

@property (nonatomic, strong) UIFont *letterFont;

@property (nonatomic, strong) NSString *fontstyleKey;

- (instancetype)initWith:(UITableView *)view andTitles:(NSArray *)titleArray;

- (void)updateTitles:(NSArray *)titleArray;

@end
