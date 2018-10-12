//
//  WeatherModel.m
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/9/16.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel
@synthesize city;
@synthesize temperature;
@synthesize humidity;
@synthesize pm25;
@synthesize pm10;
@synthesize airQuality;
@synthesize weatherDescription;

@synthesize reuseableIdentierOfCell;

- (CGFloat)heightOfCell
{
    return 230;
}

@end
