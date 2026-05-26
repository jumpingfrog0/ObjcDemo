//
//  JFRoomChatBaseCell.m
//  ObjcDemo
//
//  Created by huangdonghong on 2026/01/05.
//

#import "JFRoomChatBaseCell.h"

@implementation JFRoomChatBaseCell

// 普通文本消息Cell重用标识符
NSString *const JFRoomChatTextCellReuseIdentifier = @"JFRoomChatTextCellReuseIdentifier";

// 系统消息Cell重用标识符
NSString *const JFRoomChatSystemCellReuseIdentifier = @"JFRoomChatSystemCellReuseIdentifier";

- (void)awakeFromNib {
    [super awakeFromNib];
    // 初始化代码
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // 配置选中状态
}

/**
 配置Cell的UI
 
 @param messageModel 消息数据模型
 */
- (void)configureWithMessageModel:(JFRoomChatModel *)messageModel {
    self.messageModel = messageModel;
    
    // 子类重写此方法来配置具体的UI
}

@end
