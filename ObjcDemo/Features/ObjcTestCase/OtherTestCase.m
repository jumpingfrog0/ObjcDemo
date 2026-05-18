//
//  OtherTestCase.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/4/7.
//

#import "OtherTestCase.h"
#import "Student.h"

@implementation OtherTestCase

- (void)runTest
{
//    [self test1];
    [self test2];
}

- (void)test1
{
    NSMutableDictionary *mDict = @{@"1":@"1"}.mutableCopy;
    NSString *key = nil;
//    [mDict removeObjectForKey:key];
    
    NSNumber *num1 = @(1);
    NSNumber *num2 = nil;
//    [num1 isEqualToNumber:num2];
    
    Student *s = [Student new];
}

- (void)test2
{
    int a = 2;
    if (a == 1) {
        NSLog(@"111");
        goto done;
    }
    
    NSLog(@"222");
    
done:
    NSLog(@"333");
}

@end
