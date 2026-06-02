//
//  JFNSLocaleExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSLocaleExtensionTests : XCTestCase
@end

@implementation JFNSLocaleExtensionTests

- (void)testSimplifiedChineseLocale
{
    XCTAssertTrue([[NSLocale jf_simplifiedChineseLocale].localeIdentifier hasPrefix:@"zh"]);
}

@end
