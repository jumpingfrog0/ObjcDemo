//
//  UITextView+JFExtension.m
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import "UITextView+JFExtension.h"

@implementation UITextView (JFExtension)

- (void)jf_limitTextLengthTo:(NSInteger)maxLength
{
    [self jf_limitTextLengthTo:maxLength limitDo:nil];
}

- (void)jf_limitTextLengthTo:(NSInteger)maxLength limitDo:(void (^)(void))doBlock
{
    UITextRange *selectedRange = self.markedTextRange;
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    // 中文输入法高亮拼音阶段不截断，避免破坏正在输入的内容
    if (position || self.text.length <= maxLength) {
        return;
    }

    self.text = [self.text substringToIndex:maxLength];
    if (doBlock) {
        doBlock();
    }
}

+ (void)jf_textView:(UITextView *)textView limitTo:(NSUInteger)maxLength
{
    [self jf_textView:textView limitTo:maxLength limitDo:nil];
}

+ (void)jf_textView:(UITextView *)textView limitTo:(NSUInteger)maxLength limitDo:(void (^)(void))doBlock
{
    [textView jf_limitTextLengthTo:maxLength limitDo:doBlock];
}

@end
