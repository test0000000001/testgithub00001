//
//  MessageUserListModelBase.h
//  VideoShare
//
//  Created by capry on 13-6-24.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLDaoModelBase.h"

@interface MessageUserListModelBase : LLDaoModelBase
@property (nonatomic, strong) NSString *userid;        // 发送者用户ID
@property (nonatomic, strong) NSString *nickname;      // 昵称，base64编码,关注人如果有备注显示备注名称
@property (nonatomic, strong) NSString *headimageurl;  // 头像URL，可能为空
@property (nonatomic, strong) NSString *isattention;   // 0 未关注  1是已关注
@property (nonatomic, strong) NSString *sex;           // 性别
@property (nonatomic, strong) NSString *signature;     // base64编码
//@property (nonatomic, strong) NSString *count; // 作为陌生人当前的消息数量
@property (nonatomic, strong) NSString *lastTime;//最新消息时间
@property (nonatomic, strong) NSString* lastPrivateMessageContent;//最新消息内容
@property(nonatomic,strong)NSArray* message;//扩展用
@property (nonatomic,strong) NSString *lastact;             // 1私信，2活动，3推荐，4附近，5陌生人6LOOKLOOK官方

-(NSString *)count;

+(void)updateALLMessageUserLastContent;//更新所有私信列表最新消息时间，内容，消息类型
//获取消息的总数，陌生人消息总数
+(void)getMessageCount:(void(^)(int count,int strangerCount))block;

//获取陌生人数字
+(void)getStrangerCount:(void(^)(int strangerCount))block;

-(void)updateLastContent;//刷新私信的最新消息时间，最新消息内容，最新消息类型
//清除自己的消息数
-(void)clearMessageCount;

// 同步关注列表到消息人列表
+ (void)updateStranger;

// 标记一个用户信息为已读
+(void) updateAllReadToNoByUserid:(NSString *)userid;

@end
