//
//  ReplicatorLoadingView.m
//  JLKitDemo
//
//  Created by wangjianlong on 2018/10/9.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "ReplicatorLoadingView.h"

static NSString *const ReplicatorLoadingViewAnimationKey = @"ReplicatorLoadingViewAnimationKey";

@interface ReplicatorLoadingView()

@property (nonatomic, strong) CALayer *circularLayer;

@end

@implementation ReplicatorLoadingView

+ (Class)layerClass
{
    return [CAReplicatorLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initlize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self _initlize];
    }
    return self;
}

- (void)_initlize
{
    _autoPlaying = YES;
    _circularLayer = [CALayer layer];
    _circularLayer.backgroundColor = self.colorLumpFillColor.CGColor;
    _circularLayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    [self.layer addSublayer:_circularLayer];
    
    self.replicatorLayer.instanceCount = 15;
    CGFloat angle = 2 * M_PI / 15;
    self.replicatorLayer.instanceDelay = 1.f/ 15.f;
    //设置偏移角度和方向
    self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _circularLayer.frame = CGRectMake(CGRectGetWidth(self.bounds)/2, 0, self.maxCircleHeight, self.maxCircleHeight);
    _circularLayer.cornerRadius = self.maxCircleHeight/2;
}

- (CGFloat)maxCircleHeight
{
    if (_maxCircleHeight <= 0) {
        _maxCircleHeight = 15;
    }
    return _maxCircleHeight;
}

- (UIColor *)colorLumpFillColor
{
    if (_colorLumpFillColor) {
        return _colorLumpFillColor;
    }
    return [UIColor colorWithRed:86.f/255.f green:148.f/255.f blue:253.f/255.f alpha:1];
}

- (CABasicAnimation *)alphaAnimation
{
    //设置透明度动画
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @1.0;
    alpha.toValue = @0.01;
    alpha.duration = 1.f;
    return alpha;
}


- (CABasicAnimation *)circularScaleAnimation
{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.toValue = @0.1;
    scale.fromValue = @1;
    scale.duration = 1.f;
    
    scale.repeatCount = HUGE;
    return scale;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    //设置动画组，并执行动画
    if (_autoPlaying) {
        [self startAnimation];
    }
}

- (void)startAnimation
{
    if ([_circularLayer animationForKey:ReplicatorLoadingViewAnimationKey]) {
        return;
    }
    
    [_circularLayer addAnimation:[self circularScaleAnimation] forKey:ReplicatorLoadingViewAnimationKey];
}

- (void)stopAnimation
{
    if ([_circularLayer animationForKey:ReplicatorLoadingViewAnimationKey]) {
        [_circularLayer removeAnimationForKey:ReplicatorLoadingViewAnimationKey];
    }
}

- (CAReplicatorLayer *)replicatorLayer
{
    return (CAReplicatorLayer *)self.layer;
}

@end
