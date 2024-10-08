//
//  JLVerticalScrollView.h
//  JLContainer
//
//  Created by Wangjianlong on 2018/8/19.
//

#import <UIKit/UIKit.h>


@protocol JLVerticalScrollViewDelegate <UIScrollViewDelegate>
@optional
-(BOOL)canScrollWithGesture:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

@interface JLVerticalScrollView : UIScrollView

@property (nonatomic,weak)id<JLVerticalScrollViewDelegate> delegate;

@end
