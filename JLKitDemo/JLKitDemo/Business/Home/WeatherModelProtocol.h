//
//  WeatherModelProtocol.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/9/16.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherTableViewCellModelProtocol<NSObject>

@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *temperature;
@property(nonatomic, copy) NSString *humidity;
@property(nonatomic, copy) NSString *pm25;
@property(nonatomic, copy) NSString *pm10;
@property(nonatomic, copy) NSString *airQuality;
@property(nonatomic, copy) NSString *weatherDescription;

@end
