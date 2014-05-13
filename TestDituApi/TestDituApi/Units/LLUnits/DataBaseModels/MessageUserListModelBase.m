//
//  MessageUserListModelBase.m
//  VideoShare
//
//  Created by capry on 13-6-24.
//  存储消息列表展示页数据
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "MessageUserListModelBase.h"
#import "LLDaoModelPrivateMessage.h"
#import "ContactsModel.h"

@implementation MessageUserListModelBase
@synthesize userid;        // 发送者用户ID
@synthesize nickname;      // 昵称，base64编码,关注人如果有备注显示备注名称
@synthesize headimageurl;  // 头像URL，可能为空
@synthesize isattention;   // 0 未关注  1是已关注
@synthesize sex;           // 性别
@synthesize signature;     // base64编码
@synthesize message,lastPrivateMessageContent,lastTime,lastact;

-(NSString *)count
{
    __block NSString *resultStr = nil;
    NSString *whereStr = [NSString stringWithFormat:@"userid=\'%@\' AND isRead=\'n\'", self.userid];
    [[LLDAOBase shardLLDAOBase] getTotalRowsIn:[LLDaoModelPrivateMessage class]
                                         where:whereStr
                                      callBack:^(long resultLong)
     {
         resultStr = [NSString stringWithFormat:@"%ld",resultLong];
     }];
    return resultStr;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        self.primaryKey = @"userid";//主健
    }
    return self;
}

+(void)getStrangerCount:(void(^)(int strangerCount))block{
    NSString *whereStr = [NSString stringWithFormat:@"isattention = \'0\'"];
    [[LLDAOBase shardLLDAOBase]searchAll:[[MessageUserListModelBase alloc]init]
                                   where:whereStr 
                                callback:^(NSArray* array)
    {
        block(array.count);
    }];
}

// 同步关注人列表到消息人列表
+ (void)updateStranger
{
    // 抽出所有消息人
    __block NSArray *messageUsers = nil;
    [[LLDAOBase shardLLDAOBase]searchAll:[[MessageUserListModelBase alloc]init]
                                   where:nil
                                callback:^(NSArray* array)
     {
         messageUsers = array;
     }];
    
    // 逐个判断消息人是否是关注人, 并保存到消息人列表
    for (MessageUserListModelBase *messageUser in messageUsers) {
        // 1私信，2活动，3推荐，4附近，5陌生人6LOOKLOOK官方
        if ([messageUser.lastact isEqualToString:@"2"] || [messageUser.lastact isEqualToString:@"3"] || [messageUser.lastact isEqualToString:@"4"] || [messageUser.lastact isEqualToString:@"6"]) {
            continue;
        }
        LLDaoModelContacts *foundContact = [ContactsModel getUserInfoInAttentionList:messageUser.userid];
        if (foundContact) {
            messageUser.isattention = @"1";
            
            [[LLDAOBase shardLLDAOBase] updateInsertToDB:messageUser callback:^(BOOL result) {
                
            }];
        }
        else {
            messageUser.isattention = @"0";
            [[LLDAOBase shardLLDAOBase] updateInsertToDB:messageUser callback:^(BOOL result) {
                
            }];
        }
    }

}

+(void)getMessageCount:(void(^)(int count,int strangerCount))block{
    [[LLDAOBase shardLLDAOBase]searchAll:[[MessageUserListModelBase alloc]init] callback:^(NSArray* array){
        int count = 0;
        int strangerCount = 0;
        for(MessageUserListModelBase* base in array){
            count += base.count.intValue;
            if(![base.isattention isEqualToString:@"1"]){
                strangerCount += base.count.intValue;
            }
        }
        if(block != nil){
            block(count,strangerCount);
        }
    }];
}

+(void) updateAllReadToNoByUserid:(NSString *)userid
{
    NSMutableDictionary *columnDic = [NSMutableDictionary dictionary];
    [columnDic setObject:@"y" forKey:@"isRead"];
    
    NSString *whereStr = [NSString stringWithFormat:@"userid=\'%@\'",userid];
    [[LLDAOBase shardLLDAOBase] updateToDB:[LLDaoModelPrivateMessage class]
                                       dic:columnDic
                                     where:whereStr
                                  callback:^(BOOL result)
     {}];
}

-(void)clearMessageCount{
//    self.count = @"0";
    [[LLDAOBase shardLLDAOBase]updateToDB:[self class] dic:[NSDictionary dictionaryWithObjectsAndKeys:self.count,@"count", nil] dic:[NSDictionary dictionaryWithObjectsAndKeys:self.userid,self.primaryKey,nil] callback:nil];
}
+(void)updateALLMessageUserLastContent{
    [[LLDAOBase shardLLDAOBase]searchAll:[[MessageUserListModelBase alloc]init] callback:^(NSArray* array){
        for(MessageUserListModelBase* base in array){
            [base updateLastContent];
        }
    }];
}
-(void)updateCountWithReadType{
    [[LLDAOBase shardLLDAOBase]getTotalRowsIn:[LLDaoModelPrivateMessage class] dic:[NSDictionary dictionaryWithObjectsAndKeys:self.userid,@"userid",@"n",@"isRead", nil] callBack:^(long count){
//        self.count = [NSString stringWithFormat:@"%ld",count];
    }];
}
-(void)updateLastContent{
    [[LLDAOBase shardLLDAOBase]searchWhereDic:[[LLDaoModelPrivateMessage alloc]init] Dic:[NSDictionary dictionaryWithObjectsAndKeys:self.userid,@"userid", nil] orderBy:@"timemill" asc:NO offset:0 count:1 callback:^(NSArray* array){
        if(array.count > 0){
            LLDaoModelPrivateMessage* privateMessage = [array lastObject];
            self.lastTime = privateMessage.timemill;
            self.lastPrivateMessageContent = privateMessage.content;
            [self updateCountWithReadType];
            self.lastact = privateMessage.act;
            if(![self.lastact isEqualToString:@"1"]){
                if(![self.lastact isEqualToString:@"5"]){
                    self.isattention = @"1";
                }else{
                    self.isattention = @"0";
                }
            }
        }else{
//            self.count = @"0";
            self.lastTime = @"";
            self.lastPrivateMessageContent = @"";
        }
        [[LLDAOBase shardLLDAOBase]updateToDB:self callback:nil];
    }];
}
-(void)setLastPrivateMessageContent:(NSString *)content{
    if([content hasPrefix:STRING_SHARE_SIXIN]){
        content = STRING_SHARE_SIXIN;
    }
    lastPrivateMessageContent = content;
}
+(id)customClassWithProperties:(id)properties{
    MessageUserListModelBase* model = [super customClassWithProperties:properties];
    NSMutableArray* array = [NSMutableArray array];
    for(NSDictionary* dic in model.message){
        LLDaoModelPrivateMessage* message = [LLDaoModelPrivateMessage customClassWithProperties:dic];
        message.userid = model.userid;
        [array addObject:message];
        model.lastTime = message.timemill;
        model.lastPrivateMessageContent = message.content;
        model.lastact = message.act;
    }
    model.message = array;
    if(![model.lastact isEqualToString:@"1"]){
        if(![model.lastact isEqualToString:@"5"]){
            model.isattention = @"1";
        }else{
            model.isattention = @"0";
        }
    }
    if(STR_IS_NIL(model.isattention)){
        model.isattention = @"0";
    }
    return model;
}
@end
