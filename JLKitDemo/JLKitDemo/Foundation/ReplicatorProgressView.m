//
//  ProgressAnimationView.m
//  JLKitDemo
//
//  Created by wangjianlong on 2018/10/9.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "ReplicatorProgressView.h"

static NSString *const ReplicatorProgressViewAnimationKey = @"ReplicatorProgressViewAnimationKey";

@interface ReplicatorProgressView()

@property (nonatomic, strong) CAShapeLayer *activityLayer;

@end

@implementation ReplicatorProgressView

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
    _activityLayer = [CAShapeLayer layer];
    
    //使用贝塞尔曲线绘制矩形路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.center.x, self.center.y)];
    [path addLineToPoint:CGPointMake(self.center.x + 20, self.center.y)];
    [path addLineToPoint:CGPointMake(self.center.x + 10, self.center.y + 20)];
    [path addLineToPoint:CGPointMake(self.center.x - 10 , self.center.y + 20)];
    [path closePath];
    _activityLayer.fillColor = [UIColor blueColor].CGColor;
    _activityLayer.path = path.CGPath;
    //设置图层不可见
    _activityLayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    [self.replicatorLayer addSublayer:_activityLayer];
    
    //复制的图层数为三个
    self.replicatorLayer.instanceCount = 4;
    //设置每个复制图层延迟时间
    self.replicatorLayer.instanceDelay = 1.f / 4.f;
    //设置每个图层之间的偏移
    self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(35, 0, 0);
}

- (CABasicAnimation *)alphaAnimation{
    //设置透明度动画
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @1.0;
    alpha.toValue = @0.01;
    alpha.duration = 1.f;
    return alpha;
}

- (CABasicAnimation *)activityScaleAnimation{
    //设置缩放动画
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.toValue = @1;
    scale.fromValue = @1;
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
    if ([_activityLayer animationForKey:ReplicatorProgressViewAnimationKey]) {
        return;
    }
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[[self alphaAnimation],[self activityScaleAnimation]];
    group.duration = 1.f;
    group.repeatCount = HUGE;
    [_activityLayer addAnimation:group forKey:ReplicatorProgressViewAnimationKey];
}

- (void)stopAnimation
{
    if ([_activityLayer animationForKey:ReplicatorProgressViewAnimationKey]) {
        [_activityLayer removeAnimationForKey:ReplicatorProgressViewAnimationKey];
    }
}

- (CAReplicatorLayer *)replicatorLayer
{
    return (CAReplicatorLayer *)self.layer;
}

@end
