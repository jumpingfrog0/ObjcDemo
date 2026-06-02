//
//  JFNSDateExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSDateExtensionTests : XCTestCase
@end

@implementation JFNSDateExtensionTests

- (void)testDateCreationFormattingAndBoundaries
{
    NSDate *date = [NSDate jf_dateWithYear:2026 month:5 day:25];
    NSDate *parsed = [NSDate jf_dateFromString:@"2026-05-25" format:@"yyyy-MM-dd"];
    XCTAssertNotNil(parsed);
    XCTAssertEqualObjects([date jf_stringWithFormat:@"yyyy-MM-dd"], @"2026-05-25");
    XCTAssertEqualObjects([[date jf_beginningOfDay] jf_stringWithFormat:@"HH:mm:ss"], @"00:00:00");
    XCTAssertEqualObjects([[date jf_endOfDay] jf_stringWithFormat:@"HH:mm:ss"], @"23:59:59");
    XCTAssertEqualObjects([[date jf_beginningOfMonth] jf_stringWithFormat:@"yyyy-MM-dd"], @"2026-05-01");
    XCTAssertEqualObjects([[date jf_endOfMonth] jf_stringWithFormat:@"yyyy-MM-dd"], @"2026-05-31");
}

- (void)testDateAddingAndDistance
{
    NSDate *date = [NSDate jf_dateWithYear:2026 month:5 day:25];
    NSDate *nextWeek = [date jf_dateByAddingDays:7];
    XCTAssertEqualObjects([nextWeek jf_stringWithFormat:@"yyyy-MM-dd"], @"2026-06-01");
    XCTAssertEqual([date jf_distanceInDaysToDate:nextWeek], 7);
    XCTAssertEqual([[date jf_dateBySubtractingDays:1] jf_day], 24);
    XCTAssertEqual([[date jf_dateByAddingMonths:1] jf_month], 6);
}

- (void)testComponentsAndWeekend
{
    NSDate *date = [NSDate jf_dateWithYear:2026 month:5 day:25];
    XCTAssertEqual(date.jf_year, 2026);
    XCTAssertEqual(date.jf_month, 5);
    XCTAssertEqual(date.jf_day, 25);
    XCTAssertGreaterThanOrEqual(date.jf_weekday, 1);
    XCTAssertLessThanOrEqual(date.jf_weekday, 7);

    NSDate *saturday = [NSDate jf_dateWithYear:2026 month:5 day:23];
    XCTAssertTrue([saturday jf_isTypicallyWeekend]);
}

@end
