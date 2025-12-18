//
//  UITapDebounceManager.h
//  Famo
//
//  Created by huangdonghong on 2025/6/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITapDebounceManager : NSObject

@property (nullable, nonatomic, copy) void (^actionBlock)(void);

- (instancetype)initWithDelay:(NSTimeInterval)delay immediateFirst:(BOOL)immediateFirst;
- (void)handleTap;

@end

@interface UIButton (TapDebounce)

- (void)addTapDebounceWithDelay:(NSTimeInterval)delay immediateFirst:(BOOL)immediateFirst action:(void(^)(void))action;

@end

@interface UIView (TapDebounce)

- (void)addTapDebounceWithDelay:(NSTimeInterval)delay immediateFirst:(BOOL)immediateFirst action:(void(^)(void))action;
- (void)removeTapDebounce;

@end

NS_ASSUME_NONNULL_END 
