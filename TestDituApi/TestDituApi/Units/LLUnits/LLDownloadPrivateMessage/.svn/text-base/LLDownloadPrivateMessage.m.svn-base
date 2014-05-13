//
//  LLDownloadPrivateMessage.m
//  VideoShare
//
//  Created by qin on 13-8-3.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLDownloadPrivateMessage.h"
#import "LocalResourceModel.h"
#import "LLDaoModelBase.h"
#import "LLDaoModelPrivateMessage.h"
#import "Tools.h"
#import "NetUrlStatusAndType.h"

@implementation LLDownloadPrivateMessageInfo
@synthesize mainAttachType;      // 主附件type

-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

+(id)customClassWithProperties:(id)properties
{
    LLDownloadPrivateMessageInfo* returnObject = [super customClassWithProperties:properties];
    returnObject.llDaoModelPrivateMessage = [LLDaoModelPrivateMessage customClassWithProperties:returnObject.llDaoModelPrivateMessage];
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
    return [NSString stringWithFormat:@"%.1fM/%.1fM",finishedSize,totalSize];
}
@end

@interface LLDownloadPrivateMessage()
@property (nonatomic, strong) NSMutableDictionary *tmpDic;
@property (nonatomic, strong) NSString *localfilePath;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL inforChanged;

@property (nonatomic, strong) NSString *currentDownloadLocFilePath;           // 当前的下载路径
@property (nonatomic, strong) NSString *currentLocFilePath;           // 当前需要赋值的本地原路径

/***
 * 功能：更新附件下载路径到数据库
 * 参数：无
 * 返回值：空
 
 * 创建者：dong 
 * 创建日期：2013-08-04
 */
- (void) updateDiaryAttach;

@end

@implementation LLDownloadPrivateMessage

static id lLDownloadPrivateMessageInstance;
+(LLDownloadPrivateMessage *)llDownloadPrivateMessage
{
    @synchronized(lLDownloadPrivateMessageInstance)
    {
        if (!lLDownloadPrivateMessageInstance)
        {
            lLDownloadPrivateMessageInstance=[[self alloc]init];
        }
    }
    return lLDownloadPrivateMessageInstance;
}

-(id)init
{
    if(self = [super init]){
        self.downloadArray = [[NSMutableArray alloc] initWithCapacity:10];
        self.tmpDic = [[NSMutableDictionary alloc] initWithCapacity:10];
        self.localfilePath = [LocalResourceModel getPrivateMessagePath];
        self.timer = nil;
    }
    return self;
}

#pragma mark LLDownloadDelegate
-(void)downloadProgress:(float)percent DownloadUrl:(NSString*)downloadurl Name:(NSString*)name
          LocalfilePath:(NSString*)localfilePath
{
    self.inforChanged = YES;
    [_tmpDic setValue:[NSNumber numberWithFloat:percent] forKey:name];
}

-(void)infoChanged:(long long)partialLength DownloadUrl:(NSString*)downloadurl Name:(NSString*)name
     LocalfilePath:(NSString*)localfilePath
{
    
}

-(void)inforChecker
{
    if(_inforChanged == YES){
        self.inforChanged = NO;
        //发送_tmpDic到私信
        if ([[_tmpDic allKeys] count] > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadPMProgress" object:self userInfo:_tmpDic];
        }
        [_tmpDic removeAllObjects];
    }
}

-(void)downloadClosed:(BOOL)error  DownloadUrl:(NSString *)downloadurl Name:(NSString *)name LocalfilePath:(NSString *)localfilePath
{
    for(LLDownload *lLDownload in self.downloadArray){
        if([downloadurl isEqualToString:lLDownload.downloadurl] && [name isEqualToString:lLDownload.name]
           && [localfilePath isEqualToString:lLDownload.localfilePath]){
            NSString* savePath = [[localfilePath stringByAppendingPathComponent:name] stringByAppendingPathExtension:[downloadurl pathExtension]];
            if ([[savePath pathExtension] isEqualToString:@"mp4"]) {
                double l = [Tools mediaDuration:savePath];
                if (l > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadPMFinish" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:name,@"name",savePath,@"savePath", nil]];
                }
                else
                {
                    [LocalResourceModel deleteLocalFile:savePath];
                    [lLDownload.request clearDelegatesAndCancel];
                    lLDownload.request = nil;
                    [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"私信内容下载失败，请稍后再试~"];
                }
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadPMFinish" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:name,@"name",savePath,@"savePath", nil]];
            }
            
            
//            [lLDownload.request removeTemporaryDownloadFile];
//            [[lLDownload request] clearDelegatesAndCancel];
//            NSLog(@"lLDownload.request %@", lLDownload.request.url);
//            [lLDownload.request setDelegate:nil];
            [self.downloadArray removeObject:lLDownload];
            break;
        }
    }
    
    if(_downloadArray.count <= 0)
    {
        if ([_timer isValid] || _timer != nil) {
            [_timer invalidate];
            self.timer = nil;
        }
    }
}

-(void)downloadFailed:(BOOL)error DownloadUrl:(NSString *)downloadurl Name:(NSString *)name LocalfilePath:(NSString *)localfilePath{
    [self downloadFailedRemoveLLDownload:downloadurl Name:name LocalfilePath:localfilePath];
}

-(void)downloadFailedRemoveLLDownload:(NSString *)downloadurl Name:(NSString *)name LocalfilePath:(NSString *)localfilePath
{
    for(LLDownload *lLDownload in self.downloadArray){
        if([downloadurl isEqualToString:lLDownload.downloadurl] && [name isEqualToString:lLDownload.name]
           && [localfilePath isEqualToString:lLDownload.localfilePath]){
            
            //            NSString* savePath = [[localfilePath stringByAppendingPathComponent:name] stringByAppendingPathExtension:[downloadurl pathExtension]];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadPMFinish" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:name,@"name",savePath,@"savePath", nil]];
            //下载失败移除下载队列
            [self.downloadArray removeObject:lLDownload];
            break;
        }
    }
    
    if(_downloadArray.count <= 0)
    {
        if ([_timer isValid] || _timer != nil) {
            [_timer invalidate];
            self.timer = nil;
        }
    }
}

-(void)startDownload:(NSString*)downloadurl Name:(NSString*)filename 
{
    if(self.downloadArray){
        @try {
            [Tools getNetUrlStatusAndType:downloadurl :^(int status,NSString* type,unsigned long long length)
            {
                if (status != 404 && ![type isEqualToString:@"text/html"]) {
                    LLDownload *lLDownload = [[LLDownload alloc] initWithDelegate:self];
                    [lLDownload download:downloadurl :self.localfilePath :filename];
                    [self.downloadArray addObject:lLDownload];
                }else
                {
                    [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"私信内容下载失败，请稍后再试~"];
                }
            }];

        }
        @catch (NSException *exception) {
           [self downloadFailedRemoveLLDownload:downloadurl Name:filename LocalfilePath:self.localfilePath];
        }
        @finally {
            
        }
    }
    
    if (self.downloadArray && self.timer == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(inforChecker)
                                                        userInfo:nil
                                                         repeats:YES];
        });
    }
    
     /*
//    NSString *url = @"";
    NSString *url = self.lLDownloadPrivateMessageInfo.downloadurl;
    
    
    NSString *name =[[NSString alloc] initWithFormat:@"%@%@",self.lLDownloadPrivateMessageInfo.attachuuid,
                     @"_1"];
    NSString *attachType = self.lLDownloadPrivateMessageInfo.attach_type;
    
    //传递的地址有问题不处理
    if(url.length <= 0 || STR_IS_NIL(url))
    {
        
    }else if (localfilePath.length <= 0 || STR_IS_NIL(localfilePath))
    {
       
    //日记私信
    }else{
//        [SandboxFile CreateList:localfilePath ListName:<#(NSString *)#>]
        self.currentDownloadLocFilePath = [[localfilePath stringByAppendingPathComponent:name]
                                           stringByAppendingPathComponent:[url pathExtension]];
        if([@"3" isEqualToString:_lLDownloadPrivateMessageInfo.privmsg_type])
        {
            //获取本地日记文件的大小及已经下载文件大小
            NSMutableArray *attachs = [_lLDownloadPrivateMessageInfo.llDaoModelPrivateMessage.privmsg.diaries attachs];
            if([attachs count] > 0){
                for(LLDaoModelDiaryAttachsCell *cell in attachs){
                    if([cell.attachuuid isEqualToString:_lLDownloadPrivateMessageInfo.attachuuid]){
                        _lLDownloadPrivateMessageInfo.totalSize = cell.downLoadSize;//[NSString stringWithFormat:@"%lld",length];
                    }
                }
                _lLDownloadPrivateMessageInfo.downloadidSize = [NSString stringWithFormat:@"%lld",[Tools calculatefolderSizeAtPath:self.currentDownloadLocFilePath]];
            }
            //若未知本地文件大小，获取本地文件大小
            if(_lLDownloadPrivateMessageInfo.totalSize == nil || [_lLDownloadPrivateMessageInfo.totalSize length] == 0){
                [Tools getNetUrlLength:url :^(unsigned long long length) {
                    if([attachs count] > 0)
                    {
                        for(LLDaoModelDiaryAttachsCell *cell in attachs){
                            if([cell.attachuuid isEqualToString:_lLDownloadPrivateMessageInfo.attachuuid]){
                                cell.downLoadSize = [NSString stringWithFormat:@"%lld",length];
                                cell.localSize = [NSString stringWithFormat:@"%lld",length];
                                _lLDownloadPrivateMessageInfo.totalSize = [NSString stringWithFormat:@"%lld",length];
                            }
                        }
                        [[LLDAOBase shardLLDAOBase] updateInsertToDB:_lLDownloadPrivateMessageInfo.llDaoModelPrivateMessage callback:^(BOOL result) {
                            
                        }];
                    }
                }];
                
            }
        //语音私信，文字语音私信
        }else if([@"2" isEqualToString:_lLDownloadPrivateMessageInfo.privmsg_type] || [@"4" isEqualToString:_lLDownloadPrivateMessageInfo.privmsg_type])
        {
            _lLDownloadPrivateMessageInfo.totalSize = _lLDownloadPrivateMessageInfo.llDaoModelPrivateMessage.privmsg.audioSize;
            if(_lLDownloadPrivateMessageInfo.totalSize == nil || [_lLDownloadPrivateMessageInfo.totalSize length] == 0){
                [Tools getNetUrlLength:url :^(unsigned long long length) {

                    _lLDownloadPrivateMessageInfo.totalSize = [NSString stringWithFormat:@"%lld",length];
                    _lLDownloadPrivateMessageInfo.llDaoModelPrivateMessage.privmsg.audioSize = [NSString stringWithFormat:@"%lld",length];
                    [[LLDAOBase shardLLDAOBase] updateInsertToDB:_lLDownloadPrivateMessageInfo.llDaoModelPrivateMessage callback:^(BOOL result) {
                            
                    }];
                }];
                
            }
        }
    }*/
}
@end
