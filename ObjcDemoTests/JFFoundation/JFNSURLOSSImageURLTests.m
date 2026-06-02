//
//  JFNSURLOSSImageURLTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSURLOSSImageURLTests : XCTestCase
@end

@implementation JFNSURLOSSImageURLTests

- (void)testEmptyAndInvalidURL
{
    XCTAssertNil([NSURL jf_webpWithUrlStr:@""]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    XCTAssertNil([NSURL jf_webpWithUrlStr:nil]);
#pragma clang diagnostic pop
}

- (void)testBasicWebpURL
{
    NSURL *url = [NSURL jf_webpWithUrlStr:@"https://img.example.com/a.jpg"];
    XCTAssertEqualObjects(url.absoluteString, @"https://img.example.com/a.jpg?x-oss-process=image/format,webp");
}

- (void)testResizeQualityAndModes
{
    CGFloat scale = UIScreen.mainScreen.scale;
    NSURL *url = [NSURL jf_webpWithUrlStr:@"https://img.example.com/a.jpg"
                                    width:10
                                   height:20
                                  quality:0.8
                                     mode:JFWebpUrlContentModeScaleAspectFit];
    NSString *expectedWidth = [NSString stringWithFormat:@"w_%.0f", ceil(10 * scale)];
    NSString *expectedHeight = [NSString stringWithFormat:@"h_%.0f", ceil(20 * scale)];
    XCTAssertTrue([url.absoluteString containsString:@"resize,m_lfit"]);
    XCTAssertTrue([url.absoluteString containsString:expectedWidth]);
    XCTAssertTrue([url.absoluteString containsString:expectedHeight]);
    XCTAssertTrue([url.absoluteString containsString:@"quality,q_80"]);
    XCTAssertTrue([url.absoluteString hasSuffix:@"format,webp"]);

    NSURL *fillURL = [NSURL jf_webpWithUrlStr:@"https://img.example.com/a.jpg" width:10 height:20 quality:0.5 mode:JFWebpUrlContentModeScaleAspectFill];
    NSURL *mfitURL = [NSURL jf_webpWithUrlStr:@"https://img.example.com/a.jpg" width:10 height:20 quality:0.5 mode:JFWebpUrlContentModeScaleAspectFillOver];
    NSURL *fixedURL = [NSURL jf_webpWithUrlStr:@"https://img.example.com/a.jpg" width:10 height:20 quality:0.5 mode:JFWebpUrlContentModeScaleToFill];
    XCTAssertTrue([fillURL.absoluteString containsString:@"resize,m_fill"]);
    XCTAssertTrue([mfitURL.absoluteString containsString:@"resize,m_mfit"]);
    XCTAssertTrue([fixedURL.absoluteString containsString:@"resize,m_fixed"]);
}

- (void)testQueryCleanAndQualityRange
{
    NSURL *queryURL = [NSURL jf_webpWithUrlStr:@"https://img.example.com/a.jpg?token=1" quality:0.5];
    XCTAssertTrue([queryURL.absoluteString containsString:@"&x-oss-process="]);
    XCTAssertTrue([queryURL.absoluteString containsString:@"quality,q_50"]);

    NSURL *cleanURL = [NSURL jf_webpWithUrlStr:@"https://img.example.com/a.jpg?ips_thumbnail=1#frag" width:10];
    XCTAssertFalse([cleanURL.absoluteString containsString:@"ips_thumbnail"]);
    XCTAssertFalse([cleanURL.absoluteString containsString:@"#frag"]);

    NSURL *invalidQualityURL = [NSURL jf_webpWithUrlStr:@"https://img.example.com/a.jpg" quality:1];
    XCTAssertFalse([invalidQualityURL.absoluteString containsString:@"quality"]);
}

@end
