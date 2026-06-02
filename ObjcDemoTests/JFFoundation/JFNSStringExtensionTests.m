//
//  JFNSStringExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSStringExtensionTests : XCTestCase
@end

@implementation JFNSStringExtensionTests

- (void)testFormatAndDateStrings
{
    XCTAssertEqualObjects([NSString jf_timeStringWithInterval:3661], @"01:01:01");
    XCTAssertEqualObjects([NSString jf_timeStringWithInterval:61], @"01:01");
    XCTAssertTrue([[NSString jf_decimalStyleStringWithNum:@1234567] containsString:@","]);
    XCTAssertEqualObjects([NSString jf_millionStyleStringWithNum:12345678], @"1235万");
    XCTAssertTrue([[NSString jf_stringWithFormattedUnsignedInteger:1234567] containsString:@","]);
    XCTAssertTrue([NSString jf_timerDayStringWithInterval:(NSInteger)[NSDate date].timeIntervalSince1970].length > 0);
}

- (void)testStringEmptyAndLayoutHelpers
{
    UIFont *font = [UIFont systemFontOfSize:14];
    XCTAssertTrue([NSString jf_stringIsEmpty:nil]);
    XCTAssertTrue([NSString jf_stringIsEmpty:@" \n"]);
    XCTAssertFalse([NSString jf_stringIsEmpty:@"a"]);
    XCTAssertGreaterThan([NSString jf_heightForText:@"hello" inWidth:80 andFont:font], 0);
    XCTAssertGreaterThan([@"hello" jf_sizeWithFont:font].width, 0);
    XCTAssertGreaterThan([@"hello" jf_sizeWithMyFont:font].width, 0);
    XCTAssertGreaterThan([@"hello" jf_safeSizeWithFont:font].width, 0);
}

- (void)testRegularRealLengthAndTrim
{
    NSArray *expectedNumbers = @[@"12", @"34"];
    XCTAssertEqualObjects([@"a12b34c" jf_subStringByRegular:@"\\d+"], expectedNumbers);
    XCTAssertEqual([@"A😀中" jf_realLength], 3);
    XCTAssertEqualObjects([@"  hello JF  \n" jf_trim], @"hello JF");
    XCTAssertEqualObjects([@"  hello JF  " jf_trimmingWhiteSpaceAtBothEnd], @"hello JF");
    XCTAssertEqualObjects([@"\nhello JF\n" jf_trimmingNewlineAtBothEnd], @"hello JF");
    XCTAssertEqualObjects([@" a \r\nb " jf_removeAllSpaceAndNewLine], @"ab");
}

- (void)testUnicodeMaskPinyinAndReplace
{
    XCTAssertEqualObjects([@"\\u4f60\\u597d" jf_replaceUnicode], @"你好");
    XCTAssertEqualObjects([@"比邻" jf_replaceMEWithBilin], @"ME");
    XCTAssertTrue([[@"developer@example.com" jf_stringBySecuringAtMiddle] containsString:@"****"]);
    XCTAssertEqualObjects([@"13800138000" jf_maskPhone], @"138****8000");
    XCTAssertEqualObjects([@"86" jf_maskPhone], @"+86");
    XCTAssertEqualObjects([@"中文" jf_transformToPinyin], @"zhongwen");
    XCTAssertEqualObjects([@"中文" jf_transformToPinyinFirstLetter], @"zw");
}

- (void)testTruncatingHelpers
{
    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    XCTAssertEqualObjects([@"abcdef" jf_stringByTruncatingToLength:3], @"abc...");
    XCTAssertEqualObjects([@"abcdef" jf_stringByTruncatingToLength:3 ellipsis:NO], @"abc");
    XCTAssertEqualObjects([@"abcdef" jf_stringByTruncatingToLength:5 direction:JFTruncateStringPositionEnd withEllipsisString:@"..."], @"ab...");
    XCTAssertTrue([@"Objective-C" jf_stringByTruncatingToWidth:20 withFont:font].length > 0);
    XCTAssertTrue([@"Objective-C" jf_truncatingString:attributes maxWidth:40].length > 0);
    XCTAssertEqualObjects([@"A😀BC" jf_truncatedStringWithMaxLength:2], @"A😀…");
    XCTAssertEqualObjects([@"A😀BC" jf_safeSubStringWithMaxLength:2], @"A😀");
}

- (void)testURLAndValidationHelpers
{
    NSString *encoded = [@"name=小明&city=深圳" jf_urlEncode];
    XCTAssertEqualObjects([encoded jf_urlDecode], @"name=小明&city=深圳");
    XCTAssertEqualObjects([@"https://example.com?a=1&b=%E4%BD%A0%E5%A5%BD" jf_urlParams][@"b"], @"你好");
    XCTAssertEqualObjects([@"https://example.com" jf_stringByAddUrlParam:@"a" value:@"1"], @"https://example.com?a=1");
    XCTAssertEqualObjects([@"https://example.com?a=1" jf_URLStringByAppendingQueryString:@"b=2"], @"https://example.com?a=1&b=2");
    XCTAssertTrue([@"dev@example.com" jf_isValidEmail]);
    XCTAssertTrue([@"13800138000" jf_isValidPhone]);
}

- (void)testJSONXMLEscapeContainsAndNumericHelpers
{
    id json = [@"{\"name\":\"JF\",\"count\":2}" jf_JSONObject];
    XCTAssertTrue([json isKindOfClass:NSDictionary.class]);
    XCTAssertEqualObjects([@"&lt;tag&gt;&amp;" jf_filterXMLEscapeChar], @"<tag>&");
    XCTAssertTrue([@"Hello" jf_containsString:@"he"]);
    XCTAssertFalse([@"Hello" jf_containsString:@""]);
    XCTAssertEqual([@"12abc" jf_longValue], 12);
    XCTAssertEqual([@"12abc" jf_longLongValue], 12);
    XCTAssertEqual([@"a1b2c3" jf_unsignedLongLongValue], 123);
    XCTAssertTrue([@"123" jf_isPureInt]);
    XCTAssertFalse([@"123a" jf_isPureInt]);
    XCTAssertEqual([@"banana" jf_countOccurentceOfString:@"na"], 2);
    XCTAssertEqualObjects([@"abcabc" jf_stringByRemoveString:@"b"], @"acac");
    XCTAssertEqualObjects([NSString jf_mergeString1:@"A" string2:@"B"], @"AB");
}

@end
