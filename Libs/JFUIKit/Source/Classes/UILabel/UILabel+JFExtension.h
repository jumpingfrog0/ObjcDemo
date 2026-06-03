//
//  UILabel+Extend.h
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

@interface UILabel (JFExtension)

+ (UILabel *)jf_labelWithTextColor:(UIColor *)textColor font:(UIFont *)font;
+ (UILabel *)jf_labelWithTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font;
+ (UILabel *)jf_labelWithFrame:(CGRect)frame textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font;

- (CGSize)jf_fittedSize;
- (void)jf_clipToTextBounds;

- (void)jf_setTextColor:(UIColor *)color range:(NSRange)range;
- (void)jf_setKeywordColor:(UIColor *)color keyword:(NSString *)keyword;
- (void)jf_setLineSpacing:(CGFloat)space;
- (void)jf_setLineHeightMultiple:(CGFloat)lineHeightMultiple;

- (void)jf_strikethrough;
@end
