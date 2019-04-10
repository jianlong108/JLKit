//
//  UIPanGestureRecognizer+PanDirection.m
//  MiTalk
//
//  Created by wangjianlong on 2018/1/30.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import "UIPanGestureRecognizer+PanDirection.h"

static CGFloat const gestureMinimumTranslation = 5.0;

@implementation UIPanGestureRecognizer (PanDirection)


- (XMPanMoveDirection)determinePanDirectionIfNeeded:(CGPoint)translation
{
    if (fabs(translation.x) > gestureMinimumTranslation)
    {
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0 )
        {
            gestureHorizontal = YES;
        }
        else
        {
            gestureHorizontal = (fabs(translation.x / translation.y) > 2.0 );
        }
        
        if (gestureHorizontal)
        {
            if (translation.x > 0.0 )
            {
                return kXMPanMoveDirectionRight;
            }
            else
            {
                return kXMPanMoveDirectionLeft;
            }
        }
        
    }
    
    if (fabs(translation.y) > gestureMinimumTranslation)
    {
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0 )
        {
            gestureVertical = YES;
        }
        else
        {
            gestureVertical = (fabs(translation.y / translation.x) > 2.0 );
        }
        
        if (gestureVertical)
        {
            if (translation.y > 0.0 )
            {
                return kXMPanMoveDirectionDown;
            }
            else
            {
                return kXMPanMoveDirectionUp;
            }
        }
    }
    
    return kXMPanMoveDirectionNone;
    
}


@end
