
//
//  LLUploadTask.m
//  VideoShare
//
//  Created by zengchao on 13-6-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLUploadTask.h"
#import "JSONKit.h"
#import "NSObject+ABJsonConverter.h"
#import "LLTaskManager.h"
#import "Tools.h"
#import "RIAWebRequestLib.h"
#import "Global.h"
#import "CreateStructureResponseData.h"
#import "DiaryDetailsModel.h"
#import "LocalResourceModel.h"
#import "LLDaoBase.h"
#import "LLFreeTaskManager.h"
#import "ImageCacheManager.h"
#import "GetNetworkInfoModel.h"
#import "ToolsUnite.h"
#import "Recognizer.h"

@implementation LLUploadTaskInfo
-(id)init
{
    if (self = [super init]) {
        self.fileinterval = 30;
    }
    return self;
}

+(id)customClassWithProperties:(id)properties
{
    LLUploadTaskInfo* returnObject = [super customClassWithProperties:properties];
    returnObject.createStructureRequestData = [CreateStructureRequestData customClassWithProperties:returnObject.createStructureRequestData];
    returnObject.createStructureResponseData = [CreateStructureResponseData customClassWithProperties:returnObject.createStructureResponseData];
    return returnObject;
}

-(void)checkTotalSize
{
    LLDaoModelDiary* lLDaoModelDiary = [LLDaoModelDiary diaryFromUuid:_createStructureRequestData.diaryuuid];
    self.totalSize = [lLDaoModelDiary localSize];
}


-(float)percent
{
    //[self checkTotalSize];
    long long finishedSize = [_uploadidSize longLongValue];
    long long totalSize = [_totalSize longLongValue];
    return totalSize == 0 ? 0 :finishedSize/(float)totalSize;
}


-(NSString*)sizeInTotal
{
    //[self checkTotalSize];
    float finishedSize = [_uploadidSize longLongValue]/(float)1024 /1024;
    float totalSize = [_totalSize longLongValue]/(float)1024/1024;
    return [NSString stringWithFormat:@"%.1fM/%.1fM",finishedSize,totalSize];
}

-(BOOL)isPublish
{
    LLDaoModelDiary* diary = [LLDaoModelDiary diaryFromUuid:_createStructureRequestData.diaryuuid];
    if (diary) {
        if (diary.publishtaskid > IS_HAVE_TASK_CONDITION) {
            return YES;
        }
    }
    return NO;
}

-(CreateStructureRequestAttachData *)currentRequestAttachData
{
    CreateStructureRequestAttachData *result = nil;
    if(_createStructureResponseData.attachs && [_createStructureResponseData.attachs count] > _attachNumber){
        CreateStructureResponseAttachData *createStructureResponseAttachData = [_createStructureResponseData.attachs objectAtIndex:_attachNumber];
        
            for (CreateStructureRequestAttachData *createStructureRequstAttachData in _createStructureRequestData.attachs) {
                if ([createStructureRequstAttachData.attachuuid isEqualToString:createStructureResponseAttachData.attachuuid]) {
                    result = createStructureRequstAttachData;
                    break;
                }
            }
        
    }
    return result;
}

@end

typedef NS_ENUM(int, LLUploadTaskStatus){
    LLUploadTaskStatusSleep,
    LLUploadTaskStatusAlive
};

@interface LLUploadTask()
@property(nonatomic,strong)LLUpload* lLUpload;
@property(nonatomic,strong)LLUploadTaskInfo* lLUploadTaskInfo;
@property(nonatomic,assign)LLUploadTaskStatus status;
@property(strong,nonatomic)NSTimer *timer;
@property(assign,nonatomic)BOOL inforChanged;
@property(nonatomic,assign) int waitTime;
@end

@implementation LLUploadTask

-(void)dealloc
{
    NSLog(@"LLUploadTask dealloc");
}

-(id)init
{
    if (self = [super init]) {
        self.status = LLUploadTaskStatusSleep;
    }
    return self;
}

#pragma mark LLUploadDelegate
-(void)infoChanged:(ResponseData*)responseData:(int)partialLength
{
    if ([_lLUploadTaskInfo.createStructureRequestData.attachs count] > _lLUploadTaskInfo.attachNumber) {
        CreateStructureRequestAttachData* cell = [_lLUploadTaskInfo.createStructureRequestData.attachs objectAtIndex:_lLUploadTaskInfo.attachNumber];
        if ([responseData.dataover isEqualToString:@"2"]) {
            cell.nuid = [NSString stringWithFormat:@"%d",[responseData.nuid integerValue] + 1 ];
        }
        _lLUploadTaskInfo.uploadidSize = [NSString stringWithFormat:@"%lld",[_lLUploadTaskInfo.uploadidSize longLongValue] + partialLength];
        self.inforChanged = YES;
    }
}

-(void)inforChecker
{
    if (_inforChanged == YES) {
        self.inforChanged = NO;
        NSString* taskInfo = [_lLUploadTaskInfo outPutJson];
        if (!STR_IS_NIL(taskInfo)) {
            [[LLTaskManager sharedLLTaskManager] setTaskInfo:_taskID :taskInfo:@""];
        }
    }
}

-(void)socketClosed:(NSString*)serverFilePath :(BOOL)error
{
    if (error) {
        [self finishUpload];
        [_delegate taskPaused:_taskID];
    }
    else
    {
        //多个附件，依次上传，全部完成才算日记传完成
        _lLUploadTaskInfo.attachNumber ++ ;
        
        if ([_lLUploadTaskInfo.createStructureResponseData.attachs count] > _lLUploadTaskInfo.attachNumber)
        {
            [self startUpload];
        }
        else
        {
            [self finishUpload];            
            // 从网络上请求新的数据结构
            // 执行更新动作
            [self changeDiaryDataBaseUploadStatus];
            [LLDaoModelDiary setUploadStatus:_lLUploadTaskInfo.createStructureRequestData.diaryuuid :@"-3"];
            [_delegate taskFinished:_taskID:NO];

//            [self getDiaryInfoContent:_lLUploadTaskInfo.createStructureResponseData.diaryid];
            
            LLDaoModelDiary* diary = [LLDaoModelDiary diaryFromUuid:_lLUploadTaskInfo.createStructureRequestData.diaryuuid];
            if (diary) {
                if (diary.publishtaskid > IS_HAVE_TASK_CONDITION) {
                    [[LLFreeTaskManager sharedLLFreeTaskManager] setTaskContinue:diary.publishtaskid];
                }
                if (diary.sharetaskid > IS_HAVE_TASK_CONDITION) {
                    [[LLFreeTaskManager sharedLLFreeTaskManager] setTaskContinue:diary.sharetaskid];
                }
                
            }
        }
    }
}

/**
 * 功能：从网络上获取日记的最新数据结构
 * 参数：(NSString *)diaryid
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-07-23
 */
- (void) getDiaryInfoContent:(NSString *)diaryid
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:APP_USERID forKey:@"userid"];
    [paramDic setObject:diaryid forKey:@"diaryid"];
    
    RequestModel *requestModel = [[RequestModel alloc] initWithUrl:GET_DIARY_DETAIL params:paramDic];
    
    [[RIAWebRequestLib riaWebRequestLib] fetchDataFromNet:requestModel
                                           dataModelClass:[DiaryDetailsInfoData class]
                                                mainBlock:^(BaseData *responseData)
     {
         if (responseData.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS)
         {
             DiaryDetailsInfoData *diaryDetailsInfoData = (DiaryDetailsInfoData *)responseData;
             DiaryData *diatyData = diaryDetailsInfoData.diaries;
             if (diatyData)
             {
                 // 更新数据结构到本地
                 [Tools isDiaryDataUpdate:[NSMutableArray arrayWithObjects:diaryDetailsInfoData.diaries,nil]];
                 // 执行更新动作
                 [self changeDiaryDataBaseUploadStatus];
                 [LLDaoModelDiary setUploadStatus:_lLUploadTaskInfo.createStructureRequestData.diaryuuid :@"-3"];
                 [_delegate taskFinished:_taskID:NO];
             }
         }
     }];
}

-(void)changeDiaryDataBaseUploadStatus
{
    NSString *diaryuuid = self.lLUploadTaskInfo.createStructureRequestData.diaryuuid;
    __block LLDaoModelDiary *llDaoModelDiary = nil;
    [DiaryDetailsModel getLocalDiary:diaryuuid
                               block:^(NSArray *resultArray)
     {
         if (resultArray.count > 0)
         {
             llDaoModelDiary = [resultArray objectAtIndex:0];
         }
     }
     ];
    if (llDaoModelDiary)
    {
        llDaoModelDiary.uploadTask_taskID = -1;
        llDaoModelDiary.upload_status = @"-3";
        NSMutableDictionary *columnDic = [NSMutableDictionary dictionary];
        [columnDic setObject:@"-3" forKey:@"upload_status"];
        [columnDic setObject:@"-1" forKey:@"uploadTask_taskID"];
        
        
        NSMutableDictionary *whereDic = [NSMutableDictionary dictionary];
        [whereDic setObject:diaryuuid forKey:@"diaryuuid"];
        [[LLDAOBase shardLLDAOBase] updateToDB:[LLDaoModelDiary class]
                                           dic:columnDic
                                           dic:whereDic
                                      callback:^(BOOL result)
         {
         }];
//        [[LLDAOBase shardLLDAOBase] updateInsertToDB:llDaoModelDiary callback:^(BOOL result){}];
    }
}


//根据最新的文字描述生成一个文字附件
-(LLDaoModelDiaryAttachsCell*)createAttachText:(NSString*)textDesc attachLevel:(NSString*)attachLevel forModelDiary:(LLDaoModelDiary *)needUpdateDiary{
    
    LLDaoModelDiaryAttachsCell* attachsCell = [[LLDaoModelDiaryAttachsCell alloc]init];
    [attachsCell createDefault];
    
    NSString* attachUuid = [Tools identifierStringIncreaseNumberSuffix:[needUpdateDiary lastAttachUUid]];
    attachsCell.attachuuid = attachUuid;
    attachsCell.attachtype = @"4";//附件类型，1视频、2音频、3图片、4文字
    
    attachsCell.attachlevel = attachLevel;
    attachsCell.attach_latitude = APP_GPS_LATITUDE;
    attachsCell.attach_logitude = APP_GPS_LATITUDE;
    
    attachsCell.Operate_type = @"1";
    attachsCell.content = textDesc;
    
    return attachsCell;
}

-(NSString *) getShortAudioPath:(LLDaoModelDiary *)modelDiary
{
    NSString *audioLocalPath = nil;
    NSMutableArray *attachsArray = modelDiary.attachs;
    for (int i = 0; i < attachsArray.count; i++)
    {
        LLDaoModelDiaryAttachsCell *attachsCell = [attachsArray objectAtIndex:i];
        if ([attachsCell.attachlevel isEqualToString:@"0"] && [attachsCell.attachtype isEqualToString:@"2"])
        {
            audioLocalPath = attachsCell.localfilePath;
        }
    }
    return audioLocalPath;
}

/**
 * 功能：无网翻译逻辑
 * 参数：无
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-08-12
 */
- (void) getTranslateResult
{
    LLDaoModelDiary *modelDiary = [LLDaoModelDiary diaryFromUuid:self.lLUploadTaskInfo.createStructureRequestData.diaryuuid];
    NSString *audioPath = [self getShortAudioPath:modelDiary];
    if (!STR_IS_NIL(audioPath))
    {
        [[Recognizer defaultRecognizer] recognizeMP4File:audioPath
                                        WithSuccessBlock:^(NSString *recognizedStr)
         {
             if (!STR_IS_NIL(recognizedStr))
             {
                 // 这个要先于更新本地因为可能导致附件uuid 不同
                 [self updateRequestAttachs:recognizedStr modelDiary:modelDiary];
                 
                 self.lLUploadTaskInfo.createStructureRequestData.isShortSoundRecognizedToText = @"1";
                 [[LLTaskManager sharedLLTaskManager] setTaskInfo:_taskID :[self.lLUploadTaskInfo outPutJson] :@"translateResultChange"];
                 
                 // 更新本地日记
                 [self updateLocalDiary:recognizedStr modelDiary:modelDiary isShortTranslate:YES];
                 [self continueOtherTask];
             }
             else
             {
                 // 返回空翻译认为不用继续无网翻译
                 [self exceptionHandle:modelDiary];
             }
         }
                                         withFailedBlock:^(NSString *recognizedStr, NSString *errorDescription)
         {
             // 网络错误
             if ([errorDescription isEqualToString:RECOGNIZE_ERROR_CONNECTION] || [errorDescription isEqualToString:RECOGNIZE_ERROR_APP_SHUTDOWN])
             {
                 [_delegate taskPaused:_taskID];
             }
             else if([errorDescription isEqualToString:RECOGNIZE_ERROR_CANCELED])
             {
                 // 延迟调用
                 [self delayCallself];
             }
             else
             {
                 [self exceptionHandle:modelDiary];
             }
         }];
    }
    else
    {
        [self exceptionHandle:modelDiary];
    }

}

- (void) exceptionHandle:(LLDaoModelDiary *)modelDiary
{
    self.lLUploadTaskInfo.createStructureRequestData.isShortSoundRecognizedToText = @"1";
    [[LLTaskManager sharedLLTaskManager] setTaskInfo:_taskID :[self.lLUploadTaskInfo outPutJson] :@"translateResultChange"];
    [self updateLocalDiary:nil modelDiary:modelDiary isShortTranslate:YES];
    [self continueOtherTask];
}

// 没有返回nil  有就返回
- (CreateStructureRequestAttachData *) getWenziCell
{
    NSMutableArray *requestAttachDataArray = self.lLUploadTaskInfo.createStructureRequestData.attachs;
    CreateStructureRequestAttachData *resultRequestAttachData = nil;
    for (int i = 0; i < requestAttachDataArray.count; i++)
    {
        CreateStructureRequestAttachData *requestAttachData = [requestAttachDataArray objectAtIndex:0];
        if ([requestAttachData.attach_type isEqualToString:@"4"])
        {
            resultRequestAttachData = requestAttachData;
        }
    }
    
    return resultRequestAttachData;
}

// 有文字cell就追加文字上去，没有就生成一个cell添加进去
-(void) updateRequestAttachs:(NSString *)translateResult modelDiary:(LLDaoModelDiary *)modelDiary
{
    CreateStructureRequestAttachData *attachsWenziData = [self getWenziCell];
    if (attachsWenziData)
    {
        attachsWenziData.content = [attachsWenziData.content stringByAppendingString:translateResult];
    }
    else
    {
        attachsWenziData = [self createAttachDataText:translateResult attachLevel:@"0" fromModelDiary:modelDiary];
        attachsWenziData.content = translateResult;
        NSMutableArray *attachsArray = self.lLUploadTaskInfo.createStructureRequestData.attachs;
        [attachsArray addObject:attachsWenziData];
    }
    
}
- (CreateStructureRequestAttachData *)createAttachDataText:(NSString *)translateResult attachLevel:(NSString *)level fromModelDiary:(LLDaoModelDiary *)modelDiary
{
    NSString* attachUuid = [Tools identifierStringIncreaseNumberSuffix:[modelDiary lastAttachUUid]];
    CreateStructureRequestAttachData* createStructureRequestAttachData = [[CreateStructureRequestAttachData alloc] init];
    createStructureRequestAttachData.attachuuid = attachUuid;
    createStructureRequestAttachData.content = translateResult;
    createStructureRequestAttachData.attach_type = @"4";
    createStructureRequestAttachData.audio_type = @"1";
    createStructureRequestAttachData.level = @"0";
    createStructureRequestAttachData.attach_logitude = APP_GPS_LATITUDE;
    createStructureRequestAttachData.attach_latitude = APP_GPS_LATITUDE;
    createStructureRequestAttachData.suffix = @"";
    createStructureRequestAttachData.Operate_type = @"1";
    createStructureRequestAttachData.createType = @"1";
    createStructureRequestAttachData.video_type = @"";
    createStructureRequestAttachData.photo_type = @"";
    return createStructureRequestAttachData;
}

// 没有返回nil  有就返回
- (LLDaoModelDiaryAttachsCell *) getLocalWenziCellFromLocal:(LLDaoModelDiary *)modelDiary
{
    LLDaoModelDiaryAttachsCell *attachsCellResult = nil;
    NSMutableArray *attachsArray = modelDiary.attachs;
    for (int i = 0; i < attachsArray.count; i++)
    {
        LLDaoModelDiaryAttachsCell *attachsCell = [attachsArray objectAtIndex:i];
        if ([attachsCell.attachtype isEqualToString:@"4"])
        {
            attachsCellResult = attachsCell;
            break;
        }
    }
    return attachsCellResult;
}

// 更新本地日记结构
- (void) updateLocalDiary:(NSString *)translateResult modelDiary:(LLDaoModelDiary *)modelDiary isShortTranslate:(BOOL)isShortTranslate
{
    if (!STR_IS_NIL(translateResult) && translateResult.length > 0)
    {
        LLDaoModelDiaryAttachsCell *attachsWenziCell = [self getLocalWenziCellFromLocal:modelDiary];
        if (attachsWenziCell)
        {
            attachsWenziCell.content = [attachsWenziCell.content stringByAppendingString:translateResult];
        }
        else
        {
            attachsWenziCell = [self createAttachText:translateResult attachLevel:@"0" forModelDiary:modelDiary];
            attachsWenziCell.content = translateResult;
            NSMutableArray *attachsArray = modelDiary.attachs;
            [attachsArray addObject:attachsWenziCell];
        }
    }
    modelDiary.isShortSoundRecognizedToText = (isShortTranslate ? @"1" : @"0");
    
    [[LLDAOBase shardLLDAOBase] updateInsertToDB:modelDiary callback:^(BOOL result){}];
}

-(void) continueOtherTask
{
    //[_lLUploadTaskInfo checkFinishedSize];
    NSString* taskInfo = [_lLUploadTaskInfo outPutJson];
    if (!STR_IS_NIL(taskInfo)) {
        [[LLTaskManager sharedLLTaskManager] setTaskInfo:_taskID :taskInfo:@""];
    }
    
    //    // 入口处增加不同网络下任务是否启动的判断
    //    if (![self isNeedStartUpload]) {
    //        [_delegate taskPaused:self.taskID];
    //        return;
    //    }
    
    //如果没有请求过日记接口，则先请求
    if (_lLUploadTaskInfo.createStructureResponseData == nil || STR_IS_NIL(_lLUploadTaskInfo.createStructureResponseData.diaryid) ) {
        [self startCreateStructure];
    }
    else
    {
        [self startUpload];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(inforChecker)
                                                    userInfo:nil
                                                     repeats:YES];
    });
}

//LLTaskBase
-(void)startTask
{
    self.status = LLUploadTaskStatusAlive;
    
    self.lLUploadTaskInfo = [LLUploadTaskInfo customClassWithProperties:[_taskInfo mutableObjectFromJSONString]];
    
    if (![self.lLUploadTaskInfo.createStructureRequestData.isShortSoundRecognizedToText isEqualToString:@"1"])
    {
        BOOL isRecognizer = [[Recognizer defaultRecognizer] isRecognizerIdel];
        if (isRecognizer)
        {
            // 执行翻译动作
            [self getTranslateResult];
        }
        else
        {
            [self delayCallself];
        }
    }
    else
    {
        [self continueOtherTask];
    }
    
}

-(void) delayCallself
{
    self.waitTime += RECONIZE_GAP;
    if (self.waitTime <= RECONIZE_WAIT_TOTALTIME)
    {
        [self performSelector:@selector(startTask) withObject:nil afterDelay:RECONIZE_GAP];
    }
    else
    {
        LLDaoModelDiary *modelDiary = [LLDaoModelDiary diaryFromUuid:self.lLUploadTaskInfo.createStructureRequestData.diaryuuid];
        [self exceptionHandle:modelDiary];
    }
}


//- (BOOL)isNeedStartUpload {
//    
//    if ([APP_SYSC_TYPE isEqualToString:@"2"]) {//2仅WIFI
//        if ([GetNetworkInfoModel getNetworkType] == NETWORK_WIFI) {
//            return TRUE;
//        }
//        else {
//            return FALSE;
//        }
//    }
//    else { //3任何网络
//        if([GetNetworkInfoModel getNetworkType] != NETWORK_NOT_AVAILABLE) {
//            return TRUE;
//            
//        }
//        else {
//            return FALSE;
//        }
//    }
//}

-(void)startUpload
{
    CreateStructureRequestAttachData* createStructureRequstAttachData= [_lLUploadTaskInfo currentRequestAttachData];
    if (createStructureRequstAttachData && ![createStructureRequstAttachData.attach_type isEqualToString:@"4"])
    {
        if (_lLUploadTaskInfo.createStructureResponseData != nil && !STR_IS_NIL(_lLUploadTaskInfo.createStructureResponseData.diaryid) && _lLUpload == nil) {
            self.lLUpload = [[LLUpload alloc]initWithDelegate:self];
        }
        if (_lLUpload) {
            [_lLUpload initSocket:_lLUploadTaskInfo];
//#if !(TARGET_IPHONE_SIMULATOR)
//            if ([createStructureRequstAttachData.attach_type isEqualToString:@"3"]) {//图片，转角度
//                LLDaoModelDiary* diary = [LLDaoModelDiary diaryFromUuid:_lLUploadTaskInfo.createStructureRequestData.diaryuuid];
//                if (diary) {
//                    // 翻转角度
//                    [ToolsUnite ChangeImageDirectionWithPath:[diary localPath]];
//                }
//            }
//#endif
            [_lLUpload startUpload];
        }
    }
    else
    {
        [self socketClosed:nil :NO];
    }
    
}

-(void)startCreateStructure
{
    __weak LLUploadTask* weakSelf = self;
    
    NSMutableDictionary *dic = [NSDictionary dictionaryWithDictionary:[_lLUploadTaskInfo.createStructureRequestData outPutDic]];
    RequestModel *requestModel = [[RequestModel alloc] initWithUrl:STRUCTRURE_MANAGER_URL params:dic];
    [[RIAWebRequestLib riaWebRequestLib] fetchDataFromNet:requestModel
                                           dataModelClass:[CreateStructureResponseData class]
                                                mainBlock:^(BaseData *resultData)
     {
         
         @synchronized(weakSelf)
         {
             if (resultData.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS)
             {
                 weakSelf.lLUploadTaskInfo.createStructureResponseData = (CreateStructureResponseData *)resultData;
                 
                 LLDaoModelDiary* diary = [LLDaoModelDiary diaryFromUuid:weakSelf.lLUploadTaskInfo.createStructureResponseData.diaryuuid];
                 if (diary) {
                     diary.diaryid = weakSelf.lLUploadTaskInfo.createStructureResponseData.diaryid;
                     diary.updatetimemilli = weakSelf.lLUploadTaskInfo.createStructureResponseData.diaryupdatetime;
                     for (LLDaoModelDiaryAttachsCell* cell in diary.attachs) {
                         for (CreateStructureResponseAttachData* responseCell in weakSelf.lLUploadTaskInfo.createStructureResponseData.attachs) {
                             if (!OBJ_IS_NIL(responseCell) && !OBJ_IS_NIL(cell) && [responseCell.attachuuid isEqualToString:cell.attachuuid]) {
                                 cell.attachid = responseCell.attachid;
                             }
                         }
                     }
                     [[LLDAOBase shardLLDAOBase] updateInsertToDB:diary callback:nil];
 //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"diaryListChanged" object:self];
                     
                     [diary uploadVideoCover];
                 }
                 
                 
                 NSString* taskInfo = [weakSelf.lLUploadTaskInfo outPutJson];
                 if (!STR_IS_NIL(taskInfo)) {
                     [[LLTaskManager sharedLLTaskManager] setTaskInfo:weakSelf.taskID :taskInfo:@""];
                 }
                 
                 [weakSelf startUpload];;
             }
             else
             {
                 [weakSelf socketClosed:@"":YES];
             }
         }
     }];
}


//LLTaskBase
-(void)taskNeedDelete
{
    [_lLUpload closeSocket];
    [self socketClosed:@"" :YES];
}

//外部调用
-(void)cancelShare
{
    //to do cancel share
    NSString* taskInfo = [_lLUploadTaskInfo outPutJson];
    if (!STR_IS_NIL(taskInfo)) {
        [[LLTaskManager sharedLLTaskManager] setTaskInfo:_taskID :taskInfo:@""];
    }
}

//LLTaskBase 管理器调用此函数,From [LLTaskManager setTaskInfo::]
-(void)taskInfoChanged:(NSString*)taskInfo:(NSString*)changeReason
{
    @synchronized(self)
    {
        [super taskInfoChanged:taskInfo :changeReason];
        
        self.lLUploadTaskInfo = [LLUploadTaskInfo customClassWithProperties:[_taskInfo mutableObjectFromJSONString]];
        
        if (_lLUpload && ([changeReason isEqualToString:@"SmallFileFinish"] || [changeReason isEqualToString:@"BigFileFinsh"])) {
            [_lLUpload reSetFiles];
        }
//        if ([changeReason isEqualToString:@"BigFileFinsh"])
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"diaryListChanged" object:self];
//        }
    }
}


-(void)finishUpload
{
    if ([_timer isValid] || _timer != nil) {
        [_timer invalidate];
        self.timer = nil;
    }
    if (_lLUpload) {
        self.lLUpload = nil;
    }
}
@end
