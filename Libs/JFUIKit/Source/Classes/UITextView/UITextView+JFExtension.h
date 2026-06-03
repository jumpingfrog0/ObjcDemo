//
//  UITextView+JFExtension.h
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import <UIKit/UIKit.h>

@interface UITextView (JFExtension)

/**
 * 限制输入文本长度，存在高亮拼音时不截断
 */
- (void)jf_limitTextLengthTo:(NSInteger)maxLength;
- (void)jf_limitTextLengthTo:(NSInteger)maxLength limitDo:(void (^)(void))doBlock;
+ (void)jf_textView:(UITextView *)textView limitTo:(NSUInteger)maxLength;
+ (void)jf_textView:(UITextView *)textView limitTo:(NSUInteger)maxLength limitDo:(void (^)(void))doBlock;

@end
