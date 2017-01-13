//
//  JLTableView.h
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/12/26.
//  Copyright © 2016年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLTableView;

@protocol JLTableViewDelegate <NSObject,UITableViewDelegate>

- (void)JLTableView:(JLTableView *)tableView SwitchFromIndex:(NSUInteger)fromeIndex ToIndex:(NSUInteger)toIndex;

@end

@interface JLTableView : UITableView
/**代理*/
@property (nonatomic, weak)id <JLTableViewDelegate>delegate;

@end
