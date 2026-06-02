//
//  NSString+JFExtension.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JFTruncateStringPosition) {
    JFTruncateStringPositionStart = 0,
    JFTruncateStringPositionMiddle,
    JFTruncateStringPositionEnd
};

@interface NSString (JFExtension)

+ (NSString *)jf_parseString:(NSString*)string separatorIndexs:(NSArray *)indexs separator:(NSString *)separator;

+ (CGFloat)jf_heightForText:(NSString *)text inWidth:(CGFloat)widthValue andFont:(UIFont *)font;
+ (NSString *)jf_timeStringWithInterval:(NSInteger)timeInterval;
+ (NSString *)jf_timerDayStringWithInterval:(NSInteger)timerInterval;
+ (NSString *)jf_decimalStyleStringWithNum:(NSNumber *)number;
+ (NSString *)jf_millionStyleStringWithNum:(UInt64)number;
+ (NSString *)jf_stringWithFormattedUnsignedInteger:(NSUInteger)integer;
+ (BOOL)jf_stringIsEmpty:(NSString *)aString;

- (CGSize)jf_safeSizeWithFont:(UIFont *)font;
- (CGSize)jf_safeSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)jf_safeSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)jf_sizeWithFont:(UIFont *)font;
- (CGSize)jf_sizeWithMyFont:(UIFont *)fontToUse;

+ (NSString *)jf_zodiacSignWithMonth:(NSInteger)month day:(NSInteger)day;
+ (NSString *)jf_zodiacSignWithTs:(NSTimeInterval)ts;

/**
 * 根据一个正则表达式在字符串中查找符合条件的子串
 *
 * @param regular 正则表达式
 */
- (NSMutableArray *)jf_subStringByRegular:(NSString *)regular;

/**
 * 计算字符串真实长度，一个emoji长度为1
 */
- (NSInteger)jf_realLength;

- (NSString *)jf_trim;
- (NSString *)jf_trimmingWhiteSpaceAtBothEnd;
- (NSString *)jf_trimmingNewlineAtBothEnd;
- (NSString *)jf_removeAllSpaceAndNewLine;
- (NSString *)jf_replaceUnicode;
- (NSString *)jf_replaceMEWithBilin;
- (NSString *)jf_stringBySecuringAtMiddle;


/// 截取字符串，末尾会加省略号
/// - Parameter length: 长度
- (NSString *)jf_stringByTruncatingToLength:(NSUInteger)length;


/// 截取字符串，末尾是否加省略号
/// - Parameters:
///   - length: 长度
///   - ellipsis: 是否加省略号
- (NSString *)jf_stringByTruncatingToLength:(NSUInteger)length ellipsis:(BOOL)ellipsis;
- (NSString *)jf_stringByTruncatingToLength:(int)length direction:(JFTruncateStringPosition)truncateFrom;
- (NSString *)jf_stringByTruncatingToLength:(int)length direction:(JFTruncateStringPosition)truncateFrom withEllipsisString:(NSString *)ellipsis;
- (NSString *)jf_stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font;
- (NSString *)jf_truncatingString:(NSDictionary *)attribute maxWidth:(CGFloat)maxWidth;
- (NSString *)jf_truncatedStringWithMaxLength:(NSInteger)limit;
- (NSString *)jf_safeSubStringWithMaxLength:(NSInteger)limit;

- (NSString *)jf_filterXMLEscapeChar;
- (NSString *)jf_maskPhone;
- (NSDictionary *)jf_urlParams;
- (NSString *)jf_stringByAddUrlParam:(NSString *)key value:(NSString *)value;
- (NSString *)jf_transformToPinyin;
- (NSString *)jf_transformToPinyinFirstLetter;
- (BOOL)jf_containsString:(NSString *)string;
- (BOOL)jf_containsString:(NSString *)string options:(NSStringCompareOptions)options;
- (long)jf_longValue;
- (long long)jf_longLongValue;
- (unsigned long long)jf_unsignedLongLongValue;
- (BOOL)jf_isPureInt;
- (NSInteger)jf_countOccurentceOfString:(NSString *)searchString;
- (NSString *)jf_stringByRemoveString:(NSString *)string;
+ (NSString *)jf_mergeString1:(NSString *)string1 string2:(NSString *)string2;

@end
