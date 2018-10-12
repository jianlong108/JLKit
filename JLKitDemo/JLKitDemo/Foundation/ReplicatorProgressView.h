//
//  ProgressAnimationView.h
//  JLKitDemo
//
//  Created by wangjianlong on 2018/10/9.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplicatorProgressView : UIView

@property (nonatomic, readonly) CAReplicatorLayer *replicatorLayer;

@property (nonatomic, strong) UIColor *colorLumpFillColor;

@property (nonatomic, assign) CGFloat colorLumpWidth;
@property (nonatomic, assign) CGFloat colorLumpHeight;

@property (nonatomic, assign) BOOL autoPlaying;

- (void)startAnimation;
- (void)stopAnimation;

@end
