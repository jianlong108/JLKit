//
//  NSObject+AssociateObj.m
//  MiTalk
//
//  Created by wangjianlong on 2017/12/4.
//  Copyright © 2017年 Xiaomi. All rights reserved.
//

#import "NSObject+AssociateObj.h"
#import <objc/runtime.h>

static NSString *weakDictionaryKey = @"weakDictionaryKey";
static NSString *strongDictionaryKey = @"strongDictionaryKey";

@implementation NSObject (AssociateObj)

- (void)setWeakDictionary:(NSMapTable *)weakDictionary
{
    objc_setAssociatedObject(self, &weakDictionaryKey, weakDictionary, OBJC_ASSOCIATION_RETAIN);
}

- (NSMapTable *)weakDictionary
{
    NSMapTable *weak = objc_getAssociatedObject(self, &weakDictionaryKey);
    if (!weak)
    {
        weak = [NSMapTable weakToWeakObjectsMapTable];
        [self setWeakDictionary:weak];
    }
    
    return weak;
}

- (void)setStrongDictionary:(NSMutableDictionary *)strongDictionary
{
    objc_setAssociatedObject(self, &strongDictionaryKey, strongDictionary, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)strongDictionary
{
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, &strongDictionaryKey);
    if (!dictionary)
    {
        dictionary = [NSMutableDictionary dictionary];
        
        [self setStrongDictionary:dictionary];
    }
    
    return dictionary;
    
}


- (void)removeAllAssociateObject
{
    [self setStrongDictionary:nil];
    [self setWeakDictionary:nil];
}

@end
