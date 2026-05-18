//
//  JFRoomChatBaseCell.m
//  ObjcDemo
//
//  Created by AI Assistant on 2026/01/05.
//

#import "JFRoomChatBaseCell.h"

@implementation JFRoomChatBaseCell

// 普通文本消息Cell重用标识符
NSString *const JFRoomChatTextCellReuseIdentifier = @"JFRoomChatTextCellReuseIdentifier";

// 系统消息Cell重用标识符
NSString *const JFRoomChatSystemCellReuseIdentifier = @"JFRoomChatSystemCellReuseIdentifier";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
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
