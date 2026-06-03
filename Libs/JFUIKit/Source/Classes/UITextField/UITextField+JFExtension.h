//
//  UITextField+JFExtension.h
//  JFUIKit
//
//  Created by huangdonghong on 2018/08/02.
//
//
//  Copyright (c) 2017 - 2018 huangdonghong
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

#import <UIKit/UIKit.h>

// 准许输入字符类型
typedef NS_ENUM(NSInteger, JFTextFieldCharsType) {
    JFTextFieldCharsTypeNumeral = 1,      // 只许数字
    JFTextFieldCharsTypeLetter,           // 只许大小写字母
    JFTextFieldCharsTypeIdentityCard,     // 只许身份证（数字加上X和x）
    JFTextFieldCharsTypeNumeralAndLetter, // 只许数字加上大小写字母
    JFTextFieldCharsTypeAllChar,          // 允许输入所有字符
};

@interface UITextField (JFExtension)
- (void)jf_setPlaceholder:(NSString *)placeholder color:(UIColor *)color;
- (void)jf_setPlaceholderColor:(UIColor *)color;

+ (BOOL)jf_textField:(UITextField *)textField
            range:(NSRange)range
           string:(NSString *)string
         charsType:(JFTextFieldCharsType)charsType
        maxLength:(NSInteger)maxLength
  separatorIndexs:(NSArray *)indexs
        separator:(NSString *)separator;

+ (NSString *)jf_parseString:(NSString *)string separatorIndexs:(NSArray *)indexs separator:(NSString *)separator;

/**
 * 限制输入文本长度，存在高亮拼音时不截断
 */
- (void)jf_limitTextLengthTo:(NSInteger)maxLength;
- (void)jf_limitTextLengthTo:(NSInteger)maxLength limitDo:(void (^)(void))doBlock;

/**
 * 在 shouldChangeCharactersInRange 中校验输入长度
 */
+ (BOOL)jf_textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string
       maxLengthLimit:(NSUInteger)maxLength;
@end
