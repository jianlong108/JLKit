//
//  NSObject+AssociateObj.h
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>

//对NSObject的扩展，方便在catagory中添加属性
@interface NSObject (AssociateObj)

@property (nonatomic,strong,readonly) NSMapTable   *weakDictionary;
@property (nonatomic,strong,readonly) NSMutableDictionary *strongDictionary;


- (void)removeAllAssociateObject;

@end
