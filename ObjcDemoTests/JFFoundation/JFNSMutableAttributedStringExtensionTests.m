//
//  JFNSMutableAttributedStringExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSMutableAttributedStringExtensionTests : XCTestCase
@end

@implementation JFNSMutableAttributedStringExtensionTests

- (void)testStrikethrough
{
    NSAttributedString *string = [NSMutableAttributedString jf_strikethroughWithText:@"删除线文本"];
    XCTAssertEqualObjects(string.string, @"删除线文本");

    NSNumber *style = [string attribute:NSStrikethroughStyleAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertEqual(style.integerValue, NSUnderlineStyleSingle);
}

@end
