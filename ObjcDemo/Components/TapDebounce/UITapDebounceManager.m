//
//  UITapDebounceManager.m
//  Famo
//
//  Created by huangdonghong on 2025/6/9.
//

#import "UITapDebounceManager.h"
#import <objc/runtime.h>

@interface UITapDebounceManager ()
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) BOOL immediateFirst;
@property (nonatomic, assign) BOOL isFirstTap;
@property (nonatomic, strong) dispatch_block_t workItem;
@end

@implementation UITapDebounceManager

- (instancetype)initWithDelay:(NSTimeInterval)delay immediateFirst:(BOOL)immediateFirst 
{
    self = [super init];
    if (self) {
        _delay = delay;
        _immediateFirst = immediateFirst;
        _isFirstTap = YES;
    }
    return self;
}

- (void)handleTap 
{
    if (!self.actionBlock) return;
    
    if (self.immediateFirst && self.isFirstTap) {
        self.isFirstTap = NO;
        self.actionBlock();
        return;
    }
    
    if (self.workItem) {
        dispatch_block_cancel(self.workItem);
    }
    
    self.workItem = dispatch_block_create(0, ^{
        if (self.actionBlock) {
            self.actionBlock();
        }
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), self.workItem);
}

@end

// MARK: - UIButton Category
static char kButtonDebounceManagerKey;

@implementation UIButton (TapDebounce)

- (UITapDebounceManager *)debounceManager 
{
    UITapDebounceManager *manager = objc_getAssociatedObject(self, &kButtonDebounceManagerKey);
    if (!manager) {
        manager = [[UITapDebounceManager alloc] initWithDelay:0.5 immediateFirst:NO];
        objc_setAssociatedObject(self, &kButtonDebounceManagerKey, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return manager;
}

- (void)addTapDebounceWithDelay:(NSTimeInterval)delay immediateFirst:(BOOL)immediateFirst action:(void(^)(void))action 
{
    // Create new manager with specified configuration
    UITapDebounceManager *manager = [[UITapDebounceManager alloc] initWithDelay:delay immediateFirst:immediateFirst];
    manager.actionBlock = action;
    objc_setAssociatedObject(self, &kButtonDebounceManagerKey, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Add target action
    [self addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleTap 
{
    [self.debounceManager handleTap];
}

@end

// MARK: - UIView Category
static char kViewDebounceManagerKey;
static char kViewTapGestureKey;

@implementation UIView (TapDebounce)

- (UITapDebounceManager *)debounceManager 
{
    UITapDebounceManager *manager = objc_getAssociatedObject(self, &kViewDebounceManagerKey);
    if (!manager) {
        manager = [[UITapDebounceManager alloc] initWithDelay:0.5 immediateFirst:NO];
        objc_setAssociatedObject(self, &kViewDebounceManagerKey, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return manager;
}

- (UITapGestureRecognizer *)tapGesture 
{
    return objc_getAssociatedObject(self, &kViewTapGestureKey);
}

- (void)setTapGesture:(UITapGestureRecognizer *)gesture 
{
    objc_setAssociatedObject(self, &kViewTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addTapDebounceWithDelay:(NSTimeInterval)delay immediateFirst:(BOOL)immediateFirst action:(void(^)(void))action 
{
    // Remove existing gesture if any
    [self removeTapDebounce];
    
    // Create new manager with specified configuration
    UITapDebounceManager *manager = [[UITapDebounceManager alloc] initWithDelay:delay immediateFirst:immediateFirst];
    manager.actionBlock = action;
    objc_setAssociatedObject(self, &kViewDebounceManagerKey, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Create and add gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    self.tapGesture = tapGesture;
    [self addGestureRecognizer:tapGesture];
}

- (void)removeTapDebounce 
{
    if (self.tapGesture) {
        [self removeGestureRecognizer:self.tapGesture];
        self.tapGesture = nil;
    }
}

- (void)handleTap 
{
    [self.debounceManager handleTap];
}

@end 
