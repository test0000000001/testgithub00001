//
//  LLDaoModelPrivateMessage.m
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelDiary.h"
#import "LLDaoModelDiary.h"
#import "GetMessageModel.h"
#import "LocalResourceModel.h"
#import "LLDaoModelPrivateMessage.h"

@implementation PrivatMessageObj

@synthesize content;                      // 的佛教网i俄方年圣诞节覅违反"，  //base64编码
@synthesize privmsg_type;                 // 私信类型 --- 1代表纯文字 2代表语音 3代表日记      4语音加文字
@synthesize audiourl;                     // 语音地址
@synthesize diaries;                      // 日记
@synthesize audioLocalPath;               // 语音本地地址
@synthesize audioSize;                    // 语音大小
@synthesize playtime;
//@synthesize attachs;
+(id)customClassWithProperties:(id)properties
{
    PrivatMessageObj *returnObject = [super customClassWithProperties:properties];
    returnObject.diaries = [LLDaoModelDiary customClassWithProperties:returnObject.diaries];
//    returnObject.attachs = [LLDaoModelDiaryAttachsCell customClassWithProperties:returnObject.attachs];
    return returnObject;
}

@end

@implementation LLDaoModelPrivateMessage

@synthesize userid;          // 级联表id
@synthesize messageid;       // 消息ID
@synthesize timemill;        // 发布时间的毫秒数
@synthesize act;             // 1私信，2活动，3推荐，4附近，5陌生人6LOOKLOOK官方
@synthesize content;         // 消息内容
@synthesize privmsg;         // 私信内容
@synthesize sendStatus;      // 私信发送状态 1.正在发送 2.已发送 3.发送失败
@synthesize isMeSend;        // 是不是我发的 y:是我发的  n:不是我发的是对方发给我的
@synthesize createTime;      // 创建时间(毫秒）
@synthesize isRead;          // y:已读 n:未读

-(BOOL) isEqual:(id)object
{
    LLDaoModelPrivateMessage *message = (LLDaoModelPrivateMessage*)object;
    return [self.messageid isEqualToString:message.messageid];
}

-(id)init
{
    self = [super init];
    if (self)
    {
        self.primaryKey = @"messageid";//主健
        self.isMeSend = @"n";
        self.createTime = [GetMessageModel getSystemCurrentTimeMilli];
        self.isRead = @"n";
    }
    return self;
}

+(id)customClassWithProperties:(id)properties
{
    LLDaoModelPrivateMessage *returnObject = [super customClassWithProperties:properties];
    returnObject.privmsg = [PrivatMessageObj customClassWithProperties:returnObject.privmsg];
    return returnObject;
}

+(void) getPrivateMessageByMessageId:(NSString *)messageId block:(void(^)(LLDaoModelPrivateMessage *))blcok
{
    NSString *whereStr = [NSString stringWithFormat:@"messageid = \'%@\'",messageId];
    [[LLDAOBase shardLLDAOBase] searchAll:[[LLDaoModelPrivateMessage alloc] init]
                                    where:whereStr
                                 callback:^(NSArray *resultArray)
     {
         if (resultArray.count > 0)
         {
             blcok([resultArray objectAtIndex:0]);
         }
         else
         {
             blcok(nil);
         }
     }];
}

+(void) deleteLoacalFilebyMessageId:(NSString *)messageId
{
    [self getPrivateMessageByMessageId:messageId
                                 block:^(LLDaoModelPrivateMessage *llDaoModelPrivateMessage)
     {
         if (llDaoModelPrivateMessage)
         {
             [self deleteLocalFile:llDaoModelPrivateMessage];
         }
     }];
}

+(void) deleteLocalFile:(LLDaoModelPrivateMessage *)llDaoModelPrivateMessage
{
    NSString *privateMsgType = llDaoModelPrivateMessage.privmsg.privmsg_type;
    NSString *audioPath      = llDaoModelPrivateMessage.privmsg.audioLocalPath;
     // 私信类型 --- 1代表纯文字 2代表语音 3代表日记      4语音加文字
    if ([privateMsgType isEqualToString:@"2"] || [privateMsgType isEqualToString:@"4"])
    {
        if (!STR_IS_NIL(audioPath))
        {
            [LocalResourceModel deleteLocalFile:audioPath];
        }
    }
    else if ([privateMsgType isEqualToString:@"3"])
    {
        LLDaoModelDiary *messageDiary = llDaoModelPrivateMessage.privmsg.diaries;
        if(messageDiary)
        {
            for (LLDaoModelDiaryAttachsCell* cell in messageDiary.attachs)
            {
                //视频
                if(!STR_IS_NIL(cell.localfilePath))
                {
                    [LocalResourceModel deleteLocalFile:cell.localfilePath];
                }
                if (!STR_IS_NIL(cell.downLoadFilePath))
                {
                    [LocalResourceModel deleteLocalFile:cell.downLoadFilePath];
                }
            }
        }

    }
}

@end
