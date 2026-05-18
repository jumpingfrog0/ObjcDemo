//
//  AutoReleasePoolTestCase.m
//  ObjcDemo
//
//  Created by huangdonghong on 2025/12/18.
//

#import "AutoReleasePoolTestCase.h"
#import "JFPerson.h"

extern void _objc_autoreleasePoolPrint(void);

@implementation AutoReleasePoolTestCase

- (void)runTest
{
    NSObject *a = [[NSObject alloc] init];
    NSLog(@"autorelease pool object: %@", a);
    _objc_autoreleasePoolPrint();

    JFPerson *p = [[JFPerson alloc] init];
    NSLog(@"autorelease pool person: %@", p);
    _objc_autoreleasePoolPrint();

    JFPerson *b = [p retObj];
    JFPerson *c = [JFPerson retObj];
    NSLog(@"autorelease pool returned objects: %@ %@", b, c);
    _objc_autoreleasePoolPrint();
}


@end
