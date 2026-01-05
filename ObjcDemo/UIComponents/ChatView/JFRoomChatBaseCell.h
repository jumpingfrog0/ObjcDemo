//
//  JFRoomChatBaseCell.h
//  ObjcDemo
//
//  Created by AI Assistant on 2026/01/05.
//

#import <UIKit/UIKit.h>
#import "JFRoomChatModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 直播间公屏消息Cell基类
 */
@interface JFRoomChatBaseCell : UITableViewCell

/**
 普通文本消息Cell重用标识符
 */
FOUNDATION_EXPORT NSString *const JFRoomChatTextCellReuseIdentifier;

/**
 系统消息Cell重用标识符
 */
FOUNDATION_EXPORT NSString *const JFRoomChatSystemCellReuseIdentifier;

/**
 消息数据模型
 */
@property (nonatomic, strong) JFRoomChatModel *messageModel;

/**
 配置Cell的UI
 
 @param messageModel 消息数据模型
 */
- (void)configureWithMessageModel:(JFRoomChatModel *)messageModel;

@end

NS_ASSUME_NONNULL_END
