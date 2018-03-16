//
//  IOS11Adapter.h
//  VansLive
//
//  Created by xinwei on 2017/11/3.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOS11Adapter : NSObject

+ (void)scrollViewContentInsetAmendment:(UIScrollView *)scrollView;
+ (void)tableViewCancelEstimatedSeriesFunction:(UITableView *)tableView;

@end
