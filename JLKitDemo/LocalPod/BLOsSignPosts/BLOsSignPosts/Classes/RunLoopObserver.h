//
//  RunLoopObserver.h
//  BLOsSignPosts
//
//  Created by JL on 2024/8/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunLoopObserver : NSObject

- (void)startObserving;
- (void)stopObserving;

@end

NS_ASSUME_NONNULL_END
