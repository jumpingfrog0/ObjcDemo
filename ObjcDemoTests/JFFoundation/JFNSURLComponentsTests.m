//
//  JFNSURLComponentsTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSURLComponentsTests : XCTestCase
@end

@implementation JFNSURLComponentsTests

- (void)testParameters
{
    NSURL *url = [NSURL URLWithString:@"https://example.com/path?name=JF&city=SZ&invalid"];
    NSDictionary *params = [url jf_parameters];
    XCTAssertEqualObjects(params[@"name"], @"JF");
    XCTAssertEqualObjects(params[@"city"], @"SZ");
    XCTAssertNil(params[@"invalid"]);
}

- (void)testAppendingQuery
{
    NSURL *url = [NSURL URLWithString:@"https://example.com/path?name=JF"];
    NSURL *newURL = [url jf_URLByAppendingQueryString:@"page=1"];
    XCTAssertEqualObjects(newURL.absoluteString, @"https://example.com/path?name=JF&page=1");

    NSURL *dictURL = [url jf_URLByAddQueriesFromDictionary:@{@"keyword": @"demo"}];
    XCTAssertTrue([dictURL.absoluteString containsString:@"keyword=demo"]);
}

@end
