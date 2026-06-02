//
//  JFNSArrayExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSArrayExtensionTests : XCTestCase
@end

@implementation JFNSArrayExtensionTests

- (void)testSafeAccess
{
    NSArray *array = @[@"a", @2, @[@"c"]];
    NSArray *expectedArray = @[@"c"];
    XCTAssertEqualObjects([array jf_objectAtIndex:0], @"a");
    XCTAssertNil([array jf_objectAtIndex:99]);
    XCTAssertEqualObjects([array jf_stringAtIndex:0], @"a");
    XCTAssertEqualObjects([array jf_numberAtIndex:1], @2);
    XCTAssertEqualObjects([array jf_arrayAtIndex:2], expectedArray);
    XCTAssertNil([array jf_stringAtIndex:1]);
}

- (void)testNavigationAndFiltering
{
    NSArray *array = @[@"a", @"b", @"c"];
    XCTAssertEqualObjects([array jf_nextObject:@"b"], @"c");
    XCTAssertEqualObjects([array jf_previousObject:@"b"], @"a");
    XCTAssertEqual([array jf_indexOfObjectWithFilter:^BOOL(id obj) {
        return [obj isEqual:@"b"];
    }], 1);
}

- (void)testMapFilterDistinctAndReverse
{
    NSArray *array = @[@"a", @"b", @"b", @"c"];
    NSArray *mapped = [array jf_map:^id(id obj) {
        return [obj uppercaseString];
    }];
    NSArray *filtered = [array jf_filter:^BOOL(id obj) {
        return ![obj isEqual:@"b"];
    }];
    NSArray *expectedMapped = @[@"A", @"B", @"B", @"C"];
    NSArray *expectedFiltered = @[@"a", @"c"];
    NSArray *expectedDistinct = @[@"a", @"b", @"c"];
    NSArray *expectedReversed = @[@"c", @"b", @"b", @"a"];
    XCTAssertEqualObjects(mapped, expectedMapped);
    XCTAssertEqualObjects(filtered, expectedFiltered);
    XCTAssertEqualObjects([array jf_distinctUnionArray], expectedDistinct);
    XCTAssertEqualObjects([array jf_reversed], expectedReversed);
}

- (void)testEnumMapping
{
    NSArray *array = @[@"zero", @"one", @"two"];
    XCTAssertEqualObjects([array jf_stringWithEnum:1], @"one");
    XCTAssertEqual([array jf_enumFromString:@"two"], 2);
    XCTAssertEqual([array jf_enumFromString:@"missing" default:9], 9);
}

@end
