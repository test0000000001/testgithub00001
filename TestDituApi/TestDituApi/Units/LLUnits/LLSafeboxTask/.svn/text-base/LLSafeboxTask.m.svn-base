//
//  LLSafeboxTask.m
//  VideoShare
//
//  Created by zc on 13-7-30.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLSafeboxTask.h"
#import "JSONKit.h"
#import "NSObject+ABJsonConverter.h"
#import "LLTaskManager.h"
#import "LLDaoBase.h"
#import "LLDaoModelDiary.h"


@implementation LLSafeboxTaskInfo
-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}


+(id)customClassWithProperties:(id)properties
{
    LLSafeboxTaskInfo* returnObject = [super customClassWithProperties:properties];
    return returnObject;
}

@end

@interface LLSafeboxTask ()
@property(nonatomic,strong)LLSafeboxTaskInfo* lLSafeboxTaskInfo;
@end


@implementation LLSafeboxTask
-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}
//LLTaskBase
-(void)startTask
{
    self.lLSafeboxTaskInfo = [LLSafeboxTaskInfo customClassWithProperties:[_taskInfo objectFromJSONString]];
    if (_lLSafeboxTaskInfo && !STR_IS_NIL(_lLSafeboxTaskInfo.diaryid) && !STR_IS_NIL(_lLSafeboxTaskInfo.type)) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    APP_USERID, @"userid",
                                    _lLSafeboxTaskInfo.type, @"type",_lLSafeboxTaskInfo.diaryid,@"diaryid",_lLSafeboxTaskInfo.diaryuuid,@"diaryuuid",nil];
        RequestModel *requestModel = [[RequestModel alloc] initWithUrl:PUTIN_OR_GETOUT_SAFEBOX params:dic];
        [[RIAWebRequestLib riaWebRequestLib] fetchDataFromNet:requestModel dataModelClass:[BaseData class] mainBlock:^(BaseData *responseModel)
         {
             if (responseModel.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS) {
                 
                 LLDaoModelDiary* diary = [LLDaoModelDiary diaryFromId:_lLSafeboxTaskInfo.diaryid];
                 diary.safeboxTaskId = -1;
                 [[LLDAOBase shardLLDAOBase] updateInsertToDB:diary callback:nil];
                 [self alertStr:_lLSafeboxTaskInfo.type];
                 [_delegate taskFinished:_taskID :NO];
             }
             else
             {
                 [_delegate taskPaused:_taskID];
             }
         }];
    }
    else
    {
        LLDaoModelDiary* diary = [LLDaoModelDiary diaryFromId:_lLSafeboxTaskInfo.diaryid];
        diary.safeboxTaskId = -1;
        [[LLDAOBase shardLLDAOBase] updateInsertToDB:diary callback:nil];
        [_delegate taskFinished:_taskID :YES];
    }
}

-(void) alertStr:(NSString *)type
{
    if ([type isEqualToString:@"1"])
    {
        [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"放置保险箱成功!"];
    }
    else if ([type isEqualToString:@"2"])
    {
        [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"移出保险箱成功!"];
    }
}

-(void)taskNeedDelete{
   
}
@end
