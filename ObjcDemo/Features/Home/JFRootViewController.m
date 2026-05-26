//
//  JFRootViewController.m
//  ObjcDemo
//
//  Created by huangdonghong on 2026/1/5.
//

#import "JFRootViewController.h"
#import <Masonry/Masonry.h>
#import "JFTestItem.h"

#import "JFRoomChatView.h"
#import "JFRoomChatModel.h"

#import "JFAsrViewController.h"
#import "JFReactViewController.h"
#import "JFObjCTestListViewController.h"
#import "FamVapTestController.h"
#import "JFFoundationDemoListViewController.h"
#import "JFUIKitDemoListViewController.h"

@interface JFRootViewController ()

@end

@implementation JFRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"功能测试列表";
    
    // 初始化测试项
    [self setupTestItems];
    
    // 创建并配置tableView
    [self setupTableView];
}

- (void)setupTestItems
{
    __weak typeof(self) weakSelf = self;
    
    
    self.testItems = [NSMutableArray array];
    [self.testItems addObject:[[JFTestItem alloc] initWithTitle:@"JFFoundation"
                                                    actionBlock:^{
                                 [weakSelf navigateToJFFoundation];
                             }]];

    [self.testItems addObject:[[JFTestItem alloc] initWithTitle:@"JFUIKit"
                                                    actionBlock:^{
                                 [weakSelf navigateToJFUIKit];
                             }]];

    [self.testItems addObject:[[JFTestItem alloc] initWithTitle:@"Objective-C 基础测试"
                                                    actionBlock:^{
                                 [weakSelf navigateToObjcTestCases];
                             }]];

    [self.testItems addObject:[[JFTestItem alloc] initWithTitle:@"公屏组件测试"
                                                       actionBlock:^{
                                    [weakSelf navigateToRoomChatTest];
    }]];
    
#if REACT_NATIVE_ENABLED
    [self.testItems addObject:[[JFTestItem alloc] initWithTitle:@"rn 页面"
                                                    actionBlock:^{
                                 [weakSelf navigateToReactNative];
                             }]];
#endif
    
    [self.testItems addObject:[[JFTestItem alloc] initWithTitle:@"语音ASR"
                                                    actionBlock:^{
                                 [weakSelf navigateToASR];
                             }]];

    [self.testItems addObject:[[JFTestItem alloc] initWithTitle:@"VAP 测试"
                                                    actionBlock:^{
                                 [weakSelf navigateToVAP];
                             }]];
}

- (void)setupTableView
{
    self.testListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.testListTableView.dataSource = self;
    self.testListTableView.delegate = self;
    
    // 注册cell
    [self.testListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCell"];
    
    [self.view addSubview:self.testListTableView];
    
    // 设置约束
    [self.testListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.testItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    
    JFTestItem *item = self.testItems[indexPath.row];
    cell.textLabel.text = item.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JFTestItem *item = self.testItems[indexPath.row];
    
    if (item.actionBlock) {
        item.actionBlock();
    }
}

#pragma mark - Actions

- (void)navigateToASR
{
    JFAsrViewController *vc = [JFAsrViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToJFFoundation
{
    JFFoundationDemoListViewController *vc = [JFFoundationDemoListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToJFUIKit
{
    JFUIKitDemoListViewController *vc = [JFUIKitDemoListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToVAP
{
    FamVapTestController *vc = [FamVapTestController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToObjcTestCases
{
    JFObjCTestListViewController *vc = [JFObjCTestListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToReactNative
{
#if REACT_NATIVE_ENABLED
    JFReactViewController *vc = [JFReactViewController new];
    [self.navigationController pushViewController:vc animated:YES];
#endif
}

- (void)navigateToRoomChatTest
{
    // 创建公屏视图所在的测试控制器
    UIViewController *testVC = [[UIViewController alloc] init];
    testVC.title = @"公屏组件测试";
    testVC.view.backgroundColor = [UIColor whiteColor];
    
    // 创建公屏视图
    JFRoomChatView *chatView = [[JFRoomChatView alloc] initWithFrame:CGRectZero];
    [testVC.view addSubview:chatView];
    
    // 设置约束
    [chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(testVC.view);
    }];
    
    // 添加测试消息
    JFRoomChatModel *textMessage = [[JFRoomChatModel alloc] initWithTextContent:@"Hello, World!"
                                                                       nickname:@"User123"
                                                                      avatarURL:nil];
    [chatView addMessage:textMessage];
    
    JFRoomChatModel *systemMessage = [[JFRoomChatModel alloc] initWithSystemContent:@"Welcome to the room!"];
    [chatView addMessage:systemMessage];
    
    // 导航到测试页面
    [self.navigationController pushViewController:testVC animated:YES];
}

@end
