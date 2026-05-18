//
//  JFObjCTestListViewController.m
//  ObjcDemo
//
//  Created by Codex on 2026/5/18.
//

#import "JFObjCTestListViewController.h"
#import "JFTestItem.h"
#import "RuntimeTestCase.h"
#import "BlockTestCase.h"
#import "MemoryTestCase.h"
#import "OtherTestCase.h"
#import "ThreadTestCase.h"
#import "AutoReleasePoolTestCase.h"

@interface JFObjCTestListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<JFTestItem *> *testItems;

@end

@implementation JFObjCTestListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Objective-C 基础测试";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupTestItems];
    [self setupTableView];
}

- (void)setupTestItems
{
    __weak typeof(self) weakSelf = self;
    self.testItems = @[
        [[JFTestItem alloc] initWithTitle:@"RuntimeTestCase" actionBlock:^{
            RuntimeTestCase *runtime = [[RuntimeTestCase alloc] init];
            [runtime runTest];
        }],
        [[JFTestItem alloc] initWithTitle:@"BlockTestCase" actionBlock:^{
            BlockTestCase *block = [[BlockTestCase alloc] init];
            [block runTest];
        }],
        [[JFTestItem alloc] initWithTitle:@"MemoryTestCase" actionBlock:^{
            MemoryTestCase *memory = [[MemoryTestCase alloc] init];
            [memory runTest];
        }],
        [[JFTestItem alloc] initWithTitle:@"OtherTestCase" actionBlock:^{
            OtherTestCase *other = [[OtherTestCase alloc] init];
            [other runTest];
        }],
        [[JFTestItem alloc] initWithTitle:@"ThreadTestCase" actionBlock:^{
            [weakSelf confirmAndRunThreadTestCase];
        }],
        [[JFTestItem alloc] initWithTitle:@"AutoReleasePoolTestCase" actionBlock:^{
            AutoReleasePoolTestCase *autoreleasePool = [[AutoReleasePoolTestCase alloc] init];
            [autoreleasePool runTest];
        }],
    ];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ObjCTestCell"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.testItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ObjCTestCell" forIndexPath:indexPath];
    JFTestItem *item = self.testItems[indexPath.row];
    cell.textLabel.text = item.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    JFTestItem *item = self.testItems[indexPath.row];
    if (item.actionBlock) {
        item.actionBlock();
    }
}

- (void)confirmAndRunThreadTestCase
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"运行 ThreadTestCase?"
                                                                   message:@"该测试会触发大量并发任务和日志输出。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"运行" style:UIAlertActionStyleDestructive handler:^(__unused UIAlertAction *action) {
        ThreadTestCase *thread = [[ThreadTestCase alloc] init];
        [thread runTest];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
