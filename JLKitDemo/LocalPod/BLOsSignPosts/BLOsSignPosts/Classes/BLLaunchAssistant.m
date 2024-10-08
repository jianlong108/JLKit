//
//  BLLaunchAssistant.m
//  bigolive
//
//  Created by JL on 2023/10/19.
//  Copyright © 2023 YY Inc. All rights reserved.
//

#import "BLLaunchAssistant.h"

@interface BLLaunchAssistant()

@property (nonatomic, strong) NSMutableDictionary *firstFrameNeedDic;
@end

@implementation BLLaunchAssistant

+ (instancetype)shareAssistant {
    static dispatch_once_t onceToken;
    static BLLaunchAssistant *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithSingleObject];
    });
    return _instance;
}

- (instancetype)initWithSingleObject {
    if (self = [super init]) {
        dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);

        _bgSerialQueue = dispatch_queue_create("BLLaunchAssistant", attr);
        _firstFrameNeedDic = [NSMutableDictionary dictionary];
        [self asyncLoadSomeMutltiLaunageInfo];
    }
    return self;
}

- (void)asyncLoadSomeMutltiLaunageInfo {
//    for(NSString *key in @[@"Home",@"Explore",@"Video",@"Community",@"Me",@"main.tab.friend.title",@"Nearby",@"Popular",@"Chat",@"Gaming",@"Event",@"Vtuber.Virtual Live"]) {
//        dispatch_async(self.bgSerialQueue, ^ {
//            [self.firstFrameNeedDic setObject:key.localized forKey:key];
//        });
//    }
}

//- (NSString *)getLocalizedWithKey:(NSString *)key {
//    return [self.firstFrameNeedDic bgf_objectForKey:key expect:[NSString class]];
//}

@end
