//
//  LLUpload.m
//  VideoShare
//
//  Created by 曾超 on 13-6-9.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "LLUpload.h"
#import "Tools.h"
#import "NSObject+ABJsonConverter.h"
#import "ToolsUnite.h"
#import "LLUploadTask.h"
#import "LLVoiceUploadTask.h"
#import "CreateStructureResponseData.h"
#import "LLDaoModelDiary.h"
#import "LocalResourceModel.h"

@implementation RequestData
@end

@implementation ResponseData
@end


@interface LLUpload()
{

}
@property (assign,nonatomic) BOOL isOver;//队列添加完毕
@property (assign,nonatomic) BOOL isBusy;
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) GCDAsyncSocket* asyncSocket;
@property (nonatomic, weak) id<LLUploadDelegate> delegate;
@property (strong, nonatomic) RequestData *requestData;
@property (strong, nonatomic) ResponseData *responseData;
@property (strong, nonatomic) NSString* ip;
@property (strong, nonatomic) NSString* port;
@property (assign, nonatomic) int fileinterval;
@property (assign, nonatomic) int fileintervalCount;
@property (strong,nonatomic) NSTimer *timerFileinterval;
@property (strong, nonatomic) NSMutableArray *path;
@property (strong, nonatomic) NSString* fileFolder;
@property (strong, nonatomic) NSString* fileName;
@end



@implementation LLUpload
-(id)initWithDelegate:(id<LLUploadDelegate>)delegate
{
    if (self = [super init]) {
        self.path = [[NSMutableArray alloc]initWithCapacity:10];
        self.requestData = [[RequestData alloc]init];
        self.delegate = delegate;
        self.fileintervalCount = 0;
    }
    return self;
}

-(void)initSocket:(LLUploadTaskInfo*)lLUploadTaskInfo
{
    self.responseData = nil;
    self.fileinterval = lLUploadTaskInfo.fileinterval + 5;
    self.requestData = [[RequestData alloc]init];
    _requestData.diaryid = lLUploadTaskInfo.createStructureResponseData.diaryid;
    _requestData.userid = APP_USERID;
    _requestData.over = @"0";
    _requestData.businesstype = @"1";//	业务类型	1 日记 2 评论 3 私信 4 陌生人消息
    _requestData.ContentLength = @"0";//发数据的时候会取
    _requestData.nickname = APP_NICKNAME;
    
    
    CreateStructureRequestAttachData* requestAttachData= [lLUploadTaskInfo currentRequestAttachData];
    
    if (requestAttachData) {
        if([requestAttachData.attach_type isEqualToString:@"1"])//视频
        {
            _requestData.type = requestAttachData.createType;
            _requestData.nuid = requestAttachData.nuid;
            _requestData.rotation = @"0";
            
            if ([requestAttachData.attach_type isEqualToString:@"1"]) {//1视频 2音频 3图片 4文字
                _requestData.filetype = [requestAttachData.video_type isEqualToString:@"0"]?@"2":@"1";//	文件类型	1 普清视频 2 高清视频 3 录音 4 图片 5语音描述
            }
            _requestData.isencrypt = @"0";
            
            self.fileFolder = [[LocalResourceModel VideosShootPath] stringByAppendingPathComponent:requestAttachData.attachuuid];
        }
        else if ([requestAttachData.attach_type isEqualToString:@"2"])//音频
        {
            _requestData.type = requestAttachData.createType;
            _requestData.nuid = requestAttachData.nuid;
            _requestData.rotation = @"0";//无用
            _requestData.filetype = [requestAttachData.level isEqualToString:@"1"] ? @"3":@"5";//	文件类型	1 普清视频 2 高清视频 3 录音 4 图片 5语音描述
            //1原音，2加密音，attach_type=2有效
            if ([requestAttachData.audio_type isEqualToString:@"2"]) {
                _requestData.isencrypt = @"1";//	音频文件是否加密	0未加密 1已加密
            }
            else
            {
                _requestData.isencrypt = @"0";
            }
            self.fileFolder = [[LocalResourceModel getSoundsRecordPath] stringByAppendingPathComponent:requestAttachData.attachuuid];
        }
        else if ([requestAttachData.attach_type isEqualToString:@"3"])//图片
        {
            _requestData.type = @"1";
            _requestData.filetype = @"4";//	文件类型	1 普清视频 2 高清视频 3 录音 4 图片 5语音描述
            _requestData.type = @"1";//无用
            _requestData.nuid = @"0";//无用
            _requestData.rotation = @"0";//无用
            _requestData.isencrypt = @"0";//无用
            self.fileFolder = [LocalResourceModel getImageShootPath];
        }
        self.fileName = requestAttachData.attachuuid;
    }
    
    
    if ([lLUploadTaskInfo.createStructureResponseData.attachs count] > [lLUploadTaskInfo attachNumber]) {
        CreateStructureResponseAttachData* responseAttachData = [lLUploadTaskInfo.createStructureResponseData.attachs objectAtIndex:lLUploadTaskInfo.attachNumber];
        if (!OBJ_IS_NIL(responseAttachData)) {
            _requestData.filename = responseAttachData.path;
            _requestData.attachmentid = responseAttachData.attachid;
        }
    }
    
    self.ip = lLUploadTaskInfo.createStructureResponseData.ip;
    self.port = lLUploadTaskInfo.createStructureResponseData.port;
    
    //self.ip = @"172.16.1.66";//何树营机器
    //self.port = @"7885";
    //
   // self.port = @"7887"; //何树营机器 北京
    
    [self reSetFiles];
    

    self.isOver = [_requestData.type isEqualToString:@"1"];
    
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

/**
 * 功能：初始化一个上传评论语音的socket
 * 参数：(LLVoiceUploadTaskInfo *)lLVoiceUploadTaskInfo 语音task
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-17
 */
- (void) initVoiceSocket:(LLVoiceUploadTaskInfo *)lLVoiceUploadTaskInfo
{
    self.responseData = nil;
    self.fileinterval = lLVoiceUploadTaskInfo.fileinterval;
    self.requestData = lLVoiceUploadTaskInfo.requestData;
    self.ip = lLVoiceUploadTaskInfo.ip;
    self.port = lLVoiceUploadTaskInfo.port;
    self.isOver = [_requestData.type isEqualToString:@"1"];
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_path addObject:lLVoiceUploadTaskInfo.localPath];
}

-(void)startUpload
{
    NSError *err = nil;
    if(![_asyncSocket connectToHost:self.ip onPort:[self.port intValue] error:&err])
    {
        [self socketLog:[NSString stringWithFormat:@"%@,ip=%@,port=%@",@"连接失败",_ip,_port]];
        [self closeSocket];
        [_delegate socketClosed:@"" :YES];
    }
    else
    {
        [self socketLog:[NSString stringWithFormat:@"%@,ip=%@,port=%@",@"连接成功",_ip,_port]];
        if(self.timer == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(checkHowToSend)
                                                            userInfo:nil
                                                             repeats:YES];
                self.timerFileinterval = [NSTimer scheduledTimerWithTimeInterval:1
                                                                          target:self
                                                                        selector:@selector (timerFileintervalLoop)
                                                                        userInfo:nil
                                                                         repeats:YES];
            });
             
        }
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    [_delegate infoChanged:_responseData:partialLength];
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag//1 头信息 2视频数据
{
    [_asyncSocket readDataWithTimeout:300 tag:tag];
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length{
    return 60;
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    self.isBusy = NO;
    [self set_ResponseData:data];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        [self socketLog:[NSString stringWithFormat:@"socketDidDisconnect with %@",[err description]]];
        [self closeSocket];
        [_delegate socketClosed:@"":YES];
    }
}

-(void)applicationWillResignActive
{

}

-(void)beginBackgroundTaskWithExpirationHandler
{
    [self closeSocket];
    [_delegate socketClosed:@"":YES];
}

-(void)reSetFiles
{
    self.fileintervalCount = 0;
    if (_fileFolder) {
        [_path removeAllObjects];
        
        NSString* suffix = @"";
        if ([_requestData.filetype isEqualToString:@"1"]||
            [_requestData.filetype isEqualToString:@"2"]||
            [_requestData.filetype isEqualToString:@"3"]||
            [_requestData.filetype isEqualToString:@"5"]) {
            suffix = @".mp4";
            
        }
        else if ([_requestData.filetype isEqualToString:@"4"])
        {
            suffix = @".jpg";
        }
        
        if ([_requestData.type isEqualToString:@"n"]) {
            for (int i = 0; i<100; i++) {
                NSString* fileFullPath = [_fileFolder stringByAppendingPathComponent:_fileName];
                fileFullPath = [fileFullPath stringByAppendingFormat:@"-%d%@",i,suffix];
                //[self socketLog:[NSString stringWithFormat:@"fileType is %@,fileFullPath is %@, ",_requestData.filetype,fileFullPath]];
                if ([self fileInPathArray:fileFullPath]==NO && [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath]) {
                    if (i == 0) {
                        [self getRotation:fileFullPath];
                    }
                    [_path addObject:fileFullPath];
                }
                else
                {
                    break;
                }
            }
        }
        else
        {
            NSString* fileFullPath = @"";
            
            NSString* tmp = [_fileFolder stringByAppendingPathComponent:_fileName];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:[tmp stringByAppendingFormat:@"%@",suffix]]) {
                fileFullPath = [tmp stringByAppendingFormat:@"%@",suffix];
            }
            if (STR_IS_NIL(fileFullPath) && [_requestData.filetype isEqualToString:@"4"]) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:[tmp stringByAppendingFormat:@"%@",@".png"]]) {
                    fileFullPath = [tmp stringByAppendingFormat:@"%@",@".png"];
                }
            }
            //[self socketLog:[NSString stringWithFormat:@"fileType is %@,fileFullPath is %@, ",_requestData.filetype,fileFullPath]];
            if (!STR_IS_NIL(fileFullPath) && [self fileInPathArray:fileFullPath]==NO) {
                if ([_requestData.filetype isEqualToString:@"1"]||
                    [_requestData.filetype isEqualToString:@"2"]) {
                    [self getRotation:fileFullPath];
                }
                [_path addObject:fileFullPath];
            }
        }
        [self socketLog:[NSString stringWithFormat:@"%@ count=%d, ",@"上传文件变动",[_path count]]];
    }
    
    
}

-(NSArray*)files
{
    return _path;
}

-(BOOL)fileInPathArray:(NSString*)file
{
    for (NSString* cell in _path) {
        if ([file isEqualToString:cell]) {
            return YES;
        }
    }
    return NO;
}

-(void)getRotation:(NSString*)file
{
#if!(TARGET_IPHONE_SIMULATOR)
    int angle=[ToolsUnite GetFileVideoAngle:file];
    NSLog(@"************************angle = %d", angle);
    if(angle==0)
    {
        _requestData.rotation=@"0";
    }
    else if(angle==1)
    {
        _requestData.rotation=@"90";
    }
    else if(angle==3)
    {
        _requestData.rotation=@"180";
    }
    else if(angle==4)
    {
        _requestData.rotation=@"270";
    }
#endif
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"LLUpload dealloc");
}

-(void)closeSocket
{
    //文件传输完毕 关闭timer 关闭socket
    if ([_timer isValid] || _timer != nil) {
        [_timer invalidate];
        self.timer = nil;
    }
    if ([_timerFileinterval isValid] || _timerFileinterval != nil) {
        [_timerFileinterval invalidate];
        self.timerFileinterval = nil;
    }
    
    if (_asyncSocket != nil) {
        [_asyncSocket setDelegate:nil];
        [_asyncSocket setDelegateQueue:nil];
        [_asyncSocket disconnect];
        self.asyncSocket = nil;
    }
    [self socketLog:[NSString stringWithFormat:@"%@",@"socket关闭"]];
}

-(void)set_ResponseData:(NSData*)data
{
    self.responseData = [[ResponseData alloc]init];
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *responseArray = [responseString componentsSeparatedByString:@";"];
    for (NSString* cell in responseArray) {
        if ([cell hasPrefix:@"position="]) {
            _responseData.position = [cell substringFromIndex:[@"position=" length]];
        }
        else if ([cell hasPrefix:@"nuid="]) {
            _responseData.nuid = [cell substringFromIndex:[@"nuid=" length]];
        }
        else if ([cell hasPrefix:@"over="]) {
            _responseData.over = [cell substringFromIndex:[@"over=" length]];
        }
        else if ([cell hasPrefix:@"dataover="]) {
            _responseData.dataover = [cell substringFromIndex:[@"dataover=" length]];
        }
    }
    [self checkHowToSend];
}

-(NSData*)createHeader
{
    /*00205Content-Length=7233878;userid=5358e7db0646f04a820bcb20ebc2e7818a70;nuid=0;over=0;filename=2013_05_15_diaryid_143552ceaded5d28344669b29888e4a278194f.mp4;type=1;rotation=0;filetype=1;businesstype=1;diaryid=1001;attachmentid=2001;isencrypt=0;*/

    NSString *head = [NSString stringWithFormat:
                      @"Content-Length=%@;userid=%@;nuid=%@;over=%@;filename=%@;type=%@;rotation=%@;filetype=%@;businesstype=%@;diaryid=%@;attachmentid=%@;isencrypt=%@;nickname=%@\r\n",
                      _requestData.ContentLength,_requestData.userid,_requestData.nuid,_requestData.over,_requestData.filename,_requestData.type,_requestData.rotation,_requestData.filetype,_requestData.businesstype,_requestData.diaryid,_requestData.attachmentid,_requestData.isencrypt,[Tools base64Encode:UN_NIL(_requestData.nickname)]];
    int length = head.length;//补齐5位，不够前面加0
    NSString *buwei;
    if (length < 100) {
        buwei = @"000";
    }else if(length < 1000){
        buwei = @"00";
    }else if(length < 10000){
        buwei = @"0";
    }
    NSString *newHead = [NSString stringWithFormat:@"%@%d%@",buwei,length,head];
    
    [self socketLog:[NSString stringWithFormat:@"头信息详细==================\n%@\n\n",newHead]];
    
    NSData* result = [newHead dataUsingEncoding: NSUTF8StringEncoding];
    return result;
}

-(void)doSendHead:(NSData*)header
{
    self.isBusy = YES;
    [_asyncSocket writeData:header withTimeout:300 tag:1];
}

-(void)timerFileintervalLoop
{
    self.fileintervalCount ++;
    if (_fileintervalCount > _fileinterval) {
        //读取文件超时
        self.isOver = YES;
        if ([_timerFileinterval isValid] || _timerFileinterval != nil) {
            [_timerFileinterval invalidate];
            self.timerFileinterval = nil;
        }
    }
}

-(void)checkHowToSend
{
    if (_responseData) {
        if ([_responseData.dataover isEqualToString:@"0"]) {
            [self socketLog:[NSString stringWithFormat:@"%@",@"服务器告诉我头信息错误"]];
            [self closeSocket];
            [_delegate socketClosed:@"":YES];
        }
        else if ([_responseData.dataover isEqualToString:@"1"])//服务器告诉我他头信息接收完毕了
        {
            [self socketLog:[NSString stringWithFormat:@"%@",@"服务器告诉我他头信息接收完毕了"]];
            if ([_responseData.over isEqualToString:@"0"]) {//0未完成
                _requestData.nuid = [NSString stringWithFormat:@"%d",[_responseData.nuid integerValue]];//nuid存起来
                if ([_path count] > [_requestData.nuid integerValue])
                {
                    [self sendBody];//发送实体
                    self.responseData = nil;
                }
            }
            else//1完成
            {
                [self sendHead];
                self.responseData = nil;
            }
        }
        else if([_responseData.dataover isEqualToString:@"2"])//服务器告诉我他文件接收完毕了
        {
            [self socketLog:[NSString stringWithFormat:@"%@",@"服务器告诉我他文件接收完毕了"]];
            [_delegate infoChanged:_responseData:0];
            [self sendHead];
            self.responseData = nil;
        }
        else if ([_responseData.dataover isEqualToString:@"3"])//服务器告诉我整个流程结束了
        {
            [self socketLog:[NSString stringWithFormat:@"%@",@"服务器告诉我整个流程结束了"]];
            [self closeSocket];
            [_delegate socketClosed:@"":NO];
        }
    }
    else if(!_isBusy)
    {
        [self sendHead];
    }
}

-(void)sendHead
{
    if (!STR_IS_NIL(_requestData.attachmentid)) {
        if (_responseData) {
            _requestData.nuid = [NSString stringWithFormat:@"%d",[_responseData.nuid integerValue]+1];//nuid存起来
        }
        if ([_path count] > [_requestData.nuid integerValue])
        {
            [self sendHeadBeforeBody];//发送头部
        }
        else if(_isOver)
        {
            _requestData.nuid = [NSString stringWithFormat:@"%d",_path.count-1];//nuid存起来
            [self sendHeadAfterAllFinished];
        }
    }
    else
    {
        [self closeSocket];
        [_delegate socketClosed:@"":YES];
    }
}

-(void)sendHeadBeforeBody
{
    //发文件前,发个头
    _requestData.contentLength = @"0";
    [self socketLog:[NSString stringWithFormat:@"%@,%@",@"文件名===================",[_path objectAtIndex:[_requestData.nuid integerValue]]]];
//    NSData* oneData = [NSData dataWithContentsOfFile:[_path objectAtIndex:[_requestData.nuid integerValue]] options:NSDataReadingMappedIfSafe error:nil];
    NSLog(@"yyyyyyyyyy->%@",[_path objectAtIndex:[_requestData.nuid integerValue]]);
     NSFileHandle *fHandle = [NSFileHandle fileHandleForReadingAtPath:[_path objectAtIndex:[_requestData.nuid integerValue]]];
    long long length = fHandle.seekToEndOfFile;
    [fHandle closeFile];
//    NSData *oneData = [NSData dataWithContentsOfFile:[_path objectAtIndex:[_requestData.nuid integerValue]]];
    _requestData.contentLength = [NSString stringWithFormat:@"%lld",length];
    
    [self socketLog:[NSString stringWithFormat:@"%@",@"发文件前,发个头==================="]];
    NSData* header = [self createHeader];
    [self doSendHead:header];
}

-(void)sendHeadAfterAllFinished
{
    //当文件全部传输完成,发个头
    [self socketLog:[NSString stringWithFormat:@"%@",@"文件全部传输完成,准备发送over=1确认标志==================="]];
    _requestData.ContentLength = @"0";
    _requestData.over = @"1";
    NSData* header = [self createHeader];
    [self doSendHead:header];
}

-(void) sendBody
{
    [self socketLog:@"发送视频数据"];
    if ([_path count] > [_requestData.nuid integerValue]) {
//        NSFileHandle *fHandle = [NSFileHandle fileHandleForReadingAtPath:[_path objectAtIndex:[_requestData.nuid integerValue]]];
//        [fHandle seekToFileOffset:[_responseData.position longLongValue]];//截取文件数据
//        NSData *aData = [fHandle availableData];
//        NSData* aData = [fHandle readDataOfLength:300*1000];
        NSFileHandle *fHandle = [NSFileHandle fileHandleForReadingAtPath:[_path objectAtIndex:[_requestData.nuid integerValue]]];
        long long length = fHandle.seekToEndOfFile;
        [fHandle closeFile];
        long long position = [_responseData.position longLongValue];
        NSError *errorPtr = nil;
        NSData* aData = [[NSData dataWithContentsOfFile:[_path objectAtIndex:[_requestData.nuid integerValue]] options:NSDataReadingMappedIfSafe error:&errorPtr]subdataWithRange:NSMakeRange(position, length-position)];
        self.isBusy = YES;
        [_asyncSocket writeData:aData withTimeout:300 tag:2];
        [self socketLog:[NSString stringWithFormat:@"nuid = %@, position = %@, length = %lld, errorPtr = %@",_requestData.nuid,_responseData.position,length - position ,errorPtr]];
    }
    
}

-(void)socketLog:(NSString*)str
{
    NSLog(@"socketLog Diaryid = %@\n,%@",_requestData.diaryid,str);
}
@end
