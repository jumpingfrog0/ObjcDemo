//
//  JFFoundationDemoListViewController.m
//  ObjcDemo
//
//  Created by huangdonghong on 2026/5/25.
//

#import "JFFoundationDemoListViewController.h"
#import "JFFoundationDemoDetailViewController.h"
#import <Masonry/Masonry.h>

@interface JFFoundationDemoListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *items;

@end

@implementation JFFoundationDemoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"JFFoundation";
    self.view.backgroundColor = [UIColor whiteColor];
    self.items = @[
        @{@"title": @"NSString", @"category": @"NSString", @"detail": @"格式化、校验、URL、JSON、加密"},
        @{@"title": @"NSArray / NSMutableArray", @"category": @"NSArray", @"detail": @"安全访问、map/filter、队列栈"},
        @{@"title": @"NSDictionary", @"category": @"NSDictionary", @"detail": @"JSON、URL query、空值过滤、安全取值"},
        @{@"title": @"NSDate / NSCalendar", @"category": @"NSDate", @"detail": @"日期格式化、边界、加减、天数"},
        @{@"title": @"NSData / NSURL", @"category": @"DataURL", @"detail": @"JSON、MD5、图片类型、URL 参数"},
        @{@"title": @"NSNumber / NSLocale / AttributedString", @"category": @"Misc", @"detail": @"数字长度、Locale、删除线、浮点工具"},
        @{@"title": @"NSObject", @"category": @"NSObject", @"detail": @"动态 selector 调用"},
    ];

    [self setupTableView];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"JFFoundationDemoCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.leading.trailing.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JFFoundationDemoCell" forIndexPath:indexPath];
    NSDictionary *item = self.items[indexPath.row];

    UIListContentConfiguration *content = [UIListContentConfiguration subtitleCellConfiguration];
    content.text = item[@"title"];
    content.secondaryText = item[@"detail"];
    cell.contentConfiguration = content;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *item = self.items[indexPath.row];
    JFFoundationDemoDetailViewController *vc = [[JFFoundationDemoDetailViewController alloc] initWithCategory:item[@"category"]
                                                                                                         title:item[@"title"]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
