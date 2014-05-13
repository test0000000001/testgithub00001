//
//  LLPublishTask.m
//  VideoShare
//
//  Created by tangyx on 13-6-20.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLPublishTask.h"
#import "NSObject+ABJsonConverter.h"
#import "LLPublish.h"
#import "JSONKit.h"
#import "LLDaoModelDiary.h"
#import "LLDaoBase.h"
#import "LLFreeTaskManager.h"
@implementation LLPublishTaskInfo
@synthesize diaryuuid,userid,publish_type;

+(id)customClassWithProperties:(id)properties
{
    LLPublishTaskInfo* returnObject = [super customClassWithProperties:properties];
    return returnObject;
}

@end

@interface LLPublishTask() //<LLPublishDelegate>
@property(nonatomic,strong)LLPublishTaskInfo* publishTaskInfo;
@property(nonatomic,strong)LLPublish* publish;

@end

@implementation LLPublishTask
-(id)init{
    self = [super init];
    if(self){
        self.publish = [[LLPublish alloc]init];
//        self.publish.delegate = self;
    }
    return self;
}
-(void)taskNeedDelete{
    [_delegate taskFinished:_taskID :NO];
}
//LLTaskBase
-(void)startTask
{
    self.publishTaskInfo = [LLPublishTaskInfo customClassWithProperties:[_taskInfo objectFromJSONString]];

    __block LLDaoModelDiary* diary = nil;
    [[LLDAOBase shardLLDAOBase]searchWhereDic:[[LLDaoModelDiary alloc]init] Dic:[NSDictionary dictionaryWithObjectsAndKeys:self.publishTaskInfo.diaryuuid,@"diaryuuid", nil] callback:^(NSArray* result){
        if([result count]>0){
            diary = [result objectAtIndex:0];
        }
    }];
    
    NSString* diaryID = diary.diaryid;
    NSString *diaryType = diary.publish_status;
    NSString *positionType = diary.position_status;
    NSString *audioType = nil;
    for(LLDaoModelDiaryAttachsCell *daoModelDiaryAttachcell in diary.attachs){
        audioType = daoModelDiaryAttachcell.is_encrypt ;
        if(audioType.length > 0){
            break;
        }
    }
    audioType = audioType.length>0?audioType:@"1";
    
    if([self.publishTaskInfo.publish_type isEqualToString:@"1"]){//发布
//        if(diary == nil||[diary.diary_status isEqualToString:@"2"] || diary.publishtaskid == -1){//日记被删除 结束任务 或者已发布
        if(diary == nil||[diary.diary_status isEqualToString:@"2"] || diary.publishtaskid <= IS_HAVE_TASK_CONDITION){//日记被删除 结束任务 或者已发布
            [_delegate taskFinished:_taskID :YES];
        }else if([diary.upload_status isEqualToString:@"-2"]){//未上传
            [_delegate taskPaused:_taskID];
        }else if([diary.upload_status isEqualToString:@"-3"]){//已上传 且已同步 则发布
            [self.publish publishDiary:diaryID userid:self.publishTaskInfo.userid publishType:self.publishTaskInfo.publish_type diaryType:diaryType positionType:positionType audioType:audioType block:^(RIA_RESPONSE_CODE code){
                if(code == RIA_RESPONSE_CODE_SUCCESS){
                    [self publishFinished:NO];
                }else{
                    [self publishFinished:YES];
                }
            }];
        }else{//其他可能为考虑到的状态，避免任务被阻塞
            [_delegate taskPaused:_taskID];
        }
    }else{//取消发布
        if(diary == nil||![diary.diary_status isEqualToString:@"2"]){//日记被删除  日记未发布
            [_delegate taskFinished:_taskID :YES];
        }else if([diary.diary_status isEqualToString:@"2"]){//已发布则取消
            [self.publish cancelPublishDiary:diaryID userid:self.publishTaskInfo.userid publishType:self.publishTaskInfo.publish_type diaryType:diaryType positionType:positionType audioType:audioType block:^(RIA_RESPONSE_CODE code){
                if(code == RIA_RESPONSE_CODE_SUCCESS){
                    [self cancelPublishFinished:NO];
                }else{
                    [self cancelPublishFinished:YES];
                }
            }];
        }else{//其他可能为考虑到的状态，避免任务被阻塞
            [_delegate taskPaused:_taskID];
        }
    }
    
}
-(void)publishFinished:(BOOL)error{
    if(error){
        [_delegate taskPaused:_taskID];
    }else{//发布成功 修改日记的发布状态为@“2”
        [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"发布成功"];
        [[LLDAOBase shardLLDAOBase]updateToDB:[LLDaoModelDiary class] dic:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"diary_status",@"-1",@"publishtaskid",@"1",@"is_publish_status", nil] dic:[NSDictionary dictionaryWithObjectsAndKeys:self.publishTaskInfo.diaryuuid,@"diaryuuid", nil] callback:nil];
        [_delegate taskFinished:_taskID :NO];
        [[LLFreeTaskManager sharedLLFreeTaskManager]stopTask];
        [[LLFreeTaskManager sharedLLFreeTaskManager]reSetAllTaskAlive];
        [[LLFreeTaskManager sharedLLFreeTaskManager]reSetTasksFromDataBase];
        [[LLFreeTaskManager sharedLLFreeTaskManager]startTask];
        //to-do
    }
    
}

-(void)cancelPublishFinished:(BOOL)error{
    if(error){
        [_delegate taskPaused:_taskID];
    }else{//取消发布成功，修改日记的发布状态到@“-2”
        [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"取消发布成功"];
        [_delegate taskFinished:_taskID :NO];
        [[LLDAOBase shardLLDAOBase]updateToDB:[LLDaoModelDiary class] dic:[NSDictionary dictionaryWithObjectsAndKeys:@"-2",@"diary_status",@"-1",@"publishtaskid", nil] dic:[NSDictionary dictionaryWithObjectsAndKeys:self.publishTaskInfo.diaryuuid,@"diaryuuid", nil] callback:nil];
    }
}
@end
