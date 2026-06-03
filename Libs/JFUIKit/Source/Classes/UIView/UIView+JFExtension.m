//
//  UIView+JFExtension.m
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

#import "UIView+JFExtension.h"
#import "UIImage+JFExtension.h"

@implementation UIView (JFExtension)

- (UIViewController *)jf_viewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)jf_setTopLineWithColor:(UIColor *)color {
    CGRect frame = CGRectMake(0.0, 0.0, self.bounds.size.width, 1);
    UIImageView *imageView     = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor  = color;
    [self addSubview:imageView];
}

- (void)jf_setTopLineWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat width = [UIScreen mainScreen].bounds.size.width < self.bounds.size.width ? [UIScreen mainScreen].bounds.size.width : self.bounds.size.width;
    CGRect frame = CGRectMake(0.0, 0.0, width, image.size.height);
    UIImageView *imageView     = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor  = [UIColor clearColor];
    imageView.image = [UIImage jf_resizableImageNamed:imageName];
    [self addSubview:imageView];
}

- (void)jf_setBottomLineWithColor:(UIColor *)color {
    CGRect frame = CGRectMake(0.0, self.bounds.size.height, self.bounds.size.width, 1);
    UIImageView *imageView     = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor  = color;
    [self addSubview:imageView];
}

- (void)jf_setBottomLineWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat width = [UIScreen mainScreen].bounds.size.width < self.bounds.size.width ? [UIScreen mainScreen].bounds.size.width : self.bounds.size.width;
    CGRect frame = CGRectMake(0.0, self.bounds.size.height - 1, width, image.size.height);
    UIImageView *imageView     = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor  = [UIColor clearColor];
    imageView.image = [UIImage jf_resizableImageNamed:imageName];
    [self addSubview:imageView];
}

- (void)jf_removeLayerAnimationsRecursively {
    [self.layer removeAllAnimations];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj jf_removeLayerAnimationsRecursively];
    }];
}

+ (UIWindow *)jf_getCurrentWindow {
    UIWindow *window = nil;
    // check device
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) { // iPhone
        // get key window
        for (UIWindow *a_w in [UIApplication sharedApplication].windows) {
            if (a_w.isKeyWindow) {
                window = a_w;
                break;
            }
        }

        // if key window is not exist
        if (!window) {
            window = [UIApplication sharedApplication].windows.firstObject;

        }
        if (!window) {   // if window still is not exists
            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
                window = [UIApplication sharedApplication].delegate.window;
            }
        }
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) { // iPad
        // get key window
        for (UIWindow *a_w in [UIApplication sharedApplication].windows) {
            if (a_w.isKeyWindow) {
                window = a_w;
                break;
            }
        }
        if (!window) {  // if key window is not exist
            window = [UIApplication sharedApplication].windows.firstObject;
        }
    }
    return window;
}

- (void)jf_pauseLayer
{
    CALayer *layer = self.layer;
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)jf_resumeLayer
{
    CALayer *layer = self.layer;
    CFTimeInterval pausedTime = layer.timeOffset;
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

+ (CAKeyframeAnimation *)jf_createFloatingAnimationInFrame:(CGRect)frame
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();

    int height = -150 + arc4random() % 40;
    int xOffset = frame.origin.x;
    int yOffset = frame.origin.y;
    int waveWidth = 40;
    CGPoint point1 = CGPointMake(xOffset, yOffset);
    CGPoint point2 = CGPointMake(xOffset, height + yOffset);
    CGPoint point3 = CGPointMake(xOffset, height * 2 + yOffset);
    CGPoint point4 = CGPointMake(xOffset, height * 2 + yOffset);

    CGPathMoveToPoint(path, NULL, point1.x, point1.y);
    if (arc4random() % 2) {
        CGPathAddQuadCurveToPoint(path, NULL, point1.x - arc4random() % waveWidth, point1.y + height / 2.0, point2.x, point2.y);
        CGPathAddQuadCurveToPoint(path, NULL, point2.x + arc4random() % waveWidth, point2.y + height / 2.0, point3.x, point3.y);
        CGPathAddQuadCurveToPoint(path, NULL, point3.x - arc4random() % waveWidth, point3.y + height / 2.0, point4.x, point4.y);
    } else {
        CGPathAddQuadCurveToPoint(path, NULL, point1.x + arc4random() % waveWidth, point1.y + height / 2.0, point2.x, point2.y);
        CGPathAddQuadCurveToPoint(path, NULL, point2.x - arc4random() % waveWidth, point2.y + height / 2.0, point3.x, point3.y);
        CGPathAddQuadCurveToPoint(path, NULL, point3.x + arc4random() % waveWidth, point3.y + height / 2.0, point4.x, point4.y);
    }
    animation.path = path;
    animation.calculationMode = kCAAnimationCubicPaced;
    CGPathRelease(path);
    return animation;
}
@end
