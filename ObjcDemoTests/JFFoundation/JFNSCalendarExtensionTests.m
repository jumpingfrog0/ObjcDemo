//
//  JFNSCalendarExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSCalendarExtensionTests : XCTestCase
@end

@implementation JFNSCalendarExtensionTests

- (void)testNumberOfDays
{
    XCTAssertEqual([NSCalendar jf_numberOfDaysInYear:2024], 366);
    XCTAssertEqual([NSCalendar jf_numberOfDaysInYear:2023], 365);
    XCTAssertEqual([NSCalendar jf_numberOfDaysInYear:2024 month:2], 29);
    XCTAssertEqual([NSCalendar jf_numberOfDaysInYear:2023 month:2], 28);
}

@end
