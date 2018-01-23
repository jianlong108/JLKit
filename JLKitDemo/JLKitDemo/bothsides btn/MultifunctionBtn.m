//
//  Multifunction.m
//  MiTalk
//
//  Created by wangjianlong on 2017/9/1.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "MultifunctionBtn.h"

@implementation MultifunctionBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *subTitleLabel = [[UILabel alloc]init];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.font = [UIFont systemFontOfSize:12];
        subTitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self addSubview:subTitleLabel];
        _subTitleLabel = subTitleLabel;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat w = CGRectGetWidth(contentRect);
    CGFloat h = CGRectGetHeight(contentRect);
    
    if (self.btnStyle == MultifunctionBtnStyleTitleLeft) {
        CGFloat W = CGRectGetWidth(contentRect);
        CGFloat H = CGRectGetHeight(contentRect);
        CGRect titleRect = [super titleRectForContentRect:contentRect];
        CGRect imgViewRect = [super imageRectForContentRect:contentRect];
        CGFloat titleW = CGRectGetWidth(titleRect);
        CGFloat titleH = CGRectGetHeight(titleRect);
        CGFloat imgViewW = CGRectGetWidth(imgViewRect);
        
        CGFloat x = (W - titleW - imgViewW - self.titleEdgeInsets.right-self.imageEdgeInsets.left)/2;
        CGFloat y = (H - titleH )/2 + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom;
        
        return CGRectMake(x, y, titleW, titleH);
    }else if (self.btnStyle == MultifunctionBtnStyleTitleTop){
        return CGRectMake(0, 0, w, h/2);
    }else if (self.btnStyle == MultifunctionBtnStyleTitleBottom){
        return CGRectMake(0, h/2, w, h/2);
    }else{
        return [super titleRectForContentRect:contentRect];
    }
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat w = CGRectGetWidth(contentRect);
    CGFloat h = CGRectGetHeight(contentRect);
    
    
    if (self.btnStyle == MultifunctionBtnStyleTitleLeft) {
        CGFloat W = CGRectGetWidth(contentRect);
        CGFloat H = CGRectGetHeight(contentRect);
        CGRect titleRect = [super titleRectForContentRect:contentRect];
        CGRect imgViewRect = [super imageRectForContentRect:contentRect];
        CGFloat titleW = CGRectGetWidth(titleRect);
        CGFloat imgViewW = CGRectGetWidth(imgViewRect);
        CGFloat imgViewH = CGRectGetHeight(imgViewRect);
        
        CGFloat x = (W - titleW - imgViewW - self.titleEdgeInsets.right-self.imageEdgeInsets.left)/2 + titleW + self.titleEdgeInsets.right + self.imageEdgeInsets.left;
        CGFloat y = (H - imgViewH)/2 + self.imageEdgeInsets.top - self.imageEdgeInsets.bottom;
        
        return CGRectMake(x, y, imgViewW, imgViewH);
        
    }else if (self.btnStyle == MultifunctionBtnStyleTitleTop){
        return CGRectMake(0, h/2, w, h/2);
    }else if (self.btnStyle == MultifunctionBtnStyleTitleBottom){
        return CGRectMake(0, 0, w, h/2);
    }else{
        return [super imageRectForContentRect:contentRect];
    }
    
}

- (CGRect)contentRectForBounds:(CGRect)bounds{
    CGRect contentRect = [super contentRectForBounds:bounds];
    self.subTitleLabel.frame = [self subTitleLabelRectForContentRect:contentRect];
    return contentRect;
}

- (CGRect)subTitleLabelRectForContentRect:(CGRect)contentRect{
    return [self imageRectForContentRect:contentRect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) * self.cornerRadiusRatio;
    self.layer.masksToBounds = YES;
}

@end

