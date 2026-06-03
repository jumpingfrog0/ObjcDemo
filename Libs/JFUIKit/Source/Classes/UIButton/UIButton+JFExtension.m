//
//  UIButton+JFExtension.m
//  JFUIKit
//
//  Created by huangdonghong on 2017/07/27.
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

#import "UIButton+JFExtension.h"
#import <objc/runtime.h>

@implementation UIButton (JFExtension)
static char jf_enlargeTopKey;
static char jf_enlargeTrailingKey;
static char jf_enlargeBottomKey;
static char jf_enlargeLeadingKey;

- (void)jf_alignVerticalWithSpacing:(CGFloat)spacing bottomPadding:(CGFloat)bottomPadding {
    CGSize imageSize = self.imageView.image.size;
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize buttonSize = self.bounds.size;
    
    CGFloat titleBottomOffset = buttonSize.height - titleSize.height - bottomPadding * 2;
    CGFloat imageBottomOffset = buttonSize.height - imageSize.height;
    CGFloat imageTopOffset = (CGFloat) floor((titleSize.height + bottomPadding + spacing) * 2);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -titleBottomOffset, 0.0);
    self.imageEdgeInsets = UIEdgeInsetsMake(-imageTopOffset, 0.0, -imageBottomOffset, -titleSize.width);
    
    // increase the content height to avoid clipping
    CGFloat edgeOffset = (CGFloat) (fabs(titleSize.height - imageSize.height) / 2.0);
    self.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
}

- (void)jf_alignVerticalWithSpacing:(CGFloat)spacing {
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);

    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);

    // increase the content height to avoid clipping
    CGFloat edgeOffset = (CGFloat) (fabs(titleSize.height - imageSize.height) / 2.0);
    self.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
}

- (void)jf_alignHorizontalWithSpacing:(CGFloat)spacing {
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}

- (void)jf_setTitleColor:(UIColor *)color range:(NSRange)range
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.currentTitle];
    [attrStr setAttributes:@{NSForegroundColorAttributeName: self.currentTitleColor}
                     range:NSMakeRange(0, self.currentTitle.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [self setAttributedTitle:attrStr forState:UIControlStateNormal];
}

- (void)jf_setEnlargeEdgeWithTop:(CGFloat)top
                        trailing:(CGFloat)trailing
                          bottom:(CGFloat)bottom
                         leading:(CGFloat)leading
{
    objc_setAssociatedObject(self, &jf_enlargeTopKey, @(top), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &jf_enlargeTrailingKey, @(trailing), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &jf_enlargeBottomKey, @(bottom), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &jf_enlargeLeadingKey, @(leading), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)jf_enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &jf_enlargeTopKey);
    NSNumber *trailingEdge = objc_getAssociatedObject(self, &jf_enlargeTrailingKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &jf_enlargeBottomKey);
    NSNumber *leadingEdge = objc_getAssociatedObject(self, &jf_enlargeLeadingKey);
    if (topEdge && trailingEdge && bottomEdge && leadingEdge) {
        return CGRectMake(self.bounds.origin.x - leadingEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leadingEdge.floatValue + trailingEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    return self.bounds;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.userInteractionEnabled || !self.enabled || self.hidden || self.alpha <= 0.01) {
        return nil;
    }

    CGRect rect = [self jf_enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

- (void)jf_animationStrokeRoundLineFromAngle:(CGFloat)from
                                   lineWidth:(CGFloat)width
                           animationDuration:(NSTimeInterval)duration
{
    CGFloat radius = MAX((CGRectGetWidth(self.bounds) - width) * 0.5, 0);
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:from
                                                      endAngle:2 * M_PI - M_PI_2
                                                     clockwise:YES];

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.strokeColor = UIColor.blackColor.CGColor;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.lineCap = kCALineCapSquare;
    layer.path = path.CGPath;
    layer.lineWidth = width;
    layer.strokeStart = 0.0f;
    layer.strokeEnd = 1.0f;
    [self.layer addSublayer:layer];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duration;
    animation.fromValue = @(0);
    animation.toValue = @(1.0f);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [layer addAnimation:animation forKey:@"jf_strokeRound"];
}

- (void)jf_removeLayerAnimations
{
    [self.layer removeAllAnimations];
}
@end
