//
//  LLDeleteDiaryTask.m
//  VideoShare
//
//  Created by zc on 13-7-30.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLDeleteDiaryTask.h"
#import "JSONKit.h"
#import "NSObject+ABJsonConverter.h"
#import "LLTaskManager.h"
#import "LLDaoBase.h"
#import "LLDaoModelDiary.h"


@implementation LLDeleteDiaryTaskInfo
-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}


+(id)customClassWithProperties:(id)properties
{
    LLDeleteDiaryTaskInfo* returnObject = [super customClassWithProperties:properties];
    return returnObject;
}

@end

@interface LLDeleteDiaryTask ()
@property(nonatomic,strong)LLDeleteDiaryTaskInfo* lLDeleteDiaryTaskInfo;
@end


@implementation LLDeleteDiaryTask
-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}
//LLTaskBase
-(void)startTask
{
    self.lLDeleteDiaryTaskInfo = [LLDeleteDiaryTaskInfo customClassWithProperties:[_taskInfo objectFromJSONString]];
    
    if (_lLDeleteDiaryTaskInfo && !STR_IS_NIL(_lLDeleteDiaryTaskInfo.diaryids)) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    APP_USERID, @"userid",
                                    _lLDeleteDiaryTaskInfo.diaryids, @"diaryids",_lLDeleteDiaryTaskInfo.newmainDiaryuuids,@"changetomaindiaryuuids",nil];
        RequestModel *requestModel = [[RequestModel alloc] initWithUrl:DELETE_DIARY params:dic];
        [[RIAWebRequestLib riaWebRequestLib] fetchDataFromNet:requestModel dataModelClass:[BaseData class] mainBlock:^(BaseData *responseModel)
         {
             if (responseModel.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS) {
                 NSArray* array = [_lLDeleteDiaryTaskInfo.diaryids componentsSeparatedByString:@","];
                 for (NSString* diaryId in array) {
                     LLDaoModelDiary* diary = [LLDaoModelDiary diaryFromId:diaryId];
                     if (diary && [diary.is_delete isEqualToString:@"1"]) {
                         [LLDaoModelDiary deleteLocalDiary:diary.diaryuuid block:nil];
                     }
                 }
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
        [_delegate taskFinished:_taskID :YES];
    }
}

-(void)taskNeedDelete{
   
}
@end
