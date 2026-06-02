//
//  JFFloatUtilsTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFloatUtils.h>

@interface JFFloatUtilsTests : XCTestCase
@end

@implementation JFFloatUtilsTests

- (void)testFloatEqualityAndNormal
{
    XCTAssertTrue(JFFloatIsEqual(0.1f + 0.2f, 0.3f));
    XCTAssertTrue(JFFloatIsNormal(1.0f));
    XCTAssertTrue(JFFloatIsNormal(1.0));
    XCTAssertTrue(JFFloatIsNormal((long double)1.0));
}

@end
