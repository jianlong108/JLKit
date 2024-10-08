//
//  RunLoopObserver.m
//  BLOsSignPosts
//
//  Created by JL on 2024/8/15.
//

#import "RunLoopObserver.h"
#if __has_include(<BLOsSignPosts/BLOsSignPosts-Swift.h>)
    #import <BLOsSignPosts/BLOsSignPosts-Swift.h>
#else
    #import "BLOsSignPosts-Swift.h"
#endif
@interface RunLoopObserver() {
    CFRunLoopObserverRef m_observer;
    CFRunLoopObserverRef m_runLoopBeginObserver;
    CFRunLoopObserverRef m_runLoopEndObserver;
    CFRunLoopObserverRef m_initializationBeginRunloopObserver;
    CFRunLoopObserverRef m_initializationEndRunloopObserver;
}

@end

@implementation RunLoopObserver

//void runLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
//    RunLoopObserver *self = (__bridge RunLoopObserver *)info;
//    [self handleRunLoopActivity:activity];
//}

- (void)startObserving {
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopBeforeSources, true, 0, &runLoopObserverCallback, &context);
//    if (observer) {
//        CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
//        CFRunLoopAddObserver(currentRunLoop, observer, kCFRunLoopCommonModes);
//        CFRetain(observer);
//        m_observer = observer;
//    }
    // the first observer
    CFRunLoopObserverContext context = { 0, (__bridge void *)self, NULL, NULL, NULL };
    CFRunLoopObserverRef beginObserver =
    CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MIN, &myRunLoopBeginCallback, &context);
    CFRetain(beginObserver);
    m_runLoopBeginObserver = beginObserver;

    // the last observer
    CFRunLoopObserverRef endObserver =
    CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MAX, &myRunLoopEndCallback, &context);
    CFRetain(endObserver);
    m_runLoopEndObserver = endObserver;
    CFRunLoopRef loopref = [runloop getCFRunLoop];
    CFRunLoopAddObserver(loopref, beginObserver, kCFRunLoopCommonModes);
    CFRunLoopAddObserver(loopref, endObserver, kCFRunLoopCommonModes);

    // for InitializationRunLoopMode
    CFRunLoopObserverContext initializationContext = { 0, (__bridge void *)self, NULL, NULL, NULL };
    m_initializationBeginRunloopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                                   kCFRunLoopAllActivities,
                                                                   YES,
                                                                   LONG_MIN,
                                                                   &myInitializetionRunLoopBeginCallback,
                                                                   &initializationContext);
    CFRetain(m_initializationBeginRunloopObserver);

    m_initializationEndRunloopObserver =
    CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MAX, &myInitializetionRunLoopEndCallback, &initializationContext);
    CFRetain(m_initializationEndRunloopObserver);

    CFRunLoopAddObserver(loopref, m_initializationBeginRunloopObserver, (CFRunLoopMode) @"UIInitializationRunLoopMode");
    CFRunLoopAddObserver(loopref, m_initializationEndRunloopObserver, (CFRunLoopMode) @"UIInitializationRunLoopMode");
}


void myRunLoopBeginCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
//    g_runLoopActivity = activity;
//    g_runLoopMode = eRunloopDefaultMode;
    switch (activity) {
        case kCFRunLoopEntry:
//            NSLog(@"WJL RunLoop entry");
            [BLSignposts os_poi_event:1 name:@"RunLoop entry"];
            break;

        case kCFRunLoopBeforeTimers:
//            if (g_bRun == NO && g_bInSuspend == NO) {
//                gettimeofday(&g_tvRun, NULL);
//            }
//            g_bRun = YES;
//            NSLog(@"WJL RunLoop BeforeTimer");
            [BLSignposts os_poi_event:1 name:@"BeforeTimer"];
            break;

        case kCFRunLoopBeforeSources:
//            if (g_bRun == NO && g_bInSuspend == NO) {
//                gettimeofday(&g_tvRun, NULL);
//            }
//            g_bRun = YES;
//            NSLog(@"WJL RunLoop BeforeSources");
//            [BLSignposts os_poi_event:1 name:@"BeforeSources"];
            break;

        case kCFRunLoopAfterWaiting:
//            if (g_bRun == NO && g_bInSuspend == NO) {
//                gettimeofday(&g_tvRun, NULL);
//            }
//            g_bRun = YES;
//            NSLog(@"WJL RunLoop AfterWaiting");
            [BLSignposts os_poi_event:1 name:@"afterWait"];
            break;

        case kCFRunLoopAllActivities:
            break;

        default:
            break;
    }
}

void myRunLoopEndCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
//    g_runLoopActivity = activity;
//    g_runLoopMode = eRunloopDefaultMode;
    switch (activity) {
        case kCFRunLoopBeforeWaiting:
//            if (g_bSensitiveRunloopHangDetection && g_bRun) {
//                [WCBlockMonitorMgr checkRunloopDuration];
//            }
//            if (g_bInSuspend == NO) {
//                gettimeofday(&g_tvRun, NULL);
//            }
//            g_bRun = NO;
//            NSLog(@"WJL RunLoop BeforeWaiting");
            [BLSignposts os_poi_event:1 name:@"beforeWait"];
            break;

        case kCFRunLoopExit:
//            g_bRun = NO;
//            NSLog(@"WJL RunLoop LoopExit");
            [BLSignposts os_poi_event:1 name:@"LoopExit"];
            break;

        case kCFRunLoopAllActivities:
            break;

        default:
            break;
    }
}

void myInitializetionRunLoopBeginCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
//    g_runLoopActivity = activity;
//    g_runLoopMode = eRunloopInitMode;
    switch (activity) {
        case kCFRunLoopEntry:
//            g_bRun = YES;
//            g_bLaunchOver = NO;
//            NSLog(@"WJL launch RunLoop Entry");
            [BLSignposts os_poi_event:9 name:@"launch begin Entry"];
            break;

        case kCFRunLoopBeforeTimers:
//            gettimeofday(&g_tvRun, NULL);
//            g_bRun = YES;
//            g_bLaunchOver = NO;
//            NSLog(@"WJL launch RunLoop BeforeTimers");
//            [BLSignposts os_poi_event:9 name:@"launch begin BeforeTimers"];
            break;

        case kCFRunLoopBeforeSources:
//            gettimeofday(&g_tvRun, NULL);
//            g_bRun = YES;
//            g_bLaunchOver = NO;
//            NSLog(@"WJL launch RunLoop BeforeSources");
//            [BLSignposts os_poi_event:9 name:@"launch begin BeforeSources"];
            break;

        case kCFRunLoopAfterWaiting:
//            gettimeofday(&g_tvRun, NULL);
//            g_bRun = YES;
//            g_bLaunchOver = NO;
//            NSLog(@"WJL launch RunLoop AfterWaiting");
            [BLSignposts os_poi_event:9 name:@"launch begin afterWait"];
            break;

        case kCFRunLoopAllActivities:
            break;
        default:
            break;
    }
}

void myInitializetionRunLoopEndCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
//    g_runLoopActivity = activity;
//    g_runLoopMode = eRunloopInitMode;
    switch (activity) {
        case kCFRunLoopBeforeWaiting:
//            gettimeofday(&g_tvRun, NULL);
//            g_bRun = NO;
//            g_bLaunchOver = YES;
//            NSLog(@"WJL launch RunLoop BeforeWaiting");
            [BLSignposts os_poi_event:9 name:@"launch end beforeWait"];
            break;

        case kCFRunLoopExit:
//            g_bRun = NO;
//            g_bLaunchOver = YES;

//            NSLog(@"WJL launch RunLoop LoopExit");
            [BLSignposts os_poi_event:9 name:@"launch end LoopExit"];
            break;

        case kCFRunLoopAllActivities:
            break;

        default:
            break;
    }
}

- (void)dealloc {
    [self stopObserving];
}

- (void)stopObserving {
    if (m_observer) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), m_observer, kCFRunLoopDefaultMode);
        CFRelease(m_observer);
    }
    if (m_runLoopBeginObserver) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), m_runLoopBeginObserver, kCFRunLoopDefaultMode);
        CFRelease(m_runLoopBeginObserver);
    }
    if (m_runLoopEndObserver) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), m_runLoopEndObserver, kCFRunLoopDefaultMode);
        CFRelease(m_runLoopEndObserver);
    }
    if (m_initializationBeginRunloopObserver) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), m_initializationBeginRunloopObserver, kCFRunLoopDefaultMode);
        CFRelease(m_initializationBeginRunloopObserver);
    }
    if (m_initializationEndRunloopObserver) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), m_initializationEndRunloopObserver, kCFRunLoopDefaultMode);
        CFRelease(m_initializationEndRunloopObserver);
    }
}

@end

