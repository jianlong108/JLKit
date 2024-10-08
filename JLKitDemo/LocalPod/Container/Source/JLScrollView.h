//
//  JLScrollView.h
//  JLContainer
//
//  Created by 王建龙 on 2017/9/6.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLScrollViewDelegate <UIScrollViewDelegate>

@optional

-(BOOL)canScrollWithGesture:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

- (BOOL)innerScrollView:(UIScrollView *)scrollView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

@end

@interface JLScrollView : UIScrollView

@property (nonatomic,weak)id<JLScrollViewDelegate> delegate;

@end

@interface UIScrollView(AdjuestContentInset)

@property (nonatomic,assign) CGFloat offsetOrginYForHeader;

//是否在MTScrollNavigationController中调整过ContentInset
@property (nonatomic,assign) BOOL adjuestContentInsetByMTScrollNavigationController;


@end
