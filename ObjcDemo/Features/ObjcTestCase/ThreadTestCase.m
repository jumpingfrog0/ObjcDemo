//
//  ThreadTestCase.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/3/28.
//

#import "ThreadTestCase.h"
#import "JFPerson.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThreadTestCase ()
@property (nonatomic, strong) NSArray *nonatomicArr;
@property (atomic, strong) NSArray *atomicArr;
@property (atomic, assign) int atomicNum;
@property (nonatomic, strong) JFPerson *person;

@property (nonatomic, strong) dispatch_semaphore_t dispatchSemaphore;
@property (nonatomic, strong) NSThread *innerThread;

@property (nonatomic, strong) NSMutableArray *mArray;

@property (nonatomic, strong) dispatch_queue_t ioQueue;

@end

@implementation ThreadTestCase

- (instancetype)init
{
    if (self = [super init]) {
        _mArray = [NSMutableArray array];
        _ioQueue = dispatch_queue_create("com.famo.privilege.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)runTest
{
//    [self crashTest];
//    [self testAtomic];
//    [self testAtomic2];
//    [self readWriteTest];
//    [self liveThreadTest];
//    [self testSemaphore];
    
//    __block UIBackgroundTaskIdentifier bgTask = UIBackgroundTaskInvalid;
//    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//         [[UIApplication sharedApplication] endBackgroundTask:bgTask];
//         bgTask = UIBackgroundTaskInvalid;
//    }];
    
//    [self performSelector:@selector(test) withObject:nil afterDelay:10.0];
    
    [self test2];
}

/// 多线程奔溃
- (void)crashTest
{
    for (int i = 0; i < 100000; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.nonatomicArr = @[@(i)];
            NSLog(@"%d, count:%ld", i, self.nonatomicArr.count);
        });
    }
}

/*
 * 因为是 atomic 的，getter setter 使用 os_unfair_lock 加锁了，所以get set 不会多线程奔溃
 */
- (void)testAtomic
{
    for (int i = 0; i < 100000; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.atomicArr = @[@(i)];
            NSLog(@"%d, count:%ld", i, self.atomicArr.count);
        });
    }
}

- (void)testAtomic2
{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 1000; i++) {
            self.atomicNum = self.atomicNum + 1;
            NSLog(@"任务1 atomicNum = %d", self.atomicNum);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 1000; i++) {
            self.atomicNum = self.atomicNum + 1;
            NSLog(@"任务2 atomicNum = %d", self.atomicNum);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"结束 atomicNum = %d", self.atomicNum);
    });
}

/// 多读单写
- (void)readWriteTest
{
    for (int i = 0; i < 100000; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.nonatomicArr = @[@(i)];
            NSLog(@"%d, count:%ld", i, self.nonatomicArr.count);
        });
    }
}

/// 线程保活
- (void)liveThreadTest
{
    dispatch_queue_t queue = dispatch_queue_create("com.test.liveThread", DISPATCH_QUEUE_SERIAL);
    self.dispatchSemaphore = dispatch_semaphore_create(0); //Dispatch Semaphore保证同步
    
    CGFloat semaphoreThreshold = 10;
    
    //创建子线程监控,并在子线程开启一个持续的loop用来进行监控
    dispatch_async(queue, ^{
        while (1) {
            NSLog(@"111");
//            long semaphoreWait = dispatch_semaphore_wait(self.dispatchSemaphore,
//                                                         dispatch_time(DISPATCH_TIME_NOW, semaphoreThreshold * NSEC_PER_SEC));
//            if (semaphoreWait > 0) {
//                NSLog(@"222 -- %ld", semaphoreWait);
//            }
        };
    });
}

- (void)testSemaphore
{
    [self performSelector:@selector(afterTest) withObject:nil afterDelay:2];
    
    dispatch_queue_t queue = dispatch_queue_create("com.test.liveThread", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        int semaphoreThreshold = 10;
        self.dispatchSemaphore = dispatch_semaphore_create(0);
        
        long semaphoreWait = dispatch_semaphore_wait(self.dispatchSemaphore,
                                                     dispatch_time(DISPATCH_TIME_NOW, semaphoreThreshold * NSEC_PER_SEC));
        
        if (semaphoreWait != 0)
        {
            NSLog(@"111");
        } else {
            NSLog(@"222");
        }
    });
}

- (void)afterTest
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"333");
        dispatch_semaphore_signal(self.dispatchSemaphore);
        NSLog(@"444");
//    });
}

// 测试多线程访问
- (void)test2
{
    for (int i = 0; i < 100000; i++) {
        dispatch_async(self.ioQueue, ^{
            [self.mArray addObject:@(i)];
            NSLog(@"子线程 - %d, thread: %@", i, [NSThread currentThread]);
        });
    }
    
    // 以下代码在主线程运行，会奔溃
//    for (int i = 0; i < 100000; i++) {
//        [self.mArray addObject:@(i)];
//        NSLog(@"主线程 - %d, thread: %@", i, [NSThread currentThread]);
//    }
    
    // 以下代码在主线程运行，异步任务，也会奔溃
//    for (int i = 0; i < 100000; i++) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.mArray addObject:@(i)];
//            NSLog(@"主线程 - %d, thread: %@", i, [NSThread currentThread]);
//        });
//    }
    
    // 以下代码在主线程运行，同步任务，肯定会奔溃
//    for (int i = 0; i < 100000; i++) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [self.mArray addObject:@(i)];
//            NSLog(@"主线程 - %d, thread: %@", i, [NSThread currentThread]);
//        });
//    }
    
    // 以下代码因为是同步任务，在ioQueue队列中不会创建新线程，不会奔溃
    for (int i = 0; i < 100000; i++) {
        dispatch_sync(self.ioQueue, ^{
            [self.mArray addObject:@(i)];
            NSLog(@"ioQueue 线程 - %d, thread: %@", i, [NSThread currentThread]);
        });
    }
}

@end
