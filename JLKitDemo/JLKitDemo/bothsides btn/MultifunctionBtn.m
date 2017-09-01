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
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *subTitleLabel = [[UILabel alloc]init];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.font = [UIFont systemFontOfSize:11];
        subTitleLabel.textColor = [UIColor whiteColor];
        [self addSubview:subTitleLabel];
        _subTitleLabel = subTitleLabel;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat w = CGRectGetWidth(contentRect);
    CGFloat h = CGRectGetHeight(contentRect);
    
    if (self.btnStyle == MultifunctionBtnStyleTitleLeft) {
        return [super imageRectForContentRect:contentRect];
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
        return [super titleRectForContentRect:contentRect];
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


@end

