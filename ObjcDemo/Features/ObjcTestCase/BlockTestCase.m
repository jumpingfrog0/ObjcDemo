//
//  BlockTestCase.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/3/28.
//

#import "BlockTestCase.h"

@implementation BlockTestCase

#pragma mark - block

int global_i = 1;
static int static_global_j = 2;

- (void)runTest
{
    //    [self testBlock];
        [self testBlock2];
    //    [self testBlock3];
}

- (void)testBlock
{
    // NSGlobalBlock
    NSLog(@"全局block --> 这是匿名全局Block %@", ^{
        NSLog(@"全局block");
    });
    
    void (^globalBlock1)(void) = ^{
        NSLog(@"全局block1");
    };
    NSLog(@"全局block --> 内部没有访问外部变量的Block %@", globalBlock1);
    
    void (^__weak globalBlock2)(void) = ^{
        NSLog(@"全局block2");
    };
    NSLog(@"全局block --> 用weak修饰也是全局Block %@", globalBlock2);
    
    static int static_k = 3;
    void (^globalBlock3)(void) = ^{
        NSLog(@"Block中 变量 = %d %d %d",global_i, static_global_j ,static_k);
    };
    NSLog(@"全局block --> 访问静态变量和全局变量的Block %@",globalBlock3);
        
    // NSMallocBlock
    int a = 10;
    NSLog(@"堆区block--> 内部访问外部变量，作为系统API参数的Block %@", ^{
        NSLog(@"堆区block，a = %d", a);
    });
    
    void (^mallocBlock)(void) = ^{
        NSLog(@"堆区block3，a = %d", a);
    };
    NSLog(@"堆区block --> 内部访问外部变量，有strong指针引用的Block %@", mallocBlock);
    
    // StackBlock
    void (^__weak stackBlock)(void) = ^{
        NSLog(@"栈区block，a = %d", a);
    };
    NSLog(@"栈区block --> 内部内部外部变量，但只有weak指针引用的Block %@", stackBlock);
    
    NSLog(@"栈区block --> 内部访问外部变量，但没有强指针引用的Block %@", [^{
        NSLog(@"%d",a);
    } class]);
    
    
    /*
     output:
     4 --> 0x600001c6c0f0
     5 --> 0x600001c6c0f0
     6 --> 0x600001c6c0f0
     2 --> 0x6000012521b8
     2 --> 0x6000012521b8
     */
    NSLog(@"4 --> %p", mallocBlock);
    void (^heapBlock)(void) = [mallocBlock copy];
    NSLog(@"5 --> %p", mallocBlock);
    NSLog(@"6 --> %p", heapBlock);
    mallocBlock();
    heapBlock();
}

- (void)testBlock2
{
    /*
     block前 --> 0x102e498c0
     block后 --> 0x102e498c0
     block中 --> 0x102e498c0
     block前 --> 0x102e498c8
     block后 --> 0x102e498c8
     block中 --> 0x102e498c8
     */
    NSLog(@"block前 --> %p", &global_i);
    void (^block)(void) = ^{
        NSLog(@"block中 --> %p", &global_i);
    };
    NSLog(@"block后 --> %p", &global_i);
    block();
    
    static int static_k = 3;
    NSLog(@"block前 --> %p", &static_k);
    void (^block2)(void) = ^{
        NSLog(@"block中 --> %p", &static_k);
    };
    NSLog(@"block后 --> %p", &static_k);
    block2();
    
    NSLog(@"----------------");
    
    /*
     output:
     block前 --> 0x30a09582c
     block后 --> 0x30a09582c
     block中 --> 0x6000036909b0
     */
    int a = 10;
    NSLog(@"block前 --> %p", &a);
    void (^block3)(void) = ^{
        NSLog(@"block中 --> %p", &a);
    };
    NSLog(@"block后 --> %p", &a);
    block3();
    
    NSLog(@"----------------");
    
    /*
     output:
     block前 --> 0x30a0957f0
     block后 --> 0x6000038a9078
     block中 --> 0x6000038a9078
     */
    __block int b = 10;
    NSLog(@"block前 --> %p", &b);
    void (^block4)(void) = ^{
        NSLog(@"block中 --> %p", &b);
    };
    NSLog(@"block后 --> %p", &b);
    block4();
    
    
}

- (void)testBlock3
{
//    NSObject *obj = [[NSObject alloc] init];
//    void (^__weak block)(void) = ^{
//        NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef)(obj)));
//    };
//    block();
    
    // 1. 内部没有调用外部变量的block
            void (^block1)(void) = ^{
                NSLog(@"Hello");
            };
            // 2. 内部调用外部变量的block
            int a = 10;
            void (^block2)(void) = ^{
                NSLog(@"Hello - %d",a);
            };
           // 3. 直接调用的block的class
            NSLog(@"%@ %@ %@", [block1 class], [block2 class], [^{
                NSLog(@"%d",a);
            } class]);
}

//int main(int argc, char * argv[]) {
//
////    __block int a = 10;
////    NSLog(@"1 --> %p", &a);
////    void (^block)(void) = ^{
////        NSLog(@"2 --> %p", &a);
////    };
////    NSLog(@"3 --> %p", &a);
////    block();
//
////    NSObject * obj  = [NSObject alloc];
////    void (^ block)(void) = ^{
////        NSLog(@"----%@",obj);
////    };
////    block();
//
//    int a = 10;
//    void (^ block)(void) = ^{
//        NSLog(@"----%d",a);
//    };
//    block();
//
//    return 0;
//}

//int global_i = 1;
//
//static int static_global_j = 2;

//int main(int argc, const char * argv[]) {
//
//    static int static_k = 3;
//    int val = 4;
//
//    void (^myBlock)(void) = ^{
//        global_i ++;
//        static_global_j ++;
//        static_k ++;
//        NSLog(@"Block中 global_i = %d,static_global_j = %d,static_k = %d,val = %d",global_i,static_global_j,static_k,val);
//    };
//
//    global_i ++;
//    static_global_j ++;
//    static_k ++;
//    val ++;
//    NSLog(@"Block外 global_i = %d,static_global_j = %d,static_k = %d,val = %d",global_i,static_global_j,static_k,val);
//
//    myBlock();
//
//    return 0;
//}

//int main(int argc, const char * argv[]) {
//
//    NSMutableString * str = [[NSMutableString alloc]initWithString:@"Hello,"];
//
//    void (^myBlock)(void) = ^{
//        [str appendString:@"World!"];
//        NSLog(@"Block中 str = %@",str);
//    };
//
//    NSLog(@"Block外 str = %@",str);
//
//    myBlock();
//
//    return 0;
//}

//int main(int argc, const char * argv[]) {
//
//    __block int i = 0;
//    NSLog(@"这是Block 外面 %p",&i);
//
//    void (^myBlock)(void) = ^{
//        i++;
//        NSLog(@"这是Block 里面 %p",&i);
//    };
//
//    NSLog(@"myBlock = %@", myBlock);
//    myBlock();
//
//    return 0;
//}

//int main(int argc, const char * argv[]) {
//
//    __block id block_obj = [[NSObject alloc]init];
//    id obj = [[NSObject alloc]init];
//
//    NSLog(@"block_obj = [%@ , %p] , obj = [%@ , %p]",block_obj , &block_obj , obj , &obj);
//
//    void (^myBlock)(void) = ^{
//        NSLog(@"----Block中----block_obj = [%@ , %p] , obj = [%@ , %p]",block_obj , &block_obj , obj , &obj);
//    };
//
//    myBlock();
//
//    return 0;
//}

@end
