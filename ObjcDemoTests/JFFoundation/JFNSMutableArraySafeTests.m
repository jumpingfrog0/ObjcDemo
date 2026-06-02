//
//  JFNSMutableArraySafeTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>
#import <JFFoundation/NSMutableArray+JFQueueStack.h>
#import <JFFoundation/NSMutableArray+JFSafe.h>

@interface JFNSMutableArraySafeTests : XCTestCase
@end

@implementation JFNSMutableArraySafeTests

- (void)testQueueAndStack
{
    NSMutableArray *array = [NSMutableArray array];
    [array jf_enqueue:@"first"];
    [array jf_enqueue:@"second"];
    XCTAssertEqualObjects([array jf_queueFront], @"first");
    XCTAssertEqualObjects([array jf_dequeue], @"first");
    [array jf_stackPush:@"last"];
    XCTAssertEqualObjects([array jf_stackPop], @"last");
}

- (void)testSafeMutationIgnoresInvalidInputs
{
    NSMutableArray *array = [NSMutableArray arrayWithObject:@"origin"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    [array jf_safeAddObject:nil];
    [array jf_safeInsertObject:nil atIndex:0];
    [array jf_safeReplaceObjectAtIndex:0 withObject:nil];
#pragma clang diagnostic pop
    [array jf_safeInsertObject:@"insert" atIndex:8];
    [array jf_safeReplaceObjectAtIndex:10 withObject:@"replace"];
    [array jf_safeRemoveObjectAtIndex:20];
    NSArray *expectedArray = @[@"origin"];
    XCTAssertEqualObjects(array, expectedArray);
}

- (void)testSafeRemoveAndPop
{
    NSMutableArray *empty = [NSMutableArray array];
    XCTAssertNoThrow([empty jf_safeRemoveFirstObject]);
    XCTAssertNoThrow([empty jf_safeRemoveLastObject]);
    XCTAssertNil([empty jf_safePopFirstObject]);
    XCTAssertNil([empty jf_safePopLastObject]);

    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"first", @"middle", @"last"]];
    XCTAssertEqualObjects([array jf_safePopFirstObject], @"first");
    XCTAssertEqualObjects([array jf_safePopLastObject], @"last");
    NSArray *expectedArray = @[@"middle"];
    XCTAssertEqualObjects(array, expectedArray);
    [array jf_safeRemoveLastObject];
    XCTAssertEqual(array.count, 0);
}

- (void)testUpsetDataKeepsElements
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"a", @"b", @"c"]];
    NSArray *upset = [array jf_upsetData];
    NSArray *expectedArray = @[@"a", @"b", @"c"];
    XCTAssertEqual(upset.count, array.count);
    XCTAssertEqualObjects([NSSet setWithArray:upset], [NSSet setWithArray:array]);
    XCTAssertEqualObjects(array, expectedArray);
}

@end
