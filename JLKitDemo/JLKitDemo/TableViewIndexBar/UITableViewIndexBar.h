//
//  UITableViewIndexBar.h
//  JLKitDemo
//
//  Created by wangjianlong on 2017/12/1.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UITableViewIndexBar;

@protocol UITableViewIndexBarDelegate <NSObject>

@optional

- (void)sectionIndexBar:(UITableViewIndexBar *)sectionIndexBar sectionDidSelected:(NSUInteger)index title:(NSString *) title;

@end

@interface UITableViewIndexBar : UIView

@property (nonatomic,readonly)NSArray *titles;

@property (nonatomic, weak)   id<UITableViewIndexBarDelegate> delegate;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIFont *letterFont;


/**
 @wargning一定要确保调用此方法时，tableview。superview存在
 */
- (instancetype)initWith:(UITableView *)view andTitles:(NSArray *)titleArray;

- (void)updateTitles:(NSArray *)titleArray;

@end

