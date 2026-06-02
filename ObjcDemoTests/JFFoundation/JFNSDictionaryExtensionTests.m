//
//  JFNSDictionaryExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSDictionaryExtensionTests : XCTestCase
@end

@implementation JFNSDictionaryExtensionTests

- (void)testJSONString
{
    NSDictionary *dict = @{@"name": @"JF", @"count": @2};
    XCTAssertTrue([dict jf_JSONString].length > 0);
    XCTAssertTrue([dict jf_prettyJSONString].length > [dict jf_JSONString].length);
}

- (void)testURLHelpers
{
    NSString *query = [@{@"name": @"JF", @"city": @"深圳"} jf_joinURLQueries];
    XCTAssertTrue([query containsString:@"name=JF"]);
    NSDictionary *params = [NSDictionary jf_paramsForURLString:@"https://example.com?a=1&b=hello"];
    XCTAssertEqualObjects(params[@"a"], @"1");
    XCTAssertEqualObjects(params[@"b"], @"hello");
}

- (void)testFilterEmptyData
{
    NSDictionary *dict = @{@"name": @"JF",
                           @"empty": @"",
                           @"nullString": @"<null>",
                           @"null": [NSNull null],
                           @"nested": @{@"city": @"SZ", @"none": @""}};
    NSDictionary *filtered = [dict jf_filterEmptyData];
    NSDictionary *expectedNested = @{@"city": @"SZ", @"none": @""};
    XCTAssertEqualObjects(filtered[@"name"], @"JF");
    XCTAssertEqualObjects(filtered[@"empty"], @"");
    XCTAssertNil(filtered[@"nullString"]);
    XCTAssertNil(filtered[@"null"]);
    XCTAssertEqualObjects(filtered[@"nested"], expectedNested);
}

@end
