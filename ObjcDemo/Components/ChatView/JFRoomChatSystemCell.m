//
//  JFRoomChatSystemCell.m
//  ObjcDemo
//
//  Created by AI Assistant on 2026/01/05.
//

#import "JFRoomChatSystemCell.h"
#import <Masonry/Masonry.h>

@implementation JFRoomChatSystemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

/**
 设置UI控件
 */
- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 气泡背景View
    self.bubbleBackgroundView = [[UIView alloc] init];
    self.bubbleBackgroundView.backgroundColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.2 alpha:0.3];
    self.bubbleBackgroundView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.bubbleBackgroundView];
    
    // 内容Label
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.textColor = [UIColor darkGrayColor];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.numberOfLines = 0;
    [self.bubbleBackgroundView addSubview:self.contentLabel];
}

/**
 设置约束
 */
- (void)setupConstraints {
    // 气泡背景View约束（居中显示）
    [self.bubbleBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(4);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-4);
        make.leading.greaterThanOrEqualTo(self.contentView.mas_leading).offset(20);
        make.trailing.lessThanOrEqualTo(self.contentView.mas_trailing).offset(-20);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    // 内容Label约束
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bubbleBackgroundView.mas_leading).offset(12);
        make.trailing.equalTo(self.bubbleBackgroundView.mas_trailing).offset(-12);
        make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(4);
        make.bottom.equalTo(self.bubbleBackgroundView.mas_bottom).offset(-4);
    }];
}

/**
 配置Cell的UI
 
 @param messageModel 消息数据模型
 */
- (void)configureWithMessageModel:(JFRoomChatModel *)messageModel {
    [super configureWithMessageModel:messageModel];
    
    self.contentLabel.text = messageModel.content;
}

@end
