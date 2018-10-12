//
//  WeatherModel.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/9/16.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTProtocol.h"
#import "WeatherModelProtocol.h"

@interface WeatherModel : NSObject<OTItemProtocol,WeatherTableViewCellModelProtocol>

@end
