//
//  AliveThread.h
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/4/14.
//

#import <Foundation/Foundation.h>

typedef void (^AliveThreadTask)(void);

@interface AliveThread : NSObject
/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(AliveThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end
