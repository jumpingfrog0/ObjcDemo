//
//  JFNSObjectExtensionTests.m
//  ObjcDemoTests
//
//  Created by huangdonghong on 2026/06/02.
//

#import <XCTest/XCTest.h>
#import <JFFoundation/JFFoundation.h>

@interface JFNSObjectTestSelectorObject : NSObject
@end

@implementation JFNSObjectTestSelectorObject

- (NSString *)staticText
{
    return @"JF";
}
@end

@interface JFNSObjectTestModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSDate *date;

@end

@implementation JFNSObjectTestModel
@end

@interface JFNSObjectExtensionTests : XCTestCase
@end

@implementation JFNSObjectExtensionTests

- (void)testSafeKVCAndProperties
{
    JFNSObjectTestModel *model = [JFNSObjectTestModel new];
    XCTAssertNoThrow([model jf_safeSetValue:@"JF" forKey:@"name"]);
    XCTAssertNoThrow([model jf_safeSetValue:@"ignored" forKey:@"missing"]);
    XCTAssertEqualObjects([model jf_safeValueForKey:@"name"], @"JF");
    XCTAssertNil([model jf_safeValueForKey:@"missing"]);
    XCTAssertTrue([[model jf_propertyKeys] containsObject:@"name"]);
}

- (void)testDictionaryWithProperties
{
    JFNSObjectTestModel *model = [JFNSObjectTestModel new];
    model.name = @"JF";
    model.date = [NSDate dateWithTimeIntervalSince1970:100];
    NSDictionary *dict = [model jf_dictionaryWithProperties];
    XCTAssertEqualObjects(dict[@"name"], @"JF");
    XCTAssertNil(dict[@"count"]);
    XCTAssertEqualObjects(dict[@"date"], @"100.000000");
}

- (void)testCopyEncodeDecodeWithIgnoredIvars
{
    JFNSObjectTestModel *model = [JFNSObjectTestModel new];
    model.name = @"JF";
    model.count = @3;
    model.jf_ignoredIvarNames = @[@"_count"];

    JFNSObjectTestModel *copied = [model jf_copyWithZone:nil];
    XCTAssertEqualObjects(copied.name, @"JF");
    XCTAssertNil(copied.count);

    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
    [model jf_encode:archiver];
    [archiver finishEncoding];

    NSError *decodeError = nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:archiver.encodedData error:&decodeError];
    JFNSObjectTestModel *decoded = [JFNSObjectTestModel new];
    decoded.jf_ignoredIvarNames = @[@"_count"];
    [decoded jf_decode:unarchiver];
    [unarchiver finishDecoding];

    XCTAssertNil(decodeError);
    XCTAssertEqualObjects(decoded.name, @"JF");
    XCTAssertNil(decoded.count);
}

- (void)testPerformSelector
{
    JFNSObjectTestSelectorObject *object = [JFNSObjectTestSelectorObject new];
    NSArray *emptyArguments = @[];
    XCTAssertEqualObjects([object jf_performSelector:@selector(staticText) withObjects:emptyArguments], @"JF");
    XCTAssertNil([object jf_performSelector:NSSelectorFromString(@"missingSelector") withObjects:emptyArguments]);
}

@end
