//
//  OTTableViewCore.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/9/10.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTPotocol.h"

@interface OTTableViewCore : NSObject<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong) NSMutableArray *items;

@end
