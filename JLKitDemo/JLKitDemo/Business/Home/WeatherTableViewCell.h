//
//  WeatherTableViewCell.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/9/16.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTProtocol.h"
#import "WeatherModelProtocol.h"

extern NSString * const WeatherTableViewCell_ReuseIdentifer;


@interface WeatherTableViewCell : UITableViewCell<OTCellProtocol>

@property(nonatomic, strong) id<WeatherTableViewCellModelProtocol>cellModel;

@end
