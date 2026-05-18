//
//  AppDelegate.m
//  ObjcDemo
//
//  Created by 黄东鸿 on 2024/1/27.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "JFRootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1. 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    
    // 2. 创建根视图控制器
//    ViewController *rootViewController = [[ViewController alloc] init];
    JFRootViewController *rootViewController = [[JFRootViewController alloc] init];

    // 3. 创建导航控制器
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    // 4. 设置窗口的根视图控制器
    self.window.rootViewController = navigationController;

    // 5. 使窗口可见
    [self.window makeKeyAndVisible];
    
    // 6. 可选：设置应用外观
    [self setupAppearance];
    
    // 调试工具
    [self debugTools];
    
    return YES;
}

- (void)setupAppearance {
    // 设置导航栏样式
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor systemBlueColor];
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:18]
        };
        
        [UINavigationBar appearance].standardAppearance = appearance;
        [UINavigationBar appearance].scrollEdgeAppearance = appearance;
    } else {
        [[UINavigationBar appearance] setBarTintColor:[UIColor systemBlueColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:18]
        }];
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
}

- (void)debugTools
{
#if DEBUG
    [self iOSInjection];
#endif
}

#if DEBUG
- (void)iOSInjection
{
    // https://github.com/johnno1962/InjectionIII/blob/main/README_Chinese.md
    // InjectionIII 代码热重载工具
    
#if TARGET_IPHONE_SIMULATOR
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
#else
    BOOL result = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"iOSInjection" ofType:@"bundle"];
    if (!path) {
        path = [[NSBundle mainBundle] pathForResource:@"macOSInjection" ofType:@"bundle"];
    }
    if (path) {
        result = [[NSBundle bundleWithPath:path] load];
    }
    
    if (result) {
        NSLog(@"iOSInjection 加载成功");
    }
#endif
    
}

#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // 应用即将进入非活动状态
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 应用进入后台
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 应用即将进入前台
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 应用已激活
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // 应用即将终止
}


@end
