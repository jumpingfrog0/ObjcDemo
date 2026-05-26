//
//  JFRoomChatTextCell.m
//  ObjcDemo
//
//  Created by huangdonghong on 2026/01/05.
//

#import "JFRoomChatTextCell.h"
#import <Masonry/Masonry.h>

@implementation JFRoomChatTextCell

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
    
    // 头像ImageView
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 15;
    [self.contentView addSubview:self.avatarImageView];
    
    // 气泡背景View
    self.bubbleBackgroundView = [[UIView alloc] init];
    self.bubbleBackgroundView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.3];
    self.bubbleBackgroundView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.bubbleBackgroundView];
    
    // 昵称Label
    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.nicknameLabel.textColor = [UIColor blackColor];
    self.nicknameLabel.numberOfLines = 1;
    [self.bubbleBackgroundView addSubview:self.nicknameLabel];
    
    // 内容Label
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.numberOfLines = 0;
    [self.bubbleBackgroundView addSubview:self.contentLabel];
}

/**
 设置约束
 */
- (void)setupConstraints {
    // 头像ImageView约束
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(12);
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.width.height.mas_equalTo(30);
    }];
    
    // 气泡背景View约束
    [self.bubbleBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarImageView.mas_trailing).offset(8);
        make.trailing.lessThanOrEqualTo(self.contentView.mas_trailing).offset(-12);
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        make.width.lessThanOrEqualTo(@250);
    }];
    
    // 昵称Label约束
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bubbleBackgroundView.mas_leading).offset(8);
        make.trailing.equalTo(self.bubbleBackgroundView.mas_trailing).offset(-8);
        make.top.equalTo(self.bubbleBackgroundView.mas_top).offset(6);
    }];
    
    // 内容Label约束
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bubbleBackgroundView.mas_leading).offset(8);
        make.trailing.equalTo(self.bubbleBackgroundView.mas_trailing).offset(-8);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(4);
        make.bottom.equalTo(self.bubbleBackgroundView.mas_bottom).offset(-6);
    }];
}

/**
 配置Cell的UI
 
 @param messageModel 消息数据模型
 */
- (void)configureWithMessageModel:(JFRoomChatModel *)messageModel {
    [super configureWithMessageModel:messageModel];
    
    self.nicknameLabel.text = messageModel.nickname;
    self.contentLabel.text = messageModel.content;
    
    // 如果有头像URL，这里可以实现图片加载逻辑
    // 暂时使用默认头像颜色
    self.avatarImageView.backgroundColor = [UIColor lightGrayColor];
}

@end
