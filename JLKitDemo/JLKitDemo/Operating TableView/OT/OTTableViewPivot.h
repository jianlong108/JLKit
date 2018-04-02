//
//  OTTableViewPivot.h
//  MiTalk
//
//  Created by 王建龙 on 2017/9/8.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTProtocol.h"

@interface OTTableViewPivot : NSObject<
    UITableViewDataSource,
    UITableViewDelegate
>

/**数据容器*/
@property (nonatomic, strong) NSMutableArray<id <OTSectionItemProtocol>> *sectionItems;

@property (nonatomic, weak) id hostObject;

@end
