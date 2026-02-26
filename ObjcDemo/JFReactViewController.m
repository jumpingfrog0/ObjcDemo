//
//  JFReactViewController.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2026/1/18.
//

#if REACT_NATIVE_ENABLED

#import "JFReactViewController.h"
#import <React/RCTBundleURLProvider.h>
#import <RCTReactNativeFactory.h>
#import <RCTDefaultReactNativeFactoryDelegate.h>
#import <RCTAppDependencyProvider.h>

@interface ReactNativeFactoryDelegate: RCTDefaultReactNativeFactoryDelegate
@end

@implementation ReactNativeFactoryDelegate

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [self bundleURL];
}

- (NSURL *)bundleURL
{
#if DEBUG
  return [RCTBundleURLProvider.sharedSettings jsBundleURLForBundleRoot:@"index"];
#else
  return [NSBundle.mainBundle URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end

@interface JFReactViewController ()

@property (nonatomic, strong) RCTReactNativeFactory *factory;
@property (nonatomic, strong) id<RCTReactNativeFactoryDelegate> factoryDelegate;

@end

@implementation JFReactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _factoryDelegate = [ReactNativeFactoryDelegate new];
    _factoryDelegate.dependencyProvider = [RCTAppDependencyProvider new];
    _factory = [[RCTReactNativeFactory alloc] initWithDelegate:_factoryDelegate];
    self.view = [_factory.rootViewFactory viewWithModuleName:@"ReactNativeDemo"];
}

@end
#endif
