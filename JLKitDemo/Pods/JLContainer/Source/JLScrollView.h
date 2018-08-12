//
//  JLScrollView.h
//  JLContainer
//
//  Created by 王建龙 on 2017/9/6.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTScrollViewDelegate <UIScrollViewDelegate>
@optional
-(BOOL)canScrollWithGesture:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

@interface JLScrollView : UIScrollView

@property (nonatomic,weak)id<MTScrollViewDelegate> delegate;

@end
