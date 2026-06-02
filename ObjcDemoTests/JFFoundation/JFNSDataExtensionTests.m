//
//  JFNSDataExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSDataExtensionTests : XCTestCase
@end

@implementation JFNSDataExtensionTests

- (void)testJSONAndMD5
{
    NSData *jsonData = [@"{\"ok\":true}" dataUsingEncoding:NSUTF8StringEncoding];
    id json = [jsonData jf_JSONObject];
    XCTAssertTrue([json isKindOfClass:NSDictionary.class]);
    XCTAssertEqualObjects(json[@"ok"], @YES);
    XCTAssertEqualObjects([jsonData jf_md5], @"82380d1e263b6093f3c7535690fcdd75");
}

- (void)testImageType
{
    NSData *pngData = [NSData dataWithBytes:"\x89PNG\r\n\x1a\n" length:8];
    NSData *jpegData = [NSData dataWithBytes:"\xff\xd8\xff" length:3];
    XCTAssertTrue([NSData jf_isPNGForImageData:pngData]);
    XCTAssertFalse([NSData jf_isJPEGForImageData:pngData]);
    XCTAssertTrue([NSData jf_isJPEGForImageData:jpegData]);
}

@end
