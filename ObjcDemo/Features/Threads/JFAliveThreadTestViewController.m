//
//  JFAliveThreadTestViewController.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/4/14.
//

#import "JFAliveThreadTestViewController.h"
#import "AliveThread.h"

@interface JFAliveThreadTestViewController ()

@property (strong, nonatomic) AliveThread *thread;

@end

@implementation JFAliveThreadTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.thread = [[AliveThread alloc] init];
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
        NSLog(@"111111111");
        NSLog(@"222222");
        NSLog(@"3333333");
    }];
}

@end
