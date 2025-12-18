//
//  AliveThread.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/4/14.
//

#import "AliveThread.h"

//LiveThread主要用于打印释放情况
@interface LiveThread : NSThread
@end

@implementation LiveThread

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end



@interface AliveThread ()

@property (nonatomic,strong) LiveThread * liveThread;
@property (nonatomic, assign) BOOL stopped;

@end

@implementation AliveThread

- (instancetype)init
{
    if (self = [super init]) {
        self.stopped = NO;
        
        __weak typeof(self) weakSelf = self;
        
        self.liveThread = [[LiveThread alloc] initWithBlock:^{
            NSLog(@"------常驻线程开启-------");
            
            NSRunLoop *runloop = [NSRunLoop currentRunLoop];
            NSLog(@"%@", runloop);
            
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            
            NSLog(@"------addPort 后-------");
            
            NSLog(@"%@", runloop);
            
            while (weakSelf && !weakSelf.stopped) {
                NSLog(@"do while");
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                NSLog(@"do while -- 2");
            }
            NSLog(@"------常驻线程结束------");
        }];
        
        [self.liveThread start];
    }
    return self;
}


- (void)executeTask:(AliveThreadTask)task
{
    if (!self.liveThread || !task) return;
    
    [self performSelector:@selector(realizeTask:) onThread:self.liveThread withObject:task waitUntilDone:NO];
}


-(void)realizeTask:(AliveThreadTask)task{
    
    task();
}

- (void)stop
{
    if (!self.liveThread) return;
    [self performSelector:@selector(liveThreadStop) onThread:self.liveThread withObject:nil waitUntilDone:YES];
}


-(void)liveThreadStop{
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.liveThread = nil;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self stop];
}
@end

