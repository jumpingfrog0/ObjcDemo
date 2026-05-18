//
//  MemoryTestCase.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/4/9.
//

#import "MemoryTestCase.h"
#import "JFPerson.h"

@implementation MemoryTestCase

- (void)runTest
{
//    [self testObjCopy];
    [self testContainerCopy];
}

- (void)testObjCopy
{
    NSString *str = @"111";
    NSString *copy1 = [str copy];           // 浅复制，指针拷贝，地址不变
    NSString *copy2 = [str mutableCopy];    // 深复制，内容拷贝，地址变了
    
    NSMutableString *mStr = [NSMutableString stringWithFormat:@"222"];
    NSMutableString *copy3 = [mStr copy];           // 深复制，内容拷贝，地址变了
    NSMutableString *copy4 = [mStr mutableCopy];    // 深复制，内容拷贝，地址变了
    
    NSLog(@"%p - %p - %p", str, copy1, copy2);
    NSLog(@"%p - %p - %p", mStr, copy3, copy4);
}

- (void)testContainerCopy
{
    JFPerson *obj1 = [JFPerson new];
    obj1.wsName = @"111";
    
    JFPerson *obj2 = [JFPerson new];
    obj2.wsName = @"222";
    
    JFPerson *obj3 = [JFPerson new];
    obj3.wsName = @"333";
    NSLog(@"%p - %p - %p", obj1, obj2, obj3);
    
    NSArray *arr = @[obj1, obj2, obj3];
    NSArray *copy1 = [arr copy];            // 单层浅复制，指针拷贝，地址不变
    NSArray *copy2 = [arr mutableCopy];     // 单层深复制，内容拷贝，地址变了
    
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:arr];
    NSMutableArray *copy3 = [mArr copy];        // 单层深复制，内容拷贝，地址变了
    NSMutableArray *copy4 = [mArr mutableCopy]; // 单层深复制，内容拷贝，地址变了
    
    NSLog(@"%p - %p - %p", arr, copy1, copy2);
    NSLog(@"%p - %p - %p", mArr, copy3, copy4);
    
    JFPerson *copy1_obj1 = copy1[0];
    JFPerson *copy2_obj2 = copy1[1];
    
    NSLog(@"%@ - %@ - %@", obj1.wsName, copy1_obj1.wsName, copy2_obj2.wsName);
    
    copy1_obj1.wsName = @"copy1";
    copy2_obj2.wsName = @"copy2";
    
    NSLog(@"%@ - %@ - %@", obj1.wsName, copy1_obj1.wsName, copy2_obj2.wsName);
}

@end
