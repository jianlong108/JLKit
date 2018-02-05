//
//  NSObject+archive.h
//  JLKitDemo
//
//  Created by wangjianlong on 2018/2/5.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (archive)

- (void)saveWithKey:(NSString *)key syncWrite:(BOOL)syncWrite;

- (NSObject *)getArchiveDataWithKey:(NSString *)key;

@end
