//
//  JFNSErrorExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSErrorExtensionTests : XCTestCase
@end

@implementation JFNSErrorExtensionTests

- (void)testErrorCreation
{
    NSError *messageError = [NSError jf_errorWithMessage:@"失败"];
    XCTAssertEqualObjects(messageError.domain, JFErrorDomain);
    XCTAssertEqual(messageError.code, -2);
    XCTAssertEqualObjects(messageError.localizedDescription, @"失败");

    NSError *codeError = [NSError jf_errorWithCode:404 message:@"未找到"];
    XCTAssertEqualObjects(codeError.domain, JFErrorDomain);
    XCTAssertEqual(codeError.code, 404);
    XCTAssertEqualObjects(codeError.localizedDescription, @"未找到");
}

- (void)testNilMessageAndInstanceReplacement
{
    NSError *defaultError = [NSError jf_errorWithMessage:nil];
    XCTAssertEqualObjects(defaultError.localizedDescription, @"未知错误");

    NSError *origin = [NSError errorWithDomain:@"Origin" code:10 userInfo:@{NSLocalizedDescriptionKey: @"old"}];
    NSError *updated = [origin jf_errorWithMessage:@"new"];
    XCTAssertEqualObjects(updated.domain, @"Origin");
    XCTAssertEqual(updated.code, 10);
    XCTAssertEqualObjects(updated.localizedDescription, @"new");
}

@end
