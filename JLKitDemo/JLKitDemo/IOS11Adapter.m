//
//  IOS11Adapter.m
//  VansLive
//
//  Created by xinwei on 2017/11/3.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "IOS11Adapter.h"

@implementation IOS11Adapter

+ (void)scrollViewContentInsetAmendment:(UIScrollView *)scrollView {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#endif
}

+ (void)tableViewCancelEstimatedSeriesFunction:(UITableView *)tableView {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
  
#endif
}

@end
