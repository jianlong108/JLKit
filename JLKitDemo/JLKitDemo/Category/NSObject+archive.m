//
//  NSObject+archive.m
//  JLKitDemo
//
//  Created by wangjianlong on 2018/2/5.
//  Copyright © 2018年 JL. All rights reserved.
//

#import "NSObject+archive.h"
#import "NSString+JL.h"
#import "NSData+JL.h"

@implementation NSObject (archive)
- (void)saveWithKey:(NSString *)key syncWrite:(BOOL)syncWrite
{
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:self];
    if ([key isEmpty]) {
        return;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![dataSave isEmpty]) {
        [userDefault setObject:dataSave forKey:key];
        if (syncWrite){
            [userDefault synchronize];
        }
    }
}

- (NSObject *)getArchiveDataWithKey:(NSString *)key
{
    if ([key isEmpty]) {
        return nil;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData* data = [userDefault objectForKey:key];
    if (![data isEmpty]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

@end
