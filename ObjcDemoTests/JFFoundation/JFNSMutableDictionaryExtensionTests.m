//
//  JFNSMutableDictionaryExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSMutableDictionaryExtensionTests : XCTestCase
@end

@implementation JFNSMutableDictionaryExtensionTests

- (void)testSafeSetObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict jf_safeSetObject:@"value" forKey:@"key"];
    XCTAssertEqualObjects(dict[@"key"], @"value");

    [dict jf_safeSetObject:@"new" forKey:@"key"];
    XCTAssertEqualObjects(dict[@"key"], @"new");

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    XCTAssertNoThrow([dict jf_safeSetObject:nil forKey:@"nil"]);
    XCTAssertNoThrow([dict jf_safeSetObject:@"value" forKey:nil]);
#pragma clang diagnostic pop
    XCTAssertEqual(dict.count, 1);
}

@end
