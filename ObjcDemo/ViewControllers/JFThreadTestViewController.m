//
//  JFThreadTestViewController.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/4/13.
//

#import "JFThreadTestViewController.h"

@interface JFThreadTestViewController ()

@property (nonatomic, strong) NSThread *innerThread;

@property (nonatomic, assign) BOOL isStopped;

@end

@implementation JFThreadTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self initViews];
    [self initLiveThread];
}

- (void)initViews
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"开始执行" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startTask) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"结束" forState:UIControlStateNormal];
    [button2.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [button2 setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(stopLiveThread) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(100, 200, 100, 50);
    [self.view addSubview:button2];
}

- (void)initLiveThread
{
    __weak typeof(self) weakSelf = self;
    self.innerThread = [[NSThread alloc] initWithBlock:^{
        
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        
        NSLog(@"%@", runloop);
        
        // 添加Port到RunLoop
//        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        while (weakSelf && !weakSelf.isStopped) {
            
            NSLog(@"do while");
            
            // 开启RunLoop
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//            [[NSRunLoop currentRunLoop] run];
        }
        
        NSLog(@"after do while");
        
        NSLog(@"%@", runloop);
        
    }];
    [self.innerThread start];
}

- (void)run
{
    if (!self.innerThread) {
        return;
    }
    
    [self.innerThread start];
}

- (void)startTask
{
    if (!self.innerThread) {
        return;
    }
    
    [self performSelector:@selector(execTask) onThread:self.innerThread withObject:nil waitUntilDone:NO];
}

- (void)execTask
{
    NSLog(@"%s %@ 执行了 execTask", __func__, [NSThread currentThread]);
}

- (void)stopLiveThread
{
    self.isStopped = YES;
    
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    NSLog(@"stop Live Thread loop");
}

@end
