//
//  BLLaunchAssistant.h
//  bigolive
//
//  Created by JL on 2023/10/19.
//  Copyright © 2023 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BLMainTabBarItem;

@interface BLLaunchAssistant : NSObject

@property (nonatomic, strong, readonly) dispatch_queue_t bgSerialQueue;

+ (instancetype)shareAssistant;

- (instancetype)init NS_UNAVAILABLE;

//- (NSString *)getLocalizedWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
