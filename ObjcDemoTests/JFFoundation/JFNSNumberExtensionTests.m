//
//  JFNSNumberExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSNumberExtensionTests : XCTestCase
@end

@implementation JFNSNumberExtensionTests

- (void)testLength
{
    XCTAssertEqual([@0 jf_length], 1);
    XCTAssertEqual([@123456 jf_length], 6);
}

@end
