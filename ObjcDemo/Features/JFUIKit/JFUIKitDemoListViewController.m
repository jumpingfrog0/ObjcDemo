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
        @{@"title": @"UIAlertController", @"type": @"UIAlertController", @"detail": @"message 对齐、alert、action sheet"},
        @{@"title": @"UIApplication", @"type": @"UIApplication", @"detail": @"目录、key window、顶层控制器"},
        @{@"title": @"UIButton", @"type": @"UIButton", @"detail": @"图文布局、点击区域、描边动画"},
        @{@"title": @"UIColor", @"type": @"UIColor", @"detail": @"hex、alpha、色值读取、随机色"},
        @{@"title": @"UICollectionViewCell", @"type": @"UICollectionViewCell", @"detail": @"reuseIdentifier 注册和复用"},
        @{@"title": @"UIDevice", @"type": @"UIDevice", @"detail": @"型号、安全区、系统 UI 高度"},
        @{@"title": @"UIImage", @"type": @"UIImage", @"detail": @"生成、渐变、裁剪、圆角、滤镜、base64"},
        @{@"title": @"UIImageView", @"type": @"UIImageView", @"detail": @"DownloadCheck 显式启用和失败日志"},
        @{@"title": @"UIView", @"type": @"UIView", @"detail": @"frame、线条、渐变、圆角、镂空、blur、截图"},
        @{@"title": @"UILabel", @"type": @"UILabel", @"detail": @"局部颜色、关键词、行距、删除线"},
        @{@"title": @"UIScrollView", @"type": @"UIScrollView", @"detail": @"滚动到顶部、bounce 状态"},
        @{@"title": @"UITabBar", @"type": @"UITabBar", @"detail": @"凸出中心按钮 hitTest"},
        @{@"title": @"UITableViewCell", @"type": @"UITableViewCell", @"detail": @"reuseIdentifier、分组圆角"},
        @{@"title": @"UITextField", @"type": @"UITextField", @"detail": @"placeholder、长度限制、输入过滤"},
        @{@"title": @"UITextView", @"type": @"UITextView", @"detail": @"长度限制、超长回调"},
        @{@"title": @"Navigation / BarButton", @"type": @"Navigation", @"detail": @"titleView、bar button、badge、导航栏背景"},
        @{@"title": @"Alert / Toast", @"type": @"AlertToast", @"detail": @"弹窗和顶部 toast"},
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
