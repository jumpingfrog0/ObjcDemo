//
//  UIScrollView+JFExtension.m
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

#import "UIScrollView+JFExtension.h"

@implementation UIScrollView (JFExtension)
- (BOOL)jf_isBouncing
{
    return self.jf_isBouncingTop || self.jf_isBouncingLeading || self.jf_isBouncingBottom || self.jf_isBouncingTrailing;
}

- (BOOL)jf_isBouncingTop
{
    return self.contentOffset.y < -self.contentInset.top;
}

- (BOOL)jf_isBouncingLeading
{
    return self.contentOffset.x < -self.contentInset.left;
}

- (BOOL)jf_isBouncingBottom
{
    BOOL contentFillsScrollEdges = self.contentSize.height + self.contentInset.top + self.contentInset.bottom >= CGRectGetHeight(self.bounds);
    return contentFillsScrollEdges && self.contentOffset.y > self.contentSize.height - CGRectGetHeight(self.bounds) + self.contentInset.bottom;
}

- (BOOL)jf_isBouncingTrailing
{
    BOOL contentFillsScrollEdges = self.contentSize.width + self.contentInset.left + self.contentInset.right >= CGRectGetWidth(self.bounds);
    return contentFillsScrollEdges && self.contentOffset.x > self.contentSize.width - CGRectGetWidth(self.bounds) + self.contentInset.right;
}
@end
