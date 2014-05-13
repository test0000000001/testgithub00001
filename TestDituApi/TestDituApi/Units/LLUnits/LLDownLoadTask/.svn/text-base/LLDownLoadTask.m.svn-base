//
//  LLUploadTask.m
//  VideoShare
//
//  Created by zengchao on 13-6-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDownLoadTask.h"
#import "JSONKit.h"
#import "NSObject+ABJsonConverter.h"
#import "LLTaskManager.h"
#import "Tools.h"
#import "RIAWebRequestLib.h"
#import "Global.h"
#import "CreateStructureResponseData.h"
#import "DiaryDetailsModel.h"
#import "LocalResourceModel.h"

@implementation LLDownLoadTaskInfo
@synthesize imageForShow;
@synthesize mainAttachType;      // 主附件type

-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

+(id)customClassWithProperties:(id)properties
{
    LLDownLoadTaskInfo* returnObject = [super customClassWithProperties:properties];
    returnObject.modelDiary = [LLDaoModelDiary customClassWithProperties:returnObject.modelDiary];
    return returnObject;
}

-(NSString*)mainAttachType
{
    NSString* result = @"video";
    return result;
}


-(float)percent
{
    long long finishedSize = [_downloadidSize longLongValue];
    long long totalSize = [_totalSize longLongValue];
    return totalSize == 0 ? 0 :finishedSize/(float)totalSize;
}


-(NSString*)sizeInTotal
{
    float finishedSize = [_downloadidSize longLongValue]/(float)1024 /1024;
    float totalSize = [_totalSize longLongValue]/(float)1024/1024;
    if(totalSize == 0){
        return [NSString stringWithFormat:@"%.1fM/--",finishedSize];
    }
    return [NSString stringWithFormat:@"%.1fM/%.1fM",finishedSize,totalSize];
}

@end

@interface LLDownLoadTask()
@property (nonatomic, strong) LLDownload* lLDownload;
@property (nonatomic, strong) LLDownLoadTaskInfo* lLDownloadTaskInfo;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL inforChanged;
@property (nonatomic, strong) NSString *currentDownloadLocFilePath;           // 当前的下载路径
@property (nonatomic, strong) NSString *currentLocFilePath;                   // 当前需要赋值的本地原路径
@property (nonatomic)         double    currentDownloadSize;                  // 当前下载的附件的size

/***
 * 功能：更新附件下载路径到数据库
 * 参数：无
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-07-18
 */
- (void) updateDiaryAttach;

@end

@implementation LLDownLoadTask

-(void)dealloc
{
    NSLog(@"LLUploadTask dealloc");
}

-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

#pragma mark LLDownloadDelegate
-(void)infoChanged:(long long)partialLength  DownloadUrl:(NSString *)downloadurl Name:(NSString *)name LocalfilePath:(NSString *)localfilePath
{
//    _lLDownloadTaskInfo.downloadidSize = [NSString stringWithFormat:@"%lld",[_lLDownloadTaskInfo.downloadidSize longLongValue] + partialLength];
//        self.inforChanged = YES;
}

-(void)inforChecker
{
    if (_inforChanged == YES) {
        self.inforChanged = NO;
        NSString* taskInfo = [_lLDownloadTaskInfo outPutJson];
        if (!STR_IS_NIL(taskInfo)) {
            [[LLTaskManager sharedLLTaskManager] setTaskInfo:_taskID :taskInfo:@""];
        }
    }
}
-(void)downloadFailed:(BOOL)error  DownloadUrl:(NSString*)downloadurl Name:(NSString*)name LocalfilePath:(NSString*)localfilePath
{
    [_delegate taskPaused:_taskID];
}

-(void)downloadClosed:(BOOL)error DownloadUrl:(NSString *)downloadurl Name:(NSString *)name LocalfilePath:(NSString *)localfilePath
{
    if (error) {
        [_delegate taskPaused:_taskID];
    }
    else
    {
        // 更新附件下载路径到数据库
        [self updateDiaryAttach];

        //多个附件，依次上传，全部完成才算日记传完成
        _lLDownloadTaskInfo.attachNumber ++ ;
        if (_lLDownloadTaskInfo.modelDiary.attachs.count > _lLDownloadTaskInfo.attachNumber) {
            [self startDownload];
        }
        else
        {
            [self finishDownload];
            [_delegate taskFinished:_taskID:NO];
        }
    }
}

/***
 * 功能：更新附件下载路径到数据库
 * 参数：无
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-07-18
 */
- (void) updateDiaryAttach
{
    LLDaoModelDiaryAttachsCell* cell = [_lLDownloadTaskInfo.modelDiary.attachs objectAtIndex:_lLDownloadTaskInfo.attachNumber];
    cell.downLoadFilePath = self.currentDownloadLocFilePath;
    
    //modified by xudongsheng
    if([cell.attachlevel isEqualToString:@"1"]){
        if([self.lLDownloadTaskInfo.videoType isEqualToString:@"1"]){
          cell.video_type = @"1";
        }else{
          cell.video_type = @"0";
        }
    }
//    if ([self.lLDownloadTaskInfo.videoType isEqualToString:@"0"] && [cell.attachlevel isEqualToString:@"1"])
//    {
//        cell.video_type = @"0";
//    }
    
    long long fileSize = [Tools calculatefolderSizeAtPath:self.currentDownloadLocFilePath];
    cell.downLoadSize = [NSString stringWithFormat:@"%lld",fileSize];
    // 复制文件到指定文件路径下(如果是自己的日记）
    if ([self.lLDownloadTaskInfo.modelDiary.userid isEqualToString:APP_USERID])
    {
        cell.localSize = [NSString stringWithFormat:@"%lld",fileSize];
        cell.localfilePath = self.currentLocFilePath;
        [Tools copyLocalFileFrom:cell.downLoadFilePath to:cell.localfilePath];
    }
    
    [[LLDAOBase shardLLDAOBase] updateInsertToDB:_lLDownloadTaskInfo.modelDiary callback:^(BOOL result)
     {
        
     }];
}


/***
 * 功能：更新数据库下载id
 * 参数：无
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-07-18
 */
- (void) updateDiaryDownTaskid
{
    if ([self.lLDownloadTaskInfo.modelDiary.userid isEqualToString:APP_USERID])
    {
        [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"下载成功！"];
    }
    else
    {
        [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"收藏并下载成功！"];  
    }
    NSMutableDictionary *columnDic = [NSMutableDictionary dictionary];
    [columnDic setObject:@"-1" forKey:@"downTaskid"];
    
    NSMutableDictionary *whereDic = [NSMutableDictionary dictionary];
    [whereDic setObject:_lLDownloadTaskInfo.modelDiary.diaryid forKey:@"diaryid"];
    
    [[LLDAOBase shardLLDAOBase] updateToDB:[LLDaoModelDiary class]
                                       dic:columnDic
                                       dic:whereDic
                                  callback:^(BOOL result)
     {
     }];

}

//LLTaskBase
-(void)startTask
{
    self.lLDownloadTaskInfo = [LLDownLoadTaskInfo customClassWithProperties:[_taskInfo mutableObjectFromJSONString]];

    NSString* taskInfo = [_lLDownloadTaskInfo outPutJson];
    if (!STR_IS_NIL(taskInfo)) {
        [[LLTaskManager sharedLLTaskManager] setTaskInfo:_taskID :taskInfo:@""];
    }

    [self startDownload];
    dispatch_async(dispatch_get_main_queue(), ^{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(inforChecker)
                                                userInfo:nil
                                                 repeats:YES];
    });
}

-(void)startDownload
{
    if (!_lLDownload) {
        self.lLDownload = [[LLDownload alloc]initWithDelegate:self];
    }
    
    NSString* url = @"";
    NSString* localfilePath = @"";
    NSString* name = @"";
    NSString* attachType = @"";
    BOOL execute = YES;  // 当前是否立即执行
    
    if(_lLDownloadTaskInfo.modelDiary.attachs.count > _lLDownloadTaskInfo.attachNumber)
    {
        LLDaoModelDiaryAttachsCell* cell = [_lLDownloadTaskInfo.modelDiary.attachs objectAtIndex:_lLDownloadTaskInfo.attachNumber];
        // 视频
        if ([cell.attachtype isEqualToString:@"1"])
        {
            attachType = @"1";
            LLDaoModelDiaryAttachsCellVideopathCell *videoCell = nil;
            for (int i = 0; i < cell.attachvideo.count; i++)
            {
                LLDaoModelDiaryAttachsCellVideopathCell *rsDiaryVideoCell = [cell.attachvideo objectAtIndex:i];
                if ([rsDiaryVideoCell.videotype isEqualToString:self.lLDownloadTaskInfo.videoType])
                {
                    videoCell = rsDiaryVideoCell;
                    break;
                }
            }
            self.currentDownloadSize = [videoCell.videosize doubleValue];
            url = videoCell.playvideourl;
            localfilePath = [LocalResourceModel VideosDownloadPath];
            name = cell.attachuuid;
        }
        // 音频
        else if ([cell.attachtype isEqualToString:@"2"])
        {
            // to-do 根据音频类型
            attachType = @"2";
            LLDaoModelDiaryAttachsCellAttachaudioCell *audioCell = nil;
            for (int i = 0; i < cell.attachaudio.count; i++)
            {
                LLDaoModelDiaryAttachsCellAttachaudioCell *audioCellRs = [cell.attachaudio objectAtIndex:i];
                if ([audioCellRs.audiotype isEqualToString:self.lLDownloadTaskInfo.audiotype])
                {
                    audioCell = audioCellRs;
                }
            }
            url = audioCell.audiourl;
            localfilePath = [LocalResourceModel getSoundsDownloadPath];
            name = cell.attachuuid;

        }
        // 图片
        else if ([cell.attachtype isEqualToString:@"3"])
        {
            attachType = @"3";
            LLDaoModelDiaryAttachsCellAttachimageCell *imgCell = nil;
            for (int i = 0; i < cell.attachimage.count; i++)
            {
                LLDaoModelDiaryAttachsCellAttachimageCell *rsImgAttachCell = [cell.attachimage objectAtIndex:i];
                if ([rsImgAttachCell.imagetype isEqualToString:self.lLDownloadTaskInfo.imagetype])
                {
                    imgCell = rsImgAttachCell;
                    break;
                }
            }
            self.currentDownloadSize = [imgCell.imagesize doubleValue];
            url = imgCell.imageurl;
            localfilePath = [LocalResourceModel getImageDownloadPath];
            name = cell.attachuuid;

        }
        else
        {
            execute = NO;
            _lLDownloadTaskInfo.attachNumber += 1;
        }
    }
    else
    {
        if ([self.lLDownloadTaskInfo.modelDiary.userid isEqualToString:APP_USERID])
        {
            [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"下载成功！"];
        }
        else
        {
            [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"收藏并下载成功！"];
        }
        [_delegate taskFinished:self.taskID :YES];
        return;
    }
    
    
    if (execute)
    {
        if (url.length <= 0 || STR_IS_NIL(url))
        {
            execute = NO;
        }
        if (name.length <= 0 || STR_IS_NIL(name))
        {
            execute = NO;
        }
        if (localfilePath.length <= 0 || STR_IS_NIL(localfilePath))
        {
            execute = NO;
        }
        if (execute == NO)
        {
            _lLDownloadTaskInfo.attachNumber += 1;
        }
    }
    
    if (execute)
    {
        self.currentDownloadLocFilePath = [[localfilePath stringByAppendingPathComponent:name] stringByAppendingPathExtension:[url pathExtension]];
        if ([attachType isEqualToString:@"1"])
        {
            NSString *videoShootPath = [LocalResourceModel VideosShootPath];
            [SandboxFile CreateList:videoShootPath ListName:name];
            
            self.currentLocFilePath = [[[videoShootPath stringByAppendingPathComponent:name]stringByAppendingPathComponent:name]
                stringByAppendingPathExtension:[url pathExtension]];
        }
        else if ([attachType isEqualToString:@"2"])
        {
            NSString *audioShootPath = [LocalResourceModel getSoundsRecordPath];
            [SandboxFile CreateList:audioShootPath ListName:name];

            self.currentLocFilePath = [[[audioShootPath stringByAppendingPathComponent:name]stringByAppendingPathComponent:name]
                stringByAppendingPathExtension:[url pathExtension]];
        }
        else if ([attachType isEqualToString:@"3"])
        {
            self.currentLocFilePath = [[[LocalResourceModel getImageShootPath] stringByAppendingPathComponent:name]
                stringByAppendingPathExtension:[url pathExtension]];
        }
        [self.lLDownload download:url :localfilePath :name];
    }
    else
    {
        [self startDownload];
    }

}



//LLTaskBase
-(void)taskNeedDelete
{
    [_lLDownload deleteDownload];
}


//LLTaskBase 管理器调用此函数,From [LLTaskManager setTaskInfo::]
-(void)taskInfoChanged:(NSString*)taskInfo:(NSString*)changeReason
{
    [super taskInfoChanged:taskInfo :changeReason];
    self.lLDownloadTaskInfo = [LLDownLoadTaskInfo customClassWithProperties:[_taskInfo mutableObjectFromJSONString]];
}


-(void)finishDownload
{
    [self updateDiaryDownTaskid];
    if ([_timer isValid] || _timer != nil) {
        [_timer invalidate];
        self.timer = nil;
    }
    if (_lLDownload) {
        self.lLDownload = nil;
    }
}

#pragma mark LLDownloadDelegate
-(void)downloadProgress:(float)percent DownloadUrl:(NSString*)downloadurl Name:(NSString*)name
          LocalfilePath:(NSString*)localfilePath
{
    _lLDownloadTaskInfo.downloadidSize = [NSString stringWithFormat:@"%f", [_lLDownloadTaskInfo.totalSize longLongValue] * percent];
    self.inforChanged = YES;
}

@end
