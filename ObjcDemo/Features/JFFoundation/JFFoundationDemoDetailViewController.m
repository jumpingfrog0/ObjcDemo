//
//  JFFoundationDemoDetailViewController.m
//  ObjcDemo
//
//  Created by Codex on 2026/5/25.
//

#import "JFFoundationDemoDetailViewController.h"
#import <JFFoundation/JFFoundation.h>
#import <JFFoundation/JFFloatUtils.h>
#import <JFFoundation/NSMutableArray+JFQueueStack.h>
#import <JFFoundation/NSMutableArray+JFSafe.h>
#import <objc/message.h>

@interface JFFoundationSelectorDemoObject : NSObject
@end

@implementation JFFoundationSelectorDemoObject

- (NSString *)joinText:(NSString *)text suffix:(NSString *)suffix
{
    return [text stringByAppendingString:suffix];
}

@end

@interface JFFoundationDemoDetailViewController () <UITableViewDataSource>

@property (nonatomic, copy) NSString *category;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, id> *> *rows;

@end

@implementation JFFoundationDemoDetailViewController

- (instancetype)initWithCategory:(NSString *)category title:(NSString *)title
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _category = [category copy];
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.rows = [self buildRowsForCategory:self.category];
    [self setupTableView];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"JFFoundationResultCell"];
    [self.view addSubview:self.tableView];
}

- (NSArray<NSDictionary<NSString *, id> *> *)buildRowsForCategory:(NSString *)category
{
    if ([category isEqualToString:@"NSString"]) {
        return [self stringRows];
    }
    if ([category isEqualToString:@"NSArray"]) {
        return [self arrayRows];
    }
    if ([category isEqualToString:@"NSDictionary"]) {
        return [self dictionaryRows];
    }
    if ([category isEqualToString:@"NSDate"]) {
        return [self dateRows];
    }
    if ([category isEqualToString:@"DataURL"]) {
        return [self dataURLRows];
    }
    if ([category isEqualToString:@"Misc"]) {
        return [self miscRows];
    }
    return [self objectRows];
}

- (NSDictionary<NSString *, id> *)row:(NSString *)title detail:(NSString *)detail pass:(BOOL)pass
{
    return @{@"title": title ?: @"",
             @"detail": detail ?: @"",
             @"pass": @(pass)};
}

- (NSString *)stringFromObject:(id)object
{
    if (!object || object == [NSNull null]) {
        return @"nil";
    }
    if ([NSJSONSerialization isValidJSONObject:object]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: [object description];
    }
    return [object description];
}

- (NSArray<NSDictionary<NSString *, id> *> *)stringRows
{
    NSString *trimmed = [@"  hello JF  \n" jf_trim];
    NSString *urlEncoded = [@"name=小明&city=深圳" jf_urlEncode];
    NSString *decoded = [urlEncoded jf_urlDecode];
    id json = [@"{\"name\":\"JF\",\"count\":2}" jf_JSONObject];
    NSArray *regular = [@"a12b34c" jf_subStringByRegular:@"\\d+"];

    return @[
        [self row:@"jf_trim" detail:[NSString stringWithFormat:@"\"  hello JF  \\n\" -> \"%@\"", trimmed] pass:[trimmed isEqualToString:@"hello JF"]],
        [self row:@"jf_stringByTruncatingToLength" detail:[@"Objective-C" jf_stringByTruncatingToLength:5] pass:YES],
        [self row:@"jf_isValidEmail / jf_isValidPhone" detail:[NSString stringWithFormat:@"email=%@ phone=%@", [@"dev@example.com" jf_isValidEmail] ? @"YES" : @"NO", [@"13800138000" jf_isValidPhone] ? @"YES" : @"NO"] pass:YES],
        [self row:@"jf_urlEncode / jf_urlDecode" detail:[NSString stringWithFormat:@"%@ -> %@", urlEncoded, decoded] pass:[decoded isEqualToString:@"name=小明&city=深圳"]],
        [self row:@"jf_JSONObject" detail:[self stringFromObject:json] pass:[json isKindOfClass:[NSDictionary class]]],
        [self row:@"jf_md5 / jf_SHA1" detail:[NSString stringWithFormat:@"md5=%@ sha1=%@", [@"abc" jf_md5], [@"abc" jf_SHA1]] pass:YES],
        [self row:@"bl_compareVersion" detail:[NSString stringWithFormat:@"1.2.0 compare 1.1.9 = %ld", (long)[@"1.2.0" bl_compareVersion:@"1.1.9"]] pass:YES],
        [self row:@"jf_zodiacSignWithMonth" detail:[NSString jf_zodiacSignWithMonth:3 day:21] pass:YES],
        [self row:@"jf_realLength / regexp" detail:[NSString stringWithFormat:@"realLength=%ld regexp=%@", (long)[@"A😀中" jf_realLength], [regular componentsJoinedByString:@","]] pass:YES],
        [self row:@"jf_filterXMLEscapeChar" detail:[@"&lt;tag&gt;&amp;" jf_filterXMLEscapeChar] pass:YES],
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)arrayRows
{
    NSArray *array = @[@"a", @"b", @"b", @"c"];
    NSArray *mapped = [array jf_map:^id(NSString *obj) {
        return [obj uppercaseString];
    }];
    NSArray *filtered = [array jf_filter:^BOOL(NSString *obj) {
        return ![obj isEqualToString:@"b"];
    }];
    NSMutableArray *queue = [NSMutableArray array];
    [queue jf_enqueue:@"first"];
    [queue jf_enqueue:@"second"];
    id dequeued = [queue jf_dequeue];
    [queue jf_stackPush:@"last"];
    id popped = [queue jf_stackPop];

    NSMutableArray *safe = [NSMutableArray arrayWithObject:@"origin"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    [safe jf_safeAddObject:nil];
#pragma clang diagnostic pop
    [safe jf_safeInsertObject:@"insert" atIndex:8];
    [safe jf_safeReplaceObjectAtIndex:10 withObject:@"replace"];
    [safe jf_safeRemoveObjectAtIndex:20];

    return @[
        [self row:@"jf_objectAtIndex" detail:[NSString stringWithFormat:@"index 99 -> %@", [array jf_objectAtIndex:99]] pass:[array jf_objectAtIndex:99] == nil],
        [self row:@"jf_map" detail:[mapped componentsJoinedByString:@", "] pass:YES],
        [self row:@"jf_filter" detail:[filtered componentsJoinedByString:@", "] pass:YES],
        [self row:@"jf_distinctUnionArray" detail:[[array jf_distinctUnionArray] componentsJoinedByString:@", "] pass:YES],
        [self row:@"jf_reversed" detail:[[array jf_reversed] componentsJoinedByString:@", "] pass:YES],
        [self row:@"queue / stack" detail:[NSString stringWithFormat:@"dequeue=%@ pop=%@", dequeued, popped] pass:YES],
        [self row:@"safe mutable ops" detail:[NSString stringWithFormat:@"after invalid ops: %@", safe] pass:YES],
        [self row:@"enum string" detail:[NSString stringWithFormat:@"1 -> %@, c -> %lu", [array jf_stringWithEnum:1], (unsigned long)[array jf_enumFromString:@"c"]] pass:YES],
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)dictionaryRows
{
    NSDictionary *dict = @{@"name": @"JF", @"count": @3, @"empty": @"", @"null": [NSNull null]};
    NSString *json = [dict jf_JSONString];
    NSString *pretty = [dict jf_prettyJSONString];
    NSString *query = [@{@"name": @"JF", @"city": @"深圳"} jf_joinURLQueries];
    NSDictionary *params = [NSDictionary jf_paramsForURLString:@"https://example.com?a=1&b=hello"];
    NSDictionary *filtered = [dict jf_filterEmptyData];

    BOOL hasBlSafeString = [dict respondsToSelector:NSSelectorFromString(@"bl_safeStringForKey:")];
    BOOL hasJfSafeString = [dict respondsToSelector:NSSelectorFromString(@"jf_safeStringForKey:")];
    NSString *safeNote = [NSString stringWithFormat:@"bl_safeStringForKey=%@, jf_safeStringForKey=%@",
                                                    hasBlSafeString ? @"YES" : @"NO",
                                                    hasJfSafeString ? @"YES" : @"NO"];

    return @[
        [self row:@"jf_JSONString" detail:json pass:json.length > 0],
        [self row:@"jf_prettyJSONString" detail:[pretty stringByReplacingOccurrencesOfString:@"\n" withString:@" "] pass:pretty.length > json.length],
        [self row:@"jf_joinURLQueries" detail:query pass:query.length > 0],
        [self row:@"jf_paramsForURLString" detail:[self stringFromObject:params] pass:[params[@"a"] isEqualToString:@"1"]],
        [self row:@"jf_filterEmptyData" detail:[self stringFromObject:filtered] pass:filtered.count < dict.count],
        [self row:@"safe selector availability" detail:safeNote pass:hasJfSafeString],
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)dateRows
{
    NSDate *date = [NSDate jf_dateWithYear:2026 month:5 day:25];
    NSDate *parsed = [NSDate jf_dateFromString:@"2026-05-25" format:@"yyyy-MM-dd"];
    NSDate *nextWeek = [date jf_dateByAddingDays:7];

    return @[
        [self row:@"jf_dateFromString" detail:[parsed jf_stringWithFormat:@"yyyy-MM-dd"] pass:parsed != nil],
        [self row:@"jf_dateWithYear/month/day" detail:[date jf_stringWithFormat:@"yyyy-MM-dd"] pass:YES],
        [self row:@"beginning/end of day" detail:[NSString stringWithFormat:@"%@ -> %@", [[date jf_beginningOfDay] jf_stringWithFormat:@"HH:mm:ss"], [[date jf_endOfDay] jf_stringWithFormat:@"HH:mm:ss"]] pass:YES],
        [self row:@"beginning/end of month" detail:[NSString stringWithFormat:@"%@ -> %@", [[date jf_beginningOfMonth] jf_stringWithFormat:@"yyyy-MM-dd"], [[date jf_endOfMonth] jf_stringWithFormat:@"yyyy-MM-dd"]] pass:YES],
        [self row:@"jf_dateByAddingDays" detail:[nextWeek jf_stringWithFormat:@"yyyy-MM-dd"] pass:YES],
        [self row:@"jf_distanceInDaysToDate" detail:[NSString stringWithFormat:@"%ld days", (long)[date jf_distanceInDaysToDate:nextWeek]] pass:YES],
        [self row:@"NSCalendar days" detail:[NSString stringWithFormat:@"2024=%ld, 2024-02=%ld", (long)[NSCalendar jf_numberOfDaysInYear:2024], (long)[NSCalendar jf_numberOfDaysInYear:2024 month:2]] pass:YES],
        [self row:@"weekday/weekend" detail:[NSString stringWithFormat:@"weekday=%ld weekend=%@", (long)date.jf_weekday, [date jf_isTypicallyWeekend] ? @"YES" : @"NO"] pass:YES],
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)dataURLRows
{
    NSData *jsonData = [@"{\"ok\":true}" dataUsingEncoding:NSUTF8StringEncoding];
    id json = [jsonData jf_JSONObject];
    NSData *pngData = [NSData dataWithBytes:"\x89PNG\r\n\x1a\n" length:8];
    NSURL *url = [NSURL URLWithString:@"https://example.com/path?name=JF&city=SZ"];
    NSURL *newURL = [url jf_URLByAddQueriesFromDictionary:@{@"page": @"1", @"keyword": @"demo"}];

    return @[
        [self row:@"NSData jf_JSONObject" detail:[self stringFromObject:json] pass:[json isKindOfClass:[NSDictionary class]]],
        [self row:@"NSData jf_md5" detail:[jsonData jf_md5] pass:YES],
        [self row:@"image data type" detail:[NSString stringWithFormat:@"png=%@ jpeg=%@", [NSData jf_isPNGForImageData:pngData] ? @"YES" : @"NO", [NSData jf_isJPEGForImageData:pngData] ? @"YES" : @"NO"] pass:YES],
        [self row:@"NSURL jf_parameters" detail:[self stringFromObject:[url jf_parameters]] pass:YES],
        [self row:@"NSURL append query" detail:newURL.absoluteString pass:newURL.absoluteString.length > url.absoluteString.length],
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)miscRows
{
    NSNumber *number = @123456;
    NSAttributedString *strike = [NSMutableAttributedString jf_strikethroughWithText:@"删除线文本"];
    BOOL floatEqual = JFFloatIsEqual(0.1f + 0.2f, 0.3f);

    return @[
        [self row:@"NSNumber jf_length" detail:[NSString stringWithFormat:@"%lu", (unsigned long)[number jf_length]] pass:YES],
        [self row:@"NSLocale jf_simplifiedChineseLocale" detail:[NSLocale jf_simplifiedChineseLocale].localeIdentifier pass:YES],
        [self row:@"NSMutableAttributedString strikethrough" detail:strike.string pass:YES],
        [self row:@"JFFloatIsEqual" detail:[NSString stringWithFormat:@"0.1f + 0.2f == 0.3f -> %@", floatEqual ? @"YES" : @"NO"] pass:YES],
    ];
}

- (NSArray<NSDictionary<NSString *, id> *> *)objectRows
{
    JFFoundationSelectorDemoObject *object = [JFFoundationSelectorDemoObject new];
    id value = [object jf_performSelector:@selector(joinText:suffix:) withObjects:@[@"Hello", @" JF"]];
    id missing = [object jf_performSelector:NSSelectorFromString(@"noSuchSelector") withObjects:@[]];
    return @[
        [self row:@"jf_performSelector with args" detail:[self stringFromObject:value] pass:[value isEqualToString:@"Hello JF"]],
        [self row:@"missing selector" detail:[self stringFromObject:missing] pass:missing == nil],
    ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JFFoundationResultCell" forIndexPath:indexPath];
    NSDictionary *row = self.rows[indexPath.row];
    BOOL pass = [row[@"pass"] boolValue];

    UIListContentConfiguration *content = [UIListContentConfiguration subtitleCellConfiguration];
    content.text = [NSString stringWithFormat:@"%@ %@", pass ? @"PASS" : @"FAIL", row[@"title"]];
    content.secondaryText = row[@"detail"];
    content.secondaryTextProperties.numberOfLines = 0;
    content.textProperties.color = pass ? [UIColor colorWithRed:0.12 green:0.47 blue:0.24 alpha:1.0] : [UIColor systemRedColor];
    cell.contentConfiguration = content;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
