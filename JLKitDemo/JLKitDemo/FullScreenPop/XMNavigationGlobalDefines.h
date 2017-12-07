//
//  XMNavigationGlobalDefines.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#ifndef XMNavigationGlobalDefines_h
#define XMNavigationGlobalDefines_h

#define USE_XMNavigationController 1

typedef NS_OPTIONS(NSUInteger, XMPanMoveDirection)
{
    kXMPanMoveDirectionNone = 1<<0,
    
    kXMPanMoveDirectionUp = 1<<1,
    
    kXMPanMoveDirectionDown = 1<<2,
    
    kXMPanMoveDirectionRight = 1<<3,
    
    kXMPanMoveDirectionLeft = 1<<4,
    
    kXMPanMoveDirectionHorzontal = (kXMPanMoveDirectionRight|kXMPanMoveDirectionLeft),
    
} ;

/**
 *  以下为XMNavigationController push or pop 动画类型
 *  XMNavigationViewAnimationTypeRightToLeft 值为1
 *  与其相反的动画XMNavigationViewAnimationTypeLeftToRight只为-1
 *  当使用一个动画push一个控制器后，pop时不指定某一个动画类型 默认寻找与其对应的动画类型
 */
typedef NS_OPTIONS(NSInteger,XMNavigationViewAnimationType)
{
    XMNavigationViewAnimationTypeNone = 0,
    
    XMNavigationViewAnimationTypeRightToLeft = 1,
    XMNavigationViewAnimationTypeBottomToTop = 2,
    
    XMNavigationViewAnimationTypeLeftToRight = -1,
    XMNavigationViewAnimationTypeTopToBottom = -2,
    
};


typedef void(^XMNavigationAnimationCompletionBlock)(void);

#endif /* XMNavigationGlobalDefines_h */
