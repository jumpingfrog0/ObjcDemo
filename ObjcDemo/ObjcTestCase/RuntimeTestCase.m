//
//  RuntimeTestCase.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/3/28.
//

#import "RuntimeTestCase.h"
#import "Teacher.h"
#import "Student.h"

@implementation RuntimeTestCase

- (void)runTest
{
    // initialize
    [self testInitialize];
//    [self testInitialize2];
}

#pragma mark - initialize

- (void)testInitialize
{
    /**
    打印：
    JFPerson initialize, class = JFPerson
    JFPerson initialize, class = Student
    JFPerson initialize, class = Teacher
    */
    [Student alloc];
    [Teacher alloc];
//    [JFPerson alloc];
}

- (void)testInitialize2
{
    /**
    打印：
    JFPerson initialize, class = JFPerson
    JFPerson initialize, class = Student
    JFPerson initialize, class = Teacher
    */
    [JFPerson alloc];
    [JFPerson alloc];
    [Student alloc];
    [Teacher alloc];
    [Student alloc];
    [Teacher alloc];
}

@end
