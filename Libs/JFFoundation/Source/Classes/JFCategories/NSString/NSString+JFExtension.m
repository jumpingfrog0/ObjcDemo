//
//  NSString+JFExtension.m
//  JFFoundation
//
//  Created by huangdonghong on 2017/07/27.
//
//
//  Copyright (c) 2017 huangdonghong
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NSString+JFExtension.h"
#import "JFFloatUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (JFExtension)

+ (NSString *)jf_parseString:(NSString*)string separatorIndexs:(NSArray *)indexs separator:(NSString *)separator {
    if (!string) return nil;
    NSMutableString *mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:separator withString:@""]];
    [indexs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [obj integerValue];
        if (mStr.length > index) [mStr insertString:separator atIndex:index];
    }];
    return  mStr;
}

+ (CGFloat)jf_heightForText:(NSString *)text inWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    if (text.length == 0) {
        return 0;
    }

    CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName: font}
                                      context:nil];
    return ceil(frame.size.height);
}

+ (NSString *)jf_timeStringWithInterval:(NSInteger)timeInterval
{
    if (timeInterval >= 60 * 60) {
        int hour = (int)timeInterval / 3600;
        int min = (int)(timeInterval % 3600) / 60;
        int sec = (int)(timeInterval % 3600) % 60;
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec];
    }
    return [NSString stringWithFormat:@"%02d:%02d", (int)(timeInterval / 60), (int)(timeInterval % 60)];
}

+ (NSString *)jf_timerDayStringWithInterval:(NSInteger)timerInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timerInterval];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (cmp1.day == cmp2.day) {
        formatter.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"今天 %@", [formatter stringFromDate:date]];
    } else if (cmp1.year == cmp2.year) {
        if (cmp1.month == cmp2.month && cmp1.day - cmp2.day == -1) {
            formatter.dateFormat = @"HH:mm";
            return [NSString stringWithFormat:@"昨天 %@", [formatter stringFromDate:date]];
        }
        formatter.dateFormat = @"MM-dd HH:mm";
        return [formatter stringFromDate:date];
    }

    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
}

+ (NSString *)jf_decimalStyleStringWithNum:(NSNumber *)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:number];
}

+ (NSString *)jf_millionStyleStringWithNum:(UInt64)number
{
    if (number > 1000000 && number < 1000000000) {
        UInt64 million = roundl((long double)number / 10000.0f);
        return [NSString stringWithFormat:@"%llu万", (unsigned long long)million];
    }

    if (number > 100000000) {
        UInt64 billion = roundl((long double)number / 100000000.0f);
        return [NSString stringWithFormat:@"%llu亿", (unsigned long long)billion];
    }

    return [NSString stringWithFormat:@"%llu", (unsigned long long)number];
}

+ (NSString *)jf_stringWithFormattedUnsignedInteger:(NSUInteger)integer
{
    NSNumber *number = [NSNumber numberWithUnsignedInteger:integer];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:number];
}

+ (BOOL)jf_stringIsEmpty:(NSString *)aString
{
    if ((NSNull *)aString == [NSNull null] || aString == nil) {
        return YES;
    }

    NSString *trimmedString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString.length == 0;
}

- (CGSize)jf_safeSizeWithFont:(UIFont *)font {
    return [self jf_safeSizeWithFont:font
                   constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                       lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGSize)jf_safeSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self jf_safeSizeWithFont:font
                   constrainedToSize:size
                       lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGSize)jf_safeSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;

    NSDictionary *attributes = @{NSFontAttributeName:font};
    if (lineBreakMode != NSLineBreakByCharWrapping) {
        attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    }
    CGRect boundingRect = [self boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:attributes
                                             context:nil];
    if (!JF_IS_NORMAL(boundingRect.size.width) || !JF_IS_NORMAL(boundingRect.size.height)) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
}

- (CGSize)jf_sizeWithFont:(UIFont *)font
{
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName: font}];
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

- (CGSize)jf_sizeWithMyFont:(UIFont *)fontToUse
{
    return [self sizeWithAttributes:@{NSFontAttributeName: fontToUse}];
}

#pragma mark - 星座

+ (NSString *)jf_zodiacSignWithMonth:(NSInteger)m day:(NSInteger)d {
    NSString *zodiacString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *zodiacFormat = @"102123444543";

    if (m<1||m>12||d<1||d>31){
        return @"";
    }

    if(m==2 && d>29) {
        return @"";
    } else if (m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"";
        }
    }

    NSString *result = [NSString stringWithFormat:@"%@座",[zodiacString substringWithRange:NSMakeRange(m*2-(d < [[zodiacFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];

    return result;
}

+ (NSString *)jf_zodiacSignWithTs:(NSTimeInterval)ts {
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:ts];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:(NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:today];
    NSInteger month = [weekdayComponents month];
    NSInteger day = [weekdayComponents day];
    return [NSString jf_zodiacSignWithMonth:month day:day];
}

#pragma mark - Regular

- (NSArray *)jf_subStringByRegular:(NSString *)regular {
    NSRange range = [self rangeOfString:regular options:NSRegularExpressionSearch];
    if (range.length == 0 || range.location == NSNotFound) {
        return nil;
    }

    NSMutableArray *array = [NSMutableArray array];
    while (range.length != 0 && range.location != NSNotFound) {
        NSString *subStr = [self substringWithRange:range];
        [array addObject:subStr];

        NSRange subRange = NSMakeRange(range.location + range.length, self.length - range.location - range.length);
        range = [self rangeOfString:regular options:NSRegularExpressionSearch range:subRange];
    }
    return array;
}

#pragma mark -

- (NSInteger)jf_realLength {
    __block NSInteger length = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        length++;
    }];
    return length;
}

- (NSString *)jf_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)jf_trimmingWhiteSpaceAtBothEnd
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)jf_trimmingNewlineAtBothEnd
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

- (NSString *)jf_removeAllSpaceAndNewLine
{
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

- (NSString *)jf_replaceUnicode
{
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

- (NSString *)jf_replaceMEWithBilin
{
    return [self stringByReplacingOccurrencesOfString:@"比邻" withString:@"ME"];
}

- (NSString *)jf_stringBySecuringAtMiddle
{
    NSArray *array = [self componentsSeparatedByString:@"@"];
    if (array.count == 2) {
        NSString *username = [array firstObject];
        NSInteger aLength = MIN(7, username.length / 2);
        NSInteger bLength = username.length - aLength;
        NSInteger beginAmbiguous = bLength / 2;
        NSRange range = NSMakeRange(beginAmbiguous, username.length - aLength);
        NSString *ambiguous = [username stringByReplacingCharactersInRange:range withString:@"****"];
        return [ambiguous stringByAppendingFormat:@"@%@", array[1]];
    }

    NSInteger aLength = MIN(7, self.length * 0.7);
    NSInteger bLength = self.length - aLength;
    NSInteger beginAmbiguous = aLength / 2;
    NSRange range = NSMakeRange(beginAmbiguous, bLength);
    return [self stringByReplacingCharactersInRange:range withString:@"****"];
}

- (NSString *)jf_stringByTruncatingToLength:(NSUInteger)length
{
    return [self jf_stringByTruncatingToLength:length ellipsis:YES];
}

- (NSString *)jf_stringByTruncatingToLength:(NSUInteger)length ellipsis:(BOOL)ellipsis
{
    NSString *string = [self copy];
    if (length == 0 || string.length == 0) {
        return @"";
    }

    if (string.length > length) {
        NSRange rangeIndex = [string rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
        string = [string substringWithRange:rangeIndex];
        if (ellipsis) {
            return [string stringByAppendingString:@"..."];
        }
    }

    return string;
}

- (NSString *)jf_stringByTruncatingToLength:(int)length direction:(JFTruncateStringPosition)truncateFrom
{
    return [self jf_stringByTruncatingToLength:length direction:truncateFrom withEllipsisString:@"..."];
}

- (NSString *)jf_stringByTruncatingToLength:(int)length direction:(JFTruncateStringPosition)truncateFrom withEllipsisString:(NSString *)ellipsis
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:self];
    if (length <= 0) {
        return @"";
    }
    if (result.length <= length) {
        return self;
    }
    if (ellipsis.length >= length) {
        return [ellipsis substringToIndex:length];
    }

    unsigned int charactersEachSide = length / 2;
    switch (truncateFrom) {
        case JFTruncateStringPositionStart:
            [result insertString:ellipsis atIndex:result.length - length + ellipsis.length];
            return [result substringFromIndex:result.length - length];
        case JFTruncateStringPositionMiddle: {
            NSString *first = [result substringToIndex:charactersEachSide - ellipsis.length + 1];
            NSString *last = [result substringFromIndex:result.length - charactersEachSide];
            return [@[first, last] componentsJoinedByString:ellipsis];
        }
        case JFTruncateStringPositionEnd:
        default:
            [result insertString:ellipsis atIndex:length - ellipsis.length];
            return [result substringToIndex:length];
    }
}

- (NSString *)jf_stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font
{
    NSInteger min = 0;
    NSInteger max = self.length;
    NSInteger mid = 0;

    while (min < max) {
        mid = (min + max) / 2;
        NSString *currentString = [self substringWithRange:NSMakeRange(0, mid)];
        CGRect frame = [currentString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:@{NSFontAttributeName: font}
                                                   context:nil];
        CGSize currentSize = frame.size;

        if (currentSize.width < width) {
            min = mid + 1;
        } else if (currentSize.width > width) {
            max = mid - 1;
        } else {
            min = mid;
            break;
        }
    }

    if (self.length != min) {
        NSString *substring = [self substringWithRange:NSMakeRange(0, min)];
        return [substring stringByAppendingString:@"…"];
    }
    return self;
}

- (NSString *)jf_truncatingString:(NSDictionary *)attribute maxWidth:(CGFloat)maxWidth
{
    NSString *ellipsis = @"…";
    CGFloat srcStringW = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attribute
                                            context:nil].size.width;
    CGFloat ellipsisW = [ellipsis boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:attribute
                                               context:nil].size.width;

    if (srcStringW <= maxWidth || srcStringW <= ellipsisW) {
        return self;
    }

    NSMutableString *truncatedString = [[NSMutableString alloc] initWithString:@""];
    NSUInteger strCount = 0;
    while ([truncatedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attribute
                                         context:nil].size.width + ellipsisW < maxWidth && strCount < self.length) {
        strCount++;
        truncatedString = [[NSMutableString alloc] initWithString:[self jf_safeSubStringWithCount:strCount]];
    }

    truncatedString = [[NSMutableString alloc] initWithString:[self jf_safeSubStringWithCount:strCount--]];
    [truncatedString appendString:ellipsis];
    return truncatedString;
}

- (NSString *)jf_truncatedStringWithMaxLength:(NSInteger)limit
{
    if (limit <= 0) {
        return @"";
    }

    NSRange range = [self rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.length > limit ? limit : self.length)];
    if (range.length >= limit) {
        if (self.length > range.length) {
            return [[self substringToIndex:range.length] stringByAppendingString:@"…"];
        }
        return [self substringToIndex:range.length];
    }
    return self;
}

- (NSString *)jf_safeSubStringWithMaxLength:(NSInteger)limit
{
    if (limit <= 0) {
        return @"";
    }

    NSRange range = [self rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.length > limit ? limit : self.length)];
    if (range.length >= limit) {
        return [self substringToIndex:range.length];
    }
    return self;
}

- (NSString *)jf_filterXMLEscapeChar
{
    NSString *temp = [self stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    temp = [temp stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    temp = [temp stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    temp = [temp stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    temp = [temp stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return temp;
}

- (NSString *)jf_maskPhone
{
    if (self.length == 0) {
        return @"";
    }

    if (self.length == 11) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return [@"+" stringByAppendingString:self];
}

- (NSDictionary *)jf_urlParams
{
    NSRange questionMarkRange = [self rangeOfString:@"?"];
    if (questionMarkRange.location == NSNotFound) {
        return nil;
    }

    NSString *paramsString = [self substringFromIndex:questionMarkRange.location + 1];
    NSArray *paramsArray = [paramsString componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *paramString in paramsArray) {
        NSArray *keyValues = [paramString componentsSeparatedByString:@"="];
        if (keyValues.count == 2) {
            NSString *value = [keyValues[1] stringByRemovingPercentEncoding];
            NSString *key = [keyValues[0] stringByRemovingPercentEncoding];
            if (key && value) {
                [params setObject:value forKey:key];
            }
        }
    }
    return [params copy];
}

- (NSString *)jf_stringByAddUrlParam:(NSString *)key value:(NSString *)value
{
    if (key.length == 0 || value.length == 0 || self.length == 0) {
        return self;
    }

    NSString *paramsString = [NSString stringWithFormat:@"%@=%@", key, value];
    NSRange range = [self rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        if (range.location == self.length - 1) {
            return [self stringByAppendingString:paramsString];
        }
        return [self stringByAppendingFormat:@"&%@", paramsString];
    }
    return [self stringByAppendingFormat:@"?%@", paramsString];
}

- (NSString *)jf_transformToPinyin
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:NSLocale.currentLocale];
    mutableString = [[mutableString stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
    return mutableString.lowercaseString;
}

- (NSString *)jf_transformToPinyinFirstLetter
{
    NSMutableString *stringM = [NSMutableString string];
    NSString *temp = nil;
    for (int index = 0; index < self.length; index++) {
        temp = [self substringWithRange:NSMakeRange(index, 1)];
        NSMutableString *mutableString = [NSMutableString stringWithString:temp];
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
        mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:NSLocale.currentLocale];
        if (mutableString.length > 1) {
            mutableString = [[mutableString substringToIndex:1] mutableCopy];
        }
        [stringM appendString:mutableString];
    }
    return stringM.lowercaseString;
}

- (BOOL)jf_containsString:(NSString *)string
{
    return [self jf_containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)jf_containsString:(NSString *)string options:(NSStringCompareOptions)options
{
    if (string.length == 0) {
        return NO;
    }
    return [self rangeOfString:string options:options].location != NSNotFound;
}

- (long)jf_longValue
{
    return (long)[self jf_longLongValue];
}

- (long long)jf_longLongValue
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    long long valueToGet = 0;
    if ([scanner scanLongLong:&valueToGet]) {
        return valueToGet;
    }
    return 0;
}

- (unsigned long long)jf_unsignedLongLongValue
{
    unsigned long long value = 0;
    for (NSUInteger index = 0; index < self.length; index++) {
        unichar character = [self characterAtIndex:index];
        if (character >= '0' && character <= '9') {
            value = (10 * value) + (unsigned long long)(character - '0');
        }
    }
    return value;
}

- (BOOL)jf_isPureInt
{
    int value = 0;
    NSScanner *scan = [NSScanner scannerWithString:self];
    return [scan scanInt:&value] && scan.isAtEnd;
}

- (NSInteger)jf_countOccurentceOfString:(NSString *)searchString
{
    if (searchString.length == 0) {
        return 0;
    }

    NSInteger strCount = self.length - [[self stringByReplacingOccurrencesOfString:searchString withString:@""] length];
    return strCount / searchString.length;
}

- (NSString *)jf_stringByRemoveString:(NSString *)string
{
    return [self stringByReplacingOccurrencesOfString:string withString:@""];
}

+ (NSString *)jf_mergeString1:(NSString *)string1 string2:(NSString *)string2
{
    return [string1 stringByAppendingString:string2];
}

- (NSString *)jf_safeSubStringWithCount:(NSUInteger)strCount
{
    __block NSUInteger currentCount = 0;
    __block NSString *subStr = @"";
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        currentCount++;
        if (currentCount >= strCount) {
            subStr = [self substringWithRange:NSMakeRange(0, substringRange.location + substringRange.length)];
            *stop = YES;
        }
    }];
    return subStr;
}

@end
