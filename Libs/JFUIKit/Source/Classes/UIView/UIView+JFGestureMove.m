//
//  UIView+JFGestureMove.m
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import "UIView+JFGestureMove.h"
#import <objc/runtime.h>

@implementation UIView (JFGestureMove)

- (CGFloat)jf_leadingGestureMargin
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)jf_setLeadingGestureMargin:(CGFloat)margin
{
    objc_setAssociatedObject(self, @selector(jf_leadingGestureMargin), @(margin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)jf_topGestureMargin
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)jf_setTopGestureMargin:(CGFloat)margin
{
    objc_setAssociatedObject(self, @selector(jf_topGestureMargin), @(margin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)jf_addScreenMoveGestureWithLeadingMargin:(CGFloat)leadingMargin topMargin:(CGFloat)topMargin
{
    self.translatesAutoresizingMaskIntoConstraints = YES;
    [self jf_setLeadingGestureMargin:leadingMargin];
    [self jf_setTopGestureMargin:topMargin];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(jf_onPanAction:)];
    [self addGestureRecognizer:pan];
}

- (void)jf_viewWillBeginDragging
{
}

- (void)jf_viewEndMove
{
}

- (void)jf_isToLeading:(BOOL)isToLeading
{
}

- (void)jf_onPanAction:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIWindow *mainWindow = UIApplication.sharedApplication.keyWindow;
    if (!mainWindow && [UIApplication.sharedApplication.delegate respondsToSelector:@selector(window)]) {
        mainWindow = UIApplication.sharedApplication.delegate.window;
    }
    
    CGPoint panPoint = [gestureRecognizer locationInView:mainWindow];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(jf_endMove) object:nil];
        [self jf_viewWillBeginDragging];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self jf_moveToPoint:panPoint];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
               gestureRecognizer.state == UIGestureRecognizerStateCancelled ||
               gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [self jf_endMove];
        [self jf_viewEndMove];
    }
}

- (void)jf_moveToPoint:(CGPoint)point
{
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    point.x = MIN(MAX(point.x, 0), screenSize.width);
    point.y = MIN(MAX(point.y, 0), screenSize.height);
    self.center = point;
}

- (void)jf_endMove
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGSize screenSize = UIScreen.mainScreen.bounds.size;
        CGFloat minX = CGRectGetWidth(self.bounds) * 0.5 + [self jf_leadingGestureMargin];
        CGFloat maxX = screenSize.width - CGRectGetWidth(self.bounds) * 0.5 - [self jf_leadingGestureMargin];
        CGFloat minY = CGRectGetHeight(self.bounds) * 0.5 + [self jf_topGestureMargin];
        CGFloat maxY = screenSize.height - CGRectGetHeight(self.bounds) * 0.5 - [self jf_topGestureMargin];
        
        CGPoint endPoint = self.center;
        if (self.center.x > screenSize.width * 0.5) {
            endPoint.x = maxX;
            [self jf_isToLeading:NO];
        } else {
            endPoint.x = minX;
            [self jf_isToLeading:YES];
        }
        endPoint.y = MIN(MAX(endPoint.y, minY), maxY);
        self.center = endPoint;
    } completion:nil];
}

@end
