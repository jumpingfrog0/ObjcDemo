//
//  JFPerson.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/2/29.
//

#import "JFPerson.h"

@implementation JFPerson

+ (instancetype)sharedInstance {
    static JFPerson *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)dealloc
{
    NSLog(@"JFPerson - dealloc");
}

+ (void)initialize
{
    NSLog(@"JFPerson initialize, class = %@", NSStringFromClass([self class]));
}

//- (void)setAge:(int)age{
//    _age = age;
//    NSLog(@"setAge: %d", age);
//}
//
//- (void)willChangeValueForKey:(NSString *)key{
//    [super willChangeValueForKey:key];
//    NSLog(@"willChangeValueForKey");
//}
//
//- (void)didChangeValueForKey:(NSString *)key{
//    NSLog(@"didChangeValueForKey - begin");
//    [super didChangeValueForKey:key];
//    NSLog(@"didChangeValueForKey - end");
//}

- (JFPerson *)retObj
{
    return [[JFPerson alloc] init];
}

+ (instancetype)retObj
{
    return [[JFPerson alloc] init];
}

@end
