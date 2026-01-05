//
//  JFRoomChatView.m
//  ObjcDemo
//
//  Created by AI Assistant on 2026/01/05.
//

#import "JFRoomChatView.h"
#import "JFRoomChatBaseCell.h"
#import "JFRoomChatTextCell.h"
#import "JFRoomChatSystemCell.h"
#import <Masonry/Masonry.h>

@interface JFRoomChatView () <UITableViewDataSource, UITableViewDelegate>

/**
 消息列表表格视图
 */
@property (nonatomic, strong) UITableView *messageTableView;

/**
 消息数据源数组
 */
@property (nonatomic, strong) NSMutableArray<JFRoomChatModel *> *messageArray;

/**
 是否需要自动滚动到最新消息
 */
@property (nonatomic, assign) BOOL needAutoScroll;

@end

@implementation JFRoomChatView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _maxMessageCount = 50; // 默认最大消息数量为50条
        _needAutoScroll = YES;
        
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

/**
 设置UI控件
 */
- (void)setupUI {
    // 消息列表表格视图
    self.messageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageTableView.showsVerticalScrollIndicator = NO;
    self.messageTableView.showsHorizontalScrollIndicator = NO;
    self.messageTableView.estimatedRowHeight = 60;
    self.messageTableView.rowHeight = UITableViewAutomaticDimension;
    [self.messageTableView registerClass:[JFRoomChatTextCell class] forCellReuseIdentifier:JFRoomChatTextCellReuseIdentifier];
    [self.messageTableView registerClass:[JFRoomChatSystemCell class] forCellReuseIdentifier:JFRoomChatSystemCellReuseIdentifier];
    [self addSubview:self.messageTableView];
    
    // 初始化消息数组
    self.messageArray = [NSMutableArray array];
}

/**
 设置约束
 */
- (void)setupConstraints {
    // 消息列表表格视图约束
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFRoomChatModel *messageModel = self.messageArray[indexPath.row];
    JFRoomChatBaseCell *cell;
    
    if (messageModel.messageType == JFRoomChatMessageTypeText) {
        // 普通文本消息Cell
        cell = [tableView dequeueReusableCellWithIdentifier:JFRoomChatTextCellReuseIdentifier forIndexPath:indexPath];
    } else {
        // 系统消息Cell
        cell = [tableView dequeueReusableCellWithIdentifier:JFRoomChatSystemCellReuseIdentifier forIndexPath:indexPath];
    }
    
    // 配置Cell
    [cell configureWithMessageModel:messageModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 用户开始拖动，停止自动滚动
    self.needAutoScroll = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 检查是否滚动到底部，如果是则继续自动滚动
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - 10) {
        self.needAutoScroll = YES;
    }
}

#pragma mark - Public Methods

/**
 添加一条公屏消息
 
 @param messageModel 消息模型
 */
- (void)addMessage:(JFRoomChatModel *)messageModel {
    if (!messageModel) return;
    
    [self.messageArray addObject:messageModel];
    
    // 检查是否超过最大消息数量
    if (self.messageArray.count > self.maxMessageCount) {
        [self.messageArray removeObjectAtIndex:0];
    }
    
    // 刷新表格
    [self.messageTableView reloadData];
    
    // 自动滚动到最新消息
    if (self.needAutoScroll) {
        [self scrollToLatestMessage];
    }
}

/**
 添加多条公屏消息
 
 @param messageModels 消息模型数组
 */
- (void)addMessages:(NSArray<JFRoomChatModel *> *)messageModels {
    if (!messageModels || messageModels.count == 0) return;
    
    [self.messageArray addObjectsFromArray:messageModels];
    
    // 检查是否超过最大消息数量
    if (self.messageArray.count > self.maxMessageCount) {
        NSInteger removeCount = self.messageArray.count - self.maxMessageCount;
        [self.messageArray removeObjectsInRange:NSMakeRange(0, removeCount)];
    }
    
    // 刷新表格
    [self.messageTableView reloadData];
    
    // 自动滚动到最新消息
    if (self.needAutoScroll) {
        [self scrollToLatestMessage];
    }
}

/**
 清空所有消息
 */
- (void)clearAllMessages {
    [self.messageArray removeAllObjects];
    [self.messageTableView reloadData];
}

#pragma mark - Private Methods

/**
 滚动到最新消息
 */
- (void)scrollToLatestMessage {
    if (self.messageArray.count == 0) return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
        [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

@end
