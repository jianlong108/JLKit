//
//  JLScrollNavigationItem.h
//  JLContainer
//
//  Created by wangjianlong on 2018/5/14.
//

#import <Foundation/Foundation.h>
#import "JLScrollNavigationChildControllerProtocol.h"

@interface JLScrollNavigationItem : NSObject

/**标题*/
@property (nonatomic, copy) NSString *title;

/**标题对应的业务控制器*/
@property (nonatomic, strong) UIViewController <JLScrollNavigationChildControllerProtocol>*controller;

@end
