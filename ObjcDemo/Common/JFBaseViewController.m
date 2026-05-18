//
//  JFBaseViewController.m
//  ObjcDemo
//
//  Created by huangdonghong on 2026/1/5.
//

#import "JFBaseViewController.h"

@interface JFBaseViewController ()

@end

@implementation JFBaseViewController

- (void)loadView
{
    [super loadView];
    
#if DEBUG
        [self addInjectionObserver];
#endif
}

#if DEBUG

- (BOOL)injectionEnabled
{
    return NO;
}

- (void)addInjectionObserver
{
    if ([self injectionEnabled]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInjectionReloadUI) name:@"INJECTION_BUNDLE_NOTIFICATION" object:nil];
    }
}

- (void)onInjectionReloadUI
{
    [self viewDidLoad];
    [self viewWillAppear:YES];
    [self viewWillDisappear:YES];
}
#endif

@end
