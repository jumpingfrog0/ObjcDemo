//
//  JFTest_KVC_KVO_ViewController.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/2/29.
//

#import "JFTest_KVC_KVO_ViewController.h"
#import "JFPerson.h"
#import <objc/runtime.h>

@interface JFTest_KVC_KVO_ViewController ()

@property (nonatomic, strong) JFPerson *person;

@end

@implementation JFTest_KVC_KVO_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    // KVO 实现原理
    [self testKVO];
//    [self testKVO2];
//    [self testKVO3];
}

- (void)dealloc
{
//    [self.person removeObserver:self forKeyPath:@"age"];
//    [self.person removeObserver:self forKeyPath:@"dataArray"];
    
    NSLog(@"JFTest_KVC_KVO_ViewController - dealloc");
}

- (void)testKVO
{
    JFPerson *person1 = [[JFPerson alloc] init];
//    person1.age = 1;
//    self.person = person1;
//
////    NSLog(@"person1添加KVO监听对象之前-类对象 -%@", object_getClass(person1));
////    NSLog(@"person1添加KVO监听之前-方法实现 -%p", [person1 methodForSelector:@selector(setAge:)]);
////    NSLog(@"person1添加KVO监听之前-元类对象 -%@", object_getClass(object_getClass(person1)));
//
//    NSKeyValueObservingOptions option = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
//    [person1 addObserver:self forKeyPath:@"age" options:option context:@"person1 - age chage"];
//
////    NSLog(@"person1添加KVO监听对象之后-类对象 -%@", object_getClass(person1));
////    NSLog(@"person1添加KVO监听之后-方法实现 -%p", [person1 methodForSelector:@selector(setAge:)]);
////    NSLog(@"person1添加KVO监听之后-元类对象 -%@", object_getClass(object_getClass(person1)));
//
//    person1.age = 10;
}

/**
 注意：测试时，要注释掉 dealloc 移除KVO监听的代码
 
 被观察者JFPerson是单例，退出界面后，如果没有移除KVO监听，重新进入界面，此时上一个观察者 JFTest_KVC_KVO_ViewController 已经被释放，
 而JFPerson因为没有移除KVO，仍然是 isa-swizzling 的，因此在属性修改时仍然会发送 NSKVONotifying_xxx 通知，
 因此，在 setValue:forKey: 时会报错 EXC_BAD_ACCESS，类似野指针的崩溃
 */
- (void)testKVO2
{
    JFPerson *person2 = [JFPerson sharedInstance];
//    person2.age = 1;    // 这里会奔溃
//    self.person = person2;
//
//    NSLog(@"person2添加KVO监听对象之前-类对象 -%@", object_getClass(person2));
//    NSLog(@"person2添加KVO监听之前-方法实现 -%p", [person2 methodForSelector:@selector(setAge:)]);
//    NSLog(@"person2添加KVO监听之前-元类对象 -%@", object_getClass(object_getClass(person2)));
//
//    NSKeyValueObservingOptions option = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
//    [person2 addObserver:self forKeyPath:@"age" options:option context:@"person2 - age chage"];
//
//    NSLog(@"person2添加KVO监听对象之后-类对象 -%@", object_getClass(person2));
//    NSLog(@"person2添加KVO监听之后-方法实现 -%p", [person2 methodForSelector:@selector(setAge:)]);
//    NSLog(@"person2添加KVO监听之后-元类对象 -%@", object_getClass(object_getClass(person2)));
//
//    person2.age = 10;   // 如果上面的代码注释掉，则这里会奔溃
}

//- (void)testKVO3
//{
//    JFPerson *person3 = [[JFPerson alloc] init];
//    person3.dataArray = [NSMutableArray array];
//    self.person = person3;
//
//    NSLog(@"person3添加KVO监听对象之前-类对象 -%@", object_getClass(person3));
//    NSLog(@"person3添加KVO监听之前-方法实现 -%p", [person3 methodForSelector:@selector(setAge:)]);
//    NSLog(@"person3添加KVO监听之前-元类对象 -%@", object_getClass(object_getClass(person3)));
//
//    NSKeyValueObservingOptions option = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
//    [person3 addObserver:self forKeyPath:@"dataArray" options:option context:@"person3 - dataArray chage"];
//
//    NSLog(@"person3添加KVO监听对象之后-类对象 -%@", object_getClass(person3));
//    NSLog(@"person3添加KVO监听之后-方法实现 -%p", [person3 methodForSelector:@selector(setAge:)]);
//    NSLog(@"person3添加KVO监听之后-元类对象 -%@", object_getClass(object_getClass(person3)));
//
////    [person3.dataArray addObject:@"1"];
//    [[person3 mutableArrayValueForKey:@"dataArray"] addObject:@"1"];
//}


- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context;
{
    NSNumber *oldValue = change[NSKeyValueChangeOldKey];
    NSNumber *newValue = change[NSKeyValueChangeNewKey];
    NSLog(@"person KVO, keyPath = %@, context = %@, oldValue = %@, newValue = %@", keyPath, context, oldValue, newValue);
}

@end
