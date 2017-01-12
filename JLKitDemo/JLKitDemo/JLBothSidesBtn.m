//
//  JLBothSidesView.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "JLBothSidesBtn.h"

@interface JLBothSidesBtn ()

/**正面button*/
@property (nonatomic, strong,readwrite)UIButton *positiveBtn;

/**反面button*/
@property (nonatomic, strong,readwrite)UIButton *oppositeBtn;

@end

@implementation JLBothSidesBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _animationOptions = UIViewAnimationOptionTransitionFlipFromLeft;
        _animationDuration = 0.5f;
        _autoTransition = YES;
        
        // Do any additional setup after loading the view.
        _positiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_positiveBtn setBackgroundImage:[UIImage imageNamed:@"nav_cz"] forState:UIControlStateNormal];
        _positiveBtn.frame = self.bounds;
        [_positiveBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_positiveBtn];
        
        _oppositeBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _oppositeBtn.frame = self.bounds;
        [_oppositeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_oppositeBtn setBackgroundImage:[UIImage imageNamed:@"nav_crown"] forState:UIControlStateNormal];
    }
    return self;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    backgroundColor = [UIColor clearColor];
    
}
- (void)btnClick:(UIButton *)sender{
    if (_autoTransition == NO)
        return;

    [UIView transitionFromView:sender toView:(sender == _positiveBtn)?_oppositeBtn : _positiveBtn duration:_animationDuration options:_animationOptions completion:^(BOOL finished) {
        NSLog(@"%@--->%@",_oppositeBtn.superview,_positiveBtn.superview);
    }];
}
- (void)transitionView{
    if (_oppositeBtn.superview == nil) {
        [UIView transitionFromView:_positiveBtn toView:_oppositeBtn duration:_animationDuration options:_animationOptions completion:^(BOOL finished) {
            NSLog(@"%@--->%@",_oppositeBtn.superview,_positiveBtn.superview);
        }];
    }else{
        [UIView transitionFromView:_oppositeBtn toView:_positiveBtn duration:_animationDuration options:_animationOptions completion:^(BOOL finished) {
            NSLog(@"%@--->%@",_oppositeBtn.superview,_positiveBtn.superview);
        }];
    }
}
@end
