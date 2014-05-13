//
//  LLDaoModelPrivateMessage.h
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelBase.h"
#import "LLDaoModelDiary.h"

@interface PrivatMessageObj : NSObject

@property (nonatomic,strong) NSString *content;                      // 的佛教网i俄方年圣诞节覅违反"，  //base64编码
@property (nonatomic,strong) NSString *privmsg_type;                 // 私信类型 --- 1代表纯文字 2代表语音 3代表日记      4语音加文字
@property (nonatomic,strong) NSString *audiourl;                     // 语音地址
@property (nonatomic,strong) NSString *audioLocalPath;               // 语音本地地址
@property (nonatomic,strong) NSString *audioSize;                    // 语音大小
@property (nonatomic,strong) LLDaoModelDiary *diaries; // 日记
//@property (nonatomic,strong) NSMutableArray* attachs;           // 附件
@property (nonatomic,strong) NSString* playtime;           // 附件
@end

@interface LLDaoModelPrivateMessage : LLDaoModelBase
@property (nonatomic, strong) NSString *userid;          // 级联表id
@property (nonatomic, strong) NSString *messageid;       // 消息ID
@property (nonatomic, strong) NSString *timemill;        // 发布时间的毫秒数
@property (nonatomic, strong) NSString *act;             // 1私信，2活动，3推荐，4附近，5陌生人6LOOKLOOK官方
@property (nonatomic, strong) NSString *content;         // 消息内容
@property (nonatomic, strong) PrivatMessageObj *privmsg; // 私信内容
@property (nonatomic, strong) NSString *sendStatus;      // 私信发送状态 1.正在发送 2.已发送 3.发送失败
@property (nonatomic, strong) NSString *isMeSend;        // 是不是我发的 y:是我发的  n:不是我发的是对方发给我的
@property (nonatomic, strong) NSString *createTime;      // 日记创建时间（毫秒）
@property (nonatomic, strong) NSString *isRead;          // y:已读 n:未读

+(void) getPrivateMessageByMessageId:(NSString *)messageId block:(void(^)(LLDaoModelPrivateMessage *))blcok;

+(void) deleteLoacalFilebyMessageId:(NSString *)messageId;
@end
