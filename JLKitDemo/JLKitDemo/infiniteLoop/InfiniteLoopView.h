//
//  InfiniteLoopView.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2017/9/3.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteLoopView : UIView

/// click action
@property (nonatomic, copy) void (^clickAction) (NSInteger curIndex) ;

/// data source
@property (nonatomic, copy) NSArray *imageURLStrings;


- (instancetype)initWithFrame:(CGRect)frame scrollDuration:(NSTimeInterval)duration;

@end
