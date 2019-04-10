//
//  InfiniteLooper.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/8/13.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteLoops : UIView

/// click action
@property (nonatomic, copy) void (^clickAction) (NSInteger curIndex) ;

/// data source
@property (nonatomic, copy) NSArray *imageURLStrings;


- (instancetype)initWithFrame:(CGRect)frame scrollDuration:(NSTimeInterval)duration;

@end
