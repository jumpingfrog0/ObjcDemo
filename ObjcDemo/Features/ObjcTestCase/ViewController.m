//
//  ViewController.m
//  ObjcDemo
//
//  Created by huangdonghong on 2024/1/27.
//

#import "ViewController.h"
#import <objc/runtime.h>

#import "JFTest_KVC_KVO_ViewController.h"
#import "JFThreadTestViewController.h"
#import "JFAliveThreadTestViewController.h"

#import "UITapDebounceManager.h"

#import "BlockTestCase.h"
#import "RuntimeTestCase.h"
#import "ThreadTestCase.h"
#import "OtherTestCase.h"
#import "MemoryTestCase.h"

#pragma mark - 内存对齐

struct Struct1 {
    double a;
    char b;
    int c;
    short d;
}s1;

struct Struct3 {
    double a;           // 8    [0，7]
    int b;              // 4    [8，11]
    char c;             // 1    [12]
    short d;            // 2    (13, [14，15]
    int e;              // 4    [16, 19]
    struct Struct3_1 {
        double a;       // 8    (20, 21, 22, 23, [24, 31]
        char b;         // 1    [32]
        int c;          // 4    (33, 34, 35 [36, 39]
        short d;        // 2    [40, 41]，42, 43, 44, 45, 46, 47, 48
    }s1;
}s3;

#pragma mark - 位域&联合体

// 使用位域前结构体
struct Struct4 {
    BOOL a;
    BOOL b;
    BOOL c;
    BOOL d;
}s4;

// 使用位域后结构体
struct Struct5 {
    BOOL a : 1;
    BOOL b : 1;
    BOOL c : 1;
    BOOL d : 1;
}s5;

struct Struct0 {
    int d;
}s0;

union Union1 {
    int a;
    int b;
    int c;
    struct Struct0 st;
};

union Union2 {
    char s[9];
    int n;
    double d;
};

#   define ISA_MAGIC_VALUE_2 0x001d800000000001ULL
#   define ISA_BITFIELD_2                                                        \
      uintptr_t nonpointer        : 1;                                         \
      uintptr_t has_assoc         : 1;                                         \
      uintptr_t has_cxx_dtor      : 1;                                         \
      uintptr_t shiftcls          : 44; /*MACH_VM_MAX_ADDRESS 0x7fffffe00000*/ \
      uintptr_t magic             : 6;                                         \
      uintptr_t weakly_referenced : 1;                                         \
      uintptr_t unused            : 1;                                         \
      uintptr_t has_sidetable_rc  : 1;                                         \
      uintptr_t extra_rc          : 8

union isa_t_2 {
//    isa_t_2() { }
//    isa_t_2(uintptr_t value) : bits(value) { }

    uintptr_t bits;

//private:
//    // Accessing the class requires custom ptrauth operations, so
//    // force clients to go through setClass/getClass by making this
//    // private.
    Class cls;
    struct {
        ISA_BITFIELD_2;  // defined in isa.h
    };

};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
    // 内存字节对齐
//    [self bitsAlign];
//
//    // 联合体
//    [self unionDemo];
//
//    // 模拟 isa 原理
//    [self isa_theory];
    
    // 位域
//    [self bitsField];
    
//    RuntimeTestCase *runtime = [[RuntimeTestCase alloc] init];
//    [runtime runTest];
//
//    BlockTestCase *block = [[BlockTestCase alloc] init];
//    [block runTest];
    
//    ThreadTestCase *thread = [ThreadTestCase new];
//    [thread runTest];
    
//    OtherTestCase *other = [OtherTestCase new];
//    [other runTest];
    
//    MemoryTestCase *memory = [MemoryTestCase new];
//    [memory runTest];
}

- (void)bitsField
{
    // 位域
    struct Struct4 s1;
    struct Struct5 s2;
    struct Struct5 s3;
    s3.a = 1;
    s3.b = 1;
    s3.c = 0;
    s3.d = 1;
    
    printf("s1 size: %lu\n", sizeof(s1));  // 输出 4
    printf("s2 size: %lu\n", sizeof(s2));  // 输出 1
    printf("s3 size: %lu\n", sizeof(s3));  // 输出 1
}

- (void)bitsAlign
{
    // 内存字节对齐
    printf("Struct1 size: %lu\n", sizeof(s0));  // 输出 4
    printf("Struct1 size: %lu\n", sizeof(s1));  // 输出 24
    printf("Struct1 size: %lu\n", sizeof(s3));  // 输出 48
}

- (void)unionDemo
{
    // 联合体
    struct Struct0 st;
    st.d = 10;
    
    union Union1 u1;
    printf("Union1 size: %lu\n", sizeof(u1));  // 输出 4
    printf("%p\n",&u1);
    
    u1.a = 1;
    printf("%p, u1.a = %d, u1.b = %d, u1.c = %d, u1.st.d = %d\n", &u1.a, u1.a, u1.b, u1.c, u1.st.d);          // 输出 1
    
    u1.b = 2;
    printf("%p, u1.a = %d, u1.b = %d, u1.c = %d, u1.st.d = %d\n", &u1.a, u1.a, u1.b, u1.c, u1.st.d);          // 输出 2
    
    u1.c = 3;
    u1.st = st;
    
    printf("%p, u1.a = %d\n",&u1.a, u1.a);          // 输出 10
    printf("%p, u1.b = %d\n",&u1.b, u1.b);          // 输出 10
    printf("%p, u1.c = %d\n",&u1.c, u1.c);          // 输出 10
    printf("%p, u1.st.d = %d\n",&u1.st, u1.st.d);   // 输出 10
    
    union Union2 u2;
    u2.n = 1;
    u2.d = 2;
    printf("Union2 size: %lu\n", sizeof(u2));  // 输出 16
}

- (void)isa_theory
{
    // 实际上就是 objc_object::getIsa() ===> (isa.bits & ISA_MASK)，即 (isa.bits & 0x00007ffffffffff8ULL)
    object_getClass(self);
    
    // 模拟 isa 原理
    /*
     initIsa 核心逻辑：
     newisa.bits = ISA_MAGIC_VALUE;
     // isa.magic is part of ISA_MAGIC_VALUE
     // isa.nonpointer is part of ISA_MAGIC_VALUE
     newisa.has_cxx_dtor = hasCxxDtor;
     newisa.shiftcls = (uintptr_t)cls >> 3;
     */
    union isa_t_2 newisa;
    newisa.bits = ISA_MAGIC_VALUE_2;
    newisa.shiftcls = (uintptr_t)[ViewController class] >> 3;
}

#pragma mark - kVC & KVO

- (void)initViews
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Test KVC_KVO" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jumpToKVC_KVO_Page) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"Test Live Thread" forState:UIControlStateNormal];
    [button2.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [button2 setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(openLiveThreadPage) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(100, 200, 200, 50);
    [self.view addSubview:button2];
}

- (void)jumpToKVC_KVO_Page
{
    JFTest_KVC_KVO_ViewController *vc = [[JFTest_KVC_KVO_ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openLiveThreadPage
{
    JFThreadTestViewController *vc = [JFThreadTestViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)test3
{
    // UIView 点击防抖
    UIView *customView = [[UIView alloc] init];
    [customView addTapDebounceWithDelay:0.5 immediateFirst:YES action:^{
        NSLog(@"View tapped!");
    }];

    // UIButton 点击防抖
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTapDebounceWithDelay:0.5 immediateFirst:YES action:^{
        NSLog(@"Button tapped!");
    }];
}

@end
