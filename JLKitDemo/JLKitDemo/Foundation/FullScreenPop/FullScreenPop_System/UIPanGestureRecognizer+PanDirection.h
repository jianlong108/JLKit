//
//  UIPanGestureRecognizer+PanDirection.h
//  MiTalk
//
//  Created by wangjianlong on 2018/1/30.
//  Copyright © 2018年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, XMPanMoveDirection)
{
    kXMPanMoveDirectionNone = 1<<0,
    
    kXMPanMoveDirectionUp = 1<<1,
    
    kXMPanMoveDirectionDown = 1<<2,
    
    kXMPanMoveDirectionRight = 1<<3,
    
    kXMPanMoveDirectionLeft = 1<<4,
    
    kXMPanMoveDirectionHorzontal = (kXMPanMoveDirectionRight|kXMPanMoveDirectionLeft),
    kXMPanMoveDirectionVertical = (kXMPanMoveDirectionUp|kXMPanMoveDirectionDown),
};


@interface UIPanGestureRecognizer (PanDirection)

- (XMPanMoveDirection)determinePanDirectionIfNeeded:(CGPoint)translation;

@end
