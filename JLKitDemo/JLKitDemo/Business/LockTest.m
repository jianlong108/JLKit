//
//  LockTest.m
//  low-level-analyse
//
//  Created by Wangjianlong on 2017/1/22.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "LockTest.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <libkern/OSAtomic.h>
#import <pthread.h>



#define ITERATIONS (1024*1024*32)

@implementation LockTest

static unsigned long long disp=0, land=0;
//static IMP lockLock ;
//static IMP unlockLock;
typedef id(*_IMP) (id, SEL, ...);

static NSLock *lock;
-(void)lockTest{
    
    @autoreleasepool {
        
        double then, now;
        unsigned int i, count;
        pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
        OSSpinLock spinlock = OS_SPINLOCK_INIT;
        
        
        lock = [NSLock new];
        then = CFAbsoluteTimeGetCurrent();
        for(i=0;i<ITERATIONS;++i)
        {
            [lock lock];
            [lock unlock];
        }
        now = CFAbsoluteTimeGetCurrent();
        printf("NSLock: %f sec/n", now-then);
        
        then = CFAbsoluteTimeGetCurrent();
        
//        _IMP lockLock = (_IMP)[lock methodForSelector:@selector(lock)];
//        _IMP unlockLock = (_IMP)[lock methodForSelector:@selector(unlock)];
//        for(i=0;i<ITERATIONS;++i)
//        {
//            lockLock(lock,@selector(lock));
//            unlockLock(lock,@selector(unlock));
//            
//        }
        now = CFAbsoluteTimeGetCurrent();
        printf("NSLock+IMP Cache: %f sec/n", now-then);
        
        then = CFAbsoluteTimeGetCurrent();
        for(i=0;i<ITERATIONS;++i)
        {
            pthread_mutex_lock(&mutex);
            pthread_mutex_unlock(&mutex);
        }
        
        now = CFAbsoluteTimeGetCurrent();
        printf("pthread_mutex: %f sec/n", now-then);
        
        then = CFAbsoluteTimeGetCurrent();
        for(i=0;i<ITERATIONS;++i)
        {
            OSSpinLockLock(&spinlock);
            OSSpinLockUnlock(&spinlock);
        }
        
        now = CFAbsoluteTimeGetCurrent();
        printf("OSSpinlock: %f sec/n", now-then);
        
        id obj = [NSObject new];
        
        then = CFAbsoluteTimeGetCurrent();
        for(i=0;i<ITERATIONS;++i)
        {
            @synchronized(obj)
            {
            }
        }
        now = CFAbsoluteTimeGetCurrent();
        printf("@synchronized: %f sec/n", now-then);
        
    }
    
}

- (void)lock_test {
    
    //NSLock普通锁
//            [self nslock];
    
    //NSConditionLock条件锁
//            [self nsconditionlock];
    
    //NSRecursiveLock递归锁
    //        [self nsrecursivelock];
    
    //NSCondition线程锁
//            [self nscondition];
    
    //@synchronized
//    [self synchronized];
    
    //dispatch_semaphore
//        [self dispatch_semaphore];
    
    //OSSpinLock自旋锁
//        [self asspinlock];
    
    //pthread_mutex
//        [self pthread_mutex];
    
    //pthread_mutex_recursive
        [self pthread_mutex_recursive];
}

- (void)nslock
{
    /**
     * 在没有锁的情况下,在一个方法中,开启两个线程后,会在每个线程中一次执行一次,依次循环.
     * 加锁 可以控制两个子线程中的执行顺序.(打开代码注释)
     */
    NSLock *lock = [NSLock new];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 尝试加速ing...");
//        [lock lock];
//        sleep(3);//睡眠5秒
        NSLog(@"线程1");
//        [lock unlock];
        NSLog(@"线程1解锁成功");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 尝试加速ing...");
//        BOOL x =  [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:4]];
//        if (x) {
            NSLog(@"线程2");
            [lock unlock];
//        }else{
            NSLog(@"失败");
//        }
    });
}

- (void)nsconditionlock
{
    NSConditionLock *cLock = [[NSConditionLock alloc] initWithCondition:0];
    cLock.name = @"条件锁";
    if ([cLock tryLock]) {
        NSLog(@"%@--%ld",cLock.name,cLock.condition);
//        [cLock unlock];
    }
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //当锁此时是锁住的时候,再去视图加锁,就会返回NO;
        if([cLock tryLockWhenCondition:0]){
            NSLog(@"线程1");
            [cLock unlockWithCondition:1];
        }else{
            NSLog(@"失败");
        }
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:2];
        NSLog(@"线程2");
        [cLock unlockWithCondition:0];
    });
    
    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:1];
        NSLog(@"线程3");
        [cLock unlockWithCondition:2];
    });
    /*
     我们在初始化 NSConditionLock 对象时，给了他的标示为 0
     执行 tryLockWhenCondition:时，我们传入的条件标示也是 0,所 以线程1 加锁成功
     执行 unlockWithCondition:时，这时候会把condition由 0 修改为 1
     因为condition 修改为了  1， 会先走到 线程3，然后 线程3 又将 condition 修改为 3
     最后 走了 线程2 的流程
     */
}

- (void)nsrecursivelock
{
    NSRecursiveLock *rLock = [NSRecursiveLock new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            [rLock lock];
            if (value > 0) {
                NSLog(@"线程%d", value);
                RecursiveBlock(value - 1);
            }
            [rLock unlock];
        };
        RecursiveBlock(4);
    });
}

- (void)nscondition
{
    NSCondition *cLock = [NSCondition new];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lock];
        NSLog(@"线程1加锁成功");
        [cLock wait];
        NSLog(@"线程1");
        [cLock unlock];
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lock];
        NSLog(@"线程2加锁成功");
        [cLock wait];
        NSLog(@"线程2");
        [cLock unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        NSLog(@"唤醒一个等待的线程");
        [cLock signal];
    });
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(2);
//        NSLog(@"唤醒所有等待的线程");
//        [cLock broadcast];
//    });
    
    //等待2秒后,再解锁.
    //线程4
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"start");
//        [cLock lock];
//        [cLock waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
//        NSLog(@"线程4");
//        [cLock unlock];
//    });
    /*
     
     */
}

- (void)synchronized
{
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (self) {
            sleep(2);
            NSLog(@"线程1");
        }
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (self) {
            NSLog(@"线程2");
        }
    });
}

- (void)dispatch_semaphore
{
    //    dispatch_semaphore_create(long value);
    //
    //    dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout);
    //
    //    dispatch_semaphore_signal(dispatch_semaphore_t dsema);
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(1); //传入值必须 >=0, 若传入为0则阻塞线程并等待timeout,时间到后会执行其后的语句
    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 等待ing");
        dispatch_semaphore_wait(signal, overTime); //signal 值 -1
        NSLog(@"线程1");
        dispatch_semaphore_signal(signal); //signal 值 +1
        NSLog(@"线程1 发送信号");
        NSLog(@"--------------------------------------------------------");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 等待ing");
        dispatch_semaphore_wait(signal, overTime);
        NSLog(@"线程2");
        dispatch_semaphore_signal(signal);
        NSLog(@"线程2 发送信号");
    });
    /*
     初始值 == 0
     2017-01-23 12:51:46.624 low-level-analyse[31705:761948] 线程1 等待ing
     2017-01-23 12:51:46.624 low-level-analyse[31705:761944] 线程2 等待ing
     2017-01-23 12:51:49.694 low-level-analyse[31705:761948] 线程1
     2017-01-23 12:51:49.694 low-level-analyse[31705:761944] 线程2
     2017-01-23 12:51:49.694 low-level-analyse[31705:761948] 线程1 发送信号
     2017-01-23 12:51:49.694 low-level-analyse[31705:761944] 线程2 发送信号
     2017-01-23 12:51:49.694 low-level-analyse[31705:761948] --------------------------------------------------------
     */
    /*
     初始值 > 0
     2017-01-23 13:51:45.666 low-level-analyse[32716:805486] 线程1 等待ing
     2017-01-23 13:51:45.666 low-level-analyse[32716:805497] 线程2 等待ing
     2017-01-23 13:51:45.668 low-level-analyse[32716:805486] 线程1
     2017-01-23 13:51:45.682 low-level-analyse[32716:805486] 线程1 发送信号
     2017-01-23 13:51:45.682 low-level-analyse[32716:805497] 线程2
     2017-01-23 13:51:45.683 low-level-analyse[32716:805486] --------------------------------------------------------
     2017-01-23 13:51:45.695 low-level-analyse[32716:805497] 线程2 发送信号

     */
    
}

- (void)asspinlock
{
    static OSSpinLock oslock = OS_SPINLOCK_INIT;
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 准备上锁");
        OSSpinLockLock(&oslock);
        sleep(4);
        NSLog(@"线程1");
        //关键代码
//        OSSpinLockUnlock(&oslock);
        NSLog(@"线程1 解锁成功");
        NSLog(@"--------------------------------------------------------");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 准备上锁");
        OSSpinLockLock(&oslock);
        NSLog(@"线程2");
        OSSpinLockUnlock(&oslock);
        NSLog(@"线程2 解锁成功");
    });
    /*
     2017-01-23 12:57:46.400 low-level-analyse[31810:765910] 线程1 准备上锁
     2017-01-23 12:57:46.400 low-level-analyse[31810:765920] 线程2 准备上锁
     2017-01-23 12:57:50.473 low-level-analyse[31810:765910] 线程1
     2017-01-23 12:57:50.473 low-level-analyse[31810:765910] 线程1 解锁成功
     2017-01-23 12:57:50.474 low-level-analyse[31810:765910] --------------------------------------------------------
     2017-01-23 12:57:50.474 low-level-analyse[31810:765920] 线程2
     2017-01-23 12:57:50.474 low-level-analyse[31810:765920] 线程2 解锁成功
     
     当我们锁住线程1时，在同时锁住线程2的情况下，线程2会一直等待（自旋锁不会让等待的进入睡眠状态），直到线程1的任务执行完且解锁完毕，线程2会立即执行；
     */
//    注释掉 关键代码 后的表现...锁还是要成对出现的
    /*
     2017-01-23 13:14:29.832 low-level-analyse[32172:779281] 线程2 准备上锁
     2017-01-23 13:14:29.832 low-level-analyse[32172:779271] 线程1 准备上锁
     2017-01-23 13:14:29.832 low-level-analyse[32172:779281] 线程2
     2017-01-23 13:14:29.833 low-level-analyse[32172:779281] 线程2 解锁成功
     2017-01-23 13:14:33.903 low-level-analyse[32172:779271] 线程1
     2017-01-23 13:14:33.904 low-level-analyse[32172:779271] 线程1 解锁成功
     2017-01-23 13:14:33.904 low-level-analyse[32172:779271] --------------------------------------------------------
     */
}


- (void)pthread_mutex
{
    static pthread_mutex_t pLock;
    pthread_mutex_init(&pLock, NULL);
    //1.线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 准备上锁");
        pthread_mutex_lock(&pLock);
        sleep(3);
        NSLog(@"线程1");
        pthread_mutex_unlock(&pLock);
    });
    //1.线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        NSLog(@"线程2 准备上锁");
        NSLog(@"%d",pthread_mutex_trylock(&pLock));
        pthread_mutex_lock(&pLock);
        NSLog(@"线程2");
        pthread_mutex_unlock(&pLock);
    });
}

- (void)pthread_mutex_recursive
{
    static pthread_mutex_t pLock;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr); //初始化attr并且给它赋予默认
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); //设置锁类型，这边是设置为递归锁
    pthread_mutex_init(&pLock, &attr);//根据attr,初始化锁.
    pthread_mutexattr_destroy(&attr); //销毁一个属性对象，在重新进行初始化之前该结构不能重新使用
    
    //1.线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            pthread_mutex_lock(&pLock);
            if (value > 0) {
                NSLog(@"value: %d", value);
                RecursiveBlock(value - 1);
            }
            pthread_mutex_unlock(&pLock);
        };
        RecursiveBlock(5);
    });
    
}

@end
