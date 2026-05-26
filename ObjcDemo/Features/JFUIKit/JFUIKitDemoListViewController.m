//
//  JFUIKitDemoListViewController.m
//  ObjcDemo
//
//  Created by huangdonghong on 2026/5/25.
//

#import "JFUIKitDemoListViewController.h"
#import "JFUIKitDemoViewController.h"
#import <Masonry/Masonry.h>

@interface JFUIKitDemoListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *items;

@end

@implementation JFUIKitDemoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"JFUIKit";
    self.view.backgroundColor = [UIColor whiteColor];
    self.items = @[
        @{@"title": @"UIColor", @"type": @"UIColor", @"detail": @"hex、alpha、色值读取、随机色"},
        @{@"title": @"UIImage", @"type": @"UIImage", @"detail": @"生成、渐变、裁剪、圆角、滤镜、base64"},
        @{@"title": @"UIView", @"type": @"UIView", @"detail": @"frame、线条、渐变、圆角、镂空、blur、截图"},
        @{@"title": @"UILabel", @"type": @"UILabel", @"detail": @"局部颜色、关键词、行距、删除线"},
        @{@"title": @"UIButton", @"type": @"UIButton", @"detail": @"图文布局、局部文字颜色"},
        @{@"title": @"UITextField", @"type": @"UITextField", @"detail": @"placeholder 颜色、输入过滤和格式化"},
        @{@"title": @"UIScrollView", @"type": @"UIScrollView", @"detail": @"滚动到顶部"},
        @{@"title": @"Navigation / BarButton", @"type": @"Navigation", @"detail": @"titleView、bar button、badge、导航栏背景"},
        @{@"title": @"Alert / Toast", @"type": @"AlertToast", @"detail": @"弹窗和顶部 toast"},
        @{@"title": @"UIApplication / UIDevice", @"type": @"AppDevice", @"detail": @"安全目录、版本、设备信息"},
    ];

    [self setupTableView];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"JFUIKitDemoCell"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JFUIKitDemoCell" forIndexPath:indexPath];
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
    JFUIKitDemoViewController *vc = [[JFUIKitDemoViewController alloc] initWithDemoType:item[@"type"]
                                                                                 title:item[@"title"]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
