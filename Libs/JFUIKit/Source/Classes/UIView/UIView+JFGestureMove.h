//
//  UIView+JFGestureMove.h
//  JFUIKit
//
//  Created by huangdonghong on 2026/06/03.
//

#import <UIKit/UIKit.h>

@interface UIView (JFGestureMove)

/**
 * 添加拖拽后贴到屏幕左右边缘的手势
 */
- (void)jf_addScreenMoveGestureWithLeadingMargin:(CGFloat)leadingMargin topMargin:(CGFloat)topMargin;

/**
 * 拖拽开始和结束回调，子类可重写
 */
- (void)jf_viewWillBeginDragging;
- (void)jf_viewEndMove;

@end
