//
//  JFNSDictionarySafeTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSDictionarySafeTests : XCTestCase
@end

@implementation JFNSDictionarySafeTests

- (NSDictionary *)sampleDictionary
{
    return @{@"string": @"hello",
             @"number": @7,
             @"array": @[@"a"],
             @"dict": @{@"k": @"v"},
             @"data": [@"data" dataUsingEncoding:NSUTF8StringEncoding],
             @"null": [NSNull null],
             @"numberString": @"9"};
}

- (void)testSafeTypedValues
{
    NSDictionary *dict = [self sampleDictionary];
    XCTAssertEqualObjects([dict jf_safeStringForKey:@"string"], @"hello");
    XCTAssertEqualObjects([dict jf_safeNumberForKey:@"number"], @7);
    NSArray *expectedArray = @[@"a"];
    NSDictionary *expectedDictionary = @{@"k": @"v"};
    XCTAssertEqualObjects([dict jf_safeArrayForKey:@"array"], expectedArray);
    XCTAssertEqualObjects([dict jf_safeDictionaryForKey:@"dict"], expectedDictionary);
    XCTAssertGreaterThan([dict jf_safeDataForKey:@"data"].length, 0);
}

- (void)testSafeNilAndDefaultValues
{
    NSDictionary *dict = [self sampleDictionary];
    XCTAssertEqualObjects([dict jf_safeStringForKey:@"missing"], @"");
    XCTAssertNil([dict jf_safeStringOrNilForKey:@"missing"]);
    XCTAssertEqualObjects([dict jf_safeNumberForKey:@"missing"], @0);
    XCTAssertNil([dict jf_safeNumberOrNilForKey:@"missing"]);
    NSArray *emptyArray = @[];
    NSDictionary *emptyDictionary = @{};
    XCTAssertEqualObjects([dict jf_safeArrayForKey:@"missing"], emptyArray);
    XCTAssertNil([dict jf_safeArrayOrNilForKey:@"missing"]);
    XCTAssertEqualObjects([dict jf_safeDictionaryForKey:@"missing"], emptyDictionary);
    XCTAssertNil([dict jf_safeDictionaryOrNilForKey:@"missing"]);
    XCTAssertEqualObjects([dict jf_safeStringForKey:@"missing" defaultValue:@"fallback"], @"fallback");
    XCTAssertEqualObjects([dict jf_safeNumberForKey:@"missing" defaultValue:@8], @8);
    NSArray *fallbackArray = @[@"fallback"];
    NSDictionary *fallbackDictionary = @{@"fallback": @"1"};
    XCTAssertEqualObjects([dict jf_safeArrayForKey:@"missing" defaultValue:fallbackArray], fallbackArray);
    XCTAssertEqualObjects([dict jf_safeDictionaryForKey:@"missing" defaultValue:fallbackDictionary], fallbackDictionary);
}

- (void)testCompatibleAndExpectedClassValues
{
    NSDictionary *dict = [self sampleDictionary];
    NSDictionary *expectedDictionary = @{@"k": @"v"};
    XCTAssertEqualObjects([dict jf_safeStringForKeyCompatibleNumber:@"number"], @"7");
    XCTAssertEqualObjects([[dict jf_safeNumberForKeyCompatibleString:@"numberString"] description], @"9");
    XCTAssertEqualObjects([dict jf_safeObjectForKey:@"dict" expectedClass:NSDictionary.class], expectedDictionary);
    XCTAssertNil([dict jf_safeObjectForKey:@"null" expectedClass:NSString.class]);
    XCTAssertEqualObjects([dict jf_safeObjectForKey:@"missing" expectedClass:NSString.class defaultValue:@"fallback"], @"fallback");
}

@end
