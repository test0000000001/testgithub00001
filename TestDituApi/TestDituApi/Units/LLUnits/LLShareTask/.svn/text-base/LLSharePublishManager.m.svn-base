//
//  LLSharePublishManager.m
//  VideoShare
//
//  Created by tangyx on 13-6-20.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLSharePublishManager.h"
#import "LLFreeTaskManager.h"
#import "NSObject+ABJsonConverter.h"
#import "LLShareTask.h"
#import "LLDaoBase.h"
#import "LLDaoModelDiary.h"
#import "ContactsModel.h"
#import "PrivateMessageModel.h"
#import "LLDaoModelContacts.h"
@implementation LLSharePublishManager
//第三方分享 私信
+(void)thirdPublishSend:(LLShareTaskInfo*)taskInfo{
    taskInfo.isReport = @"n";
    if([taskInfo.isShareSiXin isEqualToString:@"y"]){
        NSMutableString* privateMessageIds = [NSMutableString string];
        __block LLDaoModelDiary* diary = nil;
        [[LLDAOBase shardLLDAOBase]searchAll:[[LLDaoModelDiary alloc]init] dic:[NSDictionary dictionaryWithObjectsAndKeys:taskInfo.diaryuuid,@"diaryuuid", nil] callback:^(NSArray* result){
            if(result.count > 0){
                diary = [result lastObject];
            }
        }];
        if(diary){
            for(NSString* userid in [taskInfo.targetUserIds componentsSeparatedByString:@","]){
                LLDaoModelContacts* contacts = [ContactsModel getUserInfoInAttentionList:userid];
                if(contacts == nil){
                    continue;
                }
                MessageUserListModelBase* base = [[MessageUserListModelBase alloc]init];
                base.userid = contacts.userid;
                base.nickname = contacts.nickname;
                base.headimageurl = contacts.headimageurl;
                base.isattention = @"1";
                base.sex = contacts.sex;
                base.signature = contacts.signature;
                
                NSString* messageid = [PrivateMessageModel sendDiaryPrivateMessage:base diary:diary content:@"日记私信"];
                if(privateMessageIds.length > 0){
                    [privateMessageIds appendString:@","];
                }
                [privateMessageIds appendString:messageid];
            }
            taskInfo.privateMessageIds = privateMessageIds;
        }
    }
    int taskId = [[LLFreeTaskManager sharedLLFreeTaskManager]addTask:[LLShareTask class] :[taskInfo outPutJson]];
        
    [[LLDAOBase shardLLDAOBase]updateToDB:[LLDaoModelDiary class] dic:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:taskId],@"sharetaskid", nil] dic:[NSDictionary dictionaryWithObjectsAndKeys:taskInfo.diaryuuid,@"diaryuuid", nil] callback:nil];
}
+(NSString*)getStringFrom:(NSArray*)array nameAppendStr:(NSString*)nameAppend separation:(NSString*)separation{
    NSMutableString* returnStr = [NSMutableString string];
    for(NSString* str in array){
        if(returnStr.length == 0){
            [returnStr appendFormat:@"%@%@",nameAppend,str];
        }else{
            [returnStr appendFormat:@"%@%@%@",separation,nameAppend,str];
        }
    }
    return returnStr;
}
//发布
+(void)publishDiary:(NSString*)diaryuuid :(NSString*)userid{
    LLPublishTaskInfo* taskInfo = [[LLPublishTaskInfo alloc]init];
    taskInfo.diaryuuid = diaryuuid;
    taskInfo.userid = userid;
    taskInfo.publish_type = @"1";
    int taskId = [[LLFreeTaskManager sharedLLFreeTaskManager]addTask:[LLPublishTask class] :[taskInfo outPutJson]];
    [[LLDAOBase shardLLDAOBase]updateToDB:[LLDaoModelDiary class] dic:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:taskId],@"publishtaskid",@"-1",@"diary_status", nil] dic:[NSDictionary dictionaryWithObjectsAndKeys:diaryuuid,@"diaryuuid", nil] callback:nil];
}
//取消发布
+(void)cancelPublishDiary:(NSString*)diaryuuid :(NSString*)userid{
    LLPublishTaskInfo* taskInfo = [[LLPublishTaskInfo alloc]init];
    taskInfo.diaryuuid = diaryuuid;
    taskInfo.userid = userid;
    taskInfo.publish_type = @"2";
    static LLDaoModelDiary* diary;
    [[LLDAOBase shardLLDAOBase]searchWhereDic:[[LLDaoModelDiary alloc]init] Dic:[NSDictionary dictionaryWithObjectsAndKeys:diaryuuid,@"diaryuuid", nil] callback:^(NSArray* result){
        if([result count]>0){
            diary = [result objectAtIndex:0];
        }
    }];
    if(diary.sharetaskid > IS_HAVE_TASK_CONDITION){
        [[LLFreeTaskManager sharedLLFreeTaskManager]setTaskNeedDelete:diary.sharetaskid];
        [[LLDAOBase shardLLDAOBase]updateToDB:[LLDaoModelDiary class] dic:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-1],@"sharetaskid", nil] dic:[NSDictionary dictionaryWithObjectsAndKeys:taskInfo.diaryuuid,@"diaryuuid", nil] callback:nil];
    }
    if(diary.publishtaskid > IS_HAVE_TASK_CONDITION){
        [[LLFreeTaskManager sharedLLFreeTaskManager]setTaskNeedDelete:diary.publishtaskid];
        [[LLDAOBase shardLLDAOBase]updateToDB:[LLDaoModelDiary class] dic:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-1],@"publishtaskid",@"-2",@"diary_status", nil] dic:[NSDictionary dictionaryWithObjectsAndKeys:diaryuuid,@"diaryuuid", nil] callback:nil];
    }
    //如果还未发布，则直接移除任务队列中的发布任务，与分享任务
    //    [[LLTaskManager sharedLLTaskManager]deleteTask:0];
    //    [[LLTaskManager sharedLLTaskManager]deleteTask:1];
    //如果已经发布 需要将取消发布加入取消队列
    if([diary.diary_status isEqualToString:@"2"]){
        [[LLFreeTaskManager sharedLLFreeTaskManager]addTask:[LLPublishTask class] :[taskInfo outPutJson]];
    }
}
+(void)getDiaryShareUrlData:(NSString*)diaryid return:(void(^)(DiaryShareUrlData* data))block{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setValue:diaryid forKey:@"diaryid"];
    RequestModel *requestModel = [[RequestModel alloc] initWithUrl:REQUEST_GETDIARYURL_URL params:paramDic];
    [[RIAWebRequestLib riaWebRequestLib] fetchDataFromNet:requestModel
                                           dataModelClass:[DiaryShareUrlData class]
                                                mainBlock:^(BaseData *resultData)
     {
         if(resultData.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS){
             DiaryShareUrlData* data = (DiaryShareUrlData*)resultData;
             if(block != nil){
                 block(data);
             }
         }else{
             if(block != nil){
                 block(nil);
             }
         }
     }
     ];
}
@end
