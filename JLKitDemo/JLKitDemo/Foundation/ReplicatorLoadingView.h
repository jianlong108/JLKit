//
//  ReplicatorLoadingView.h
//  JLKitDemo
//
//  Created by wangjianlong on 2018/10/9.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReplicatorLoadingView : UIView

@property (nonatomic, readonly) CAReplicatorLayer *replicatorLayer;

@property (nonatomic, assign) CGFloat maxCircleHeight;
@property (nonatomic, strong) UIColor *colorLumpFillColor;

@property (nonatomic, assign) BOOL autoPlaying;

- (void)startAnimation;

@end

NS_ASSUME_NONNULL_END
