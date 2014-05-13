//
//  Recognizer.m
//  VideoShare
//
//  Created by Shu Peng on 13-8-17.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "Recognizer.h"
#import "mp42pcm.h"
#import "transcodeDelegate.h"

#define APP_ID @"51a44745"
#define TIME_OUT @"5000"
#define AUTO_END_MISSION_TIMEOUT 60

#define STATE_READY                 0
#define STATE_RECOGNIZING           1
#define STATE_END_AND_WAIT_RESULT   2



@interface Recognizer () <IFlySpeechRecognizerDelegate>

@property (assign, nonatomic) NSInteger runningState;


@property (retain, nonatomic) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (copy, nonatomic) RECOGNIZER_SUCCESS_BLOCK successBlock;
@property (copy, nonatomic) RECOGNIZER_FAILED_BLOCK failedBlock;

@property (assign, nonatomic) BOOL isRecognizeMP4FileRunning;

@property (retain, nonatomic) NSString *filePath;
@property (retain, nonatomic) NSString *recognizedStr;
@property (retain, nonatomic) NSMutableData *pcmData;
@end


@implementation Recognizer
static Recognizer *defaultRecognizer;

+ (id)defaultRecognizer
{
    @synchronized(self){
        if (!defaultRecognizer) {
            defaultRecognizer = [[Recognizer alloc] init];
        }
        return defaultRecognizer;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)init
{
    if (self = [super init]) {
        // 创建对象
        NSString *initString = [NSString stringWithFormat:@"appid=%@,timeout=%@",APP_ID,TIME_OUT];
        self.iFlySpeechRecognizer = [IFlySpeechRecognizer createRecognizer:initString delegate:self];
        self.iFlySpeechRecognizer.delegate = self;
        
        // 设置引擎参数
        [self.iFlySpeechRecognizer setParameter:@"domain" value:@"sms"];
        [self.iFlySpeechRecognizer setParameter:@"sample_rate" value:@"16000"];
        
        self.runningState = STATE_READY;
        self.filePath = nil, self.recognizedStr = nil, self.pcmData = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIApplicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)startMissionTimeOutInspect
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(missionTimeOut) object:nil];
        [self performSelector:@selector(missionTimeOut) withObject:nil afterDelay:AUTO_END_MISSION_TIMEOUT];
    });
}

- (void)missionTimeOut
{
    JLog(@"执行任务超时动作!");
    [self dispatchFaildMSG:RECOGNIZE_ERROR_CONNECTION];
    [self resetState:@"任务超时"];
}

- (void)cancelMissionTimeOut
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(missionTimeOut) object:nil];
    });
}
- (void)resetState:(NSString *)reason
{
    JLog(@"重置语音识别状态 from state: %@, for reason: %@",[self convertStateToString:self.runningState],reason);
    
    self.failedBlock = nil;
    self.successBlock = nil;
    self.pcmData = nil;
    self.recognizedStr = nil;
    
    self.runningState = STATE_READY;
}

- (void)dispatchFaildMSG:(NSString *)errorCode
{
    RECOGNIZER_FAILED_BLOCK fBlock = self.failedBlock;
    if (fBlock) {
        JLog(@"分发识别失败回调!");
        dispatch_async(dispatch_get_current_queue(), ^{
            fBlock(@"",errorCode);
        });
    }
}

- (void)dispatchSuccessMSG
{
    RECOGNIZER_SUCCESS_BLOCK sBlock = self.successBlock;
    NSString *returnStr = self.recognizedStr;
    if (sBlock) {
        JLog(@"分发识别成功回调!");
        dispatch_async(dispatch_get_current_queue(), ^{
            sBlock(returnStr);
        });
    }
}

- (void)UIApplicationWillResignActive:(NSNotification *)a
{
    if ([a.name isEqualToString:UIApplicationWillResignActiveNotification]) {
        [self dispatchFaildMSG:RECOGNIZE_ERROR_APP_SHUTDOWN];
        [self resetState:@"应用程序将被要结束"];
    }
}

- (NSString *)convertStateToString:(NSInteger)oneState
{
    switch (oneState) {
        case STATE_READY:
            return @"准备状态";
            break;
            
        case STATE_RECOGNIZING:
            return @"正在识别, 并接受语音数据";
            break;
            
        case STATE_END_AND_WAIT_RESULT:
            return @"终止接受语音数据，正在等待讯飞处理结果";
            break;
            
        default:
            return @"未知状态";
            break;
    }
}


- (BOOL)isRecognizerIdel
{
    return (self.runningState == STATE_READY);
}

- (void)beginRecognizingWithSuccessBlock:(RECOGNIZER_SUCCESS_BLOCK)successBlock withFailedBlock:(RECOGNIZER_FAILED_BLOCK)failedBlock
{
    JLog(@"recognizer state in:%@",[self convertStateToString:self.runningState]);
    
    switch (self.runningState) {
        case STATE_READY:
        {
            [self resetState:@"开启新任务"];
            
            self.successBlock = successBlock;
            self.failedBlock = failedBlock;
            self.pcmData = [NSMutableData data];
            
            self.runningState = STATE_RECOGNIZING;
        }
            break;
            
        case STATE_RECOGNIZING:
        {
            [self dispatchFaildMSG:RECOGNIZE_ERROR_CANCELED];
            [self resetState:@"新任务到来"];
            
            self.successBlock = successBlock;
            self.failedBlock = failedBlock;
            self.pcmData = [NSMutableData data];
            
            self.runningState = STATE_RECOGNIZING;
        }
            break;
            
        case STATE_END_AND_WAIT_RESULT:
        {
            RECOGNIZER_FAILED_BLOCK fBlock = failedBlock;
            if (fBlock) {
                JLog(@"分发识别失败回调!");
                dispatch_async(dispatch_get_current_queue(), ^{
                    fBlock(@"",RECOGNIZE_ERROR_CANCELED);
                });
            }
            
            self.runningState = STATE_END_AND_WAIT_RESULT;
        }
            break;
            
        default:
            break;
    }
    JLog(@"recognizer state out:%@",[self convertStateToString:self.runningState]);
    
}

- (void)writeStream:(NSData *)streamData withLength:(NSInteger)length
{
    switch (self.runningState) {
        case STATE_READY:
            break;
            
        case STATE_RECOGNIZING:
        {
            if (!self.pcmData) {
                self.pcmData = [NSMutableData data];
            }
            else {
                [self.pcmData appendData:streamData];
            }
            
            self.runningState = STATE_RECOGNIZING;
        }
            break;
            
        case STATE_END_AND_WAIT_RESULT:
            break;
            
        default:
            break;
    }
}

- (void)endRecognizing
{
    JLog(@"recognizer state in:%@",[self convertStateToString:self.runningState]);
    
    
    switch (self.runningState) {
        case STATE_READY:
            break;
            
        case STATE_RECOGNIZING:
            [self startMissionTimeOutInspect];
            [self.iFlySpeechRecognizer recognizeAudio:self.pcmData];
            self.runningState = STATE_END_AND_WAIT_RESULT;
            break;
            
        case STATE_END_AND_WAIT_RESULT:
            [self startMissionTimeOutInspect];
            break;
            
        default:
            break;
    }
    
    JLog(@"recognizer state out:%@",[self convertStateToString:self.runningState]);
    
}

#pragma mark 识别MP4文件
// 识别单个MP4文件
- (void)recognizeMP4File:(NSString *)filePath WithSuccessBlock:(RECOGNIZER_SUCCESS_BLOCK)successBlock withFailedBlock:(RECOGNIZER_FAILED_BLOCK)failedBlock
{
#if !TARGET_IPHONE_SIMULATOR
    if (self.isRecognizeMP4FileRunning == NO) {
        if (filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            mp42pcm *transfer = [[mp42pcm alloc] initWithDelegate:self];
            [transfer start:filePath];
            [self beginRecognizingWithSuccessBlock:successBlock withFailedBlock:failedBlock];
        }
        else {
            self.isRecognizeMP4FileRunning = NO;
            RECOGNIZER_FAILED_BLOCK block = failedBlock;
            dispatch_async(dispatch_get_current_queue(), ^{
                if (block) {
                    block(@"",RECOGNIZE_ERROR_UNVALID_FILE);
                }
                
            });
        }
    }
#endif
}

- (void)dataReady:(unsigned char*)data size:(int)datasize ower:(void*)obj
{
#if !TARGET_IPHONE_SIMULATOR
    NSData *dataData = [NSData dataWithBytes:data length:datasize];
    NSLog(@"write data to ifly!");
    [self writeStream:dataData withLength:datasize];
#endif
}

- (void)transcodeFinish:(void*)obj
{
#if !TARGET_IPHONE_SIMULATOR
    [self endRecognizing];
    self.isRecognizeMP4FileRunning = NO;
#endif
}

#pragma mark - Callback from ifly
- (void)onVolumeChanged:(int)volume
{
    
}
- (void)onBeginOfSpeech
{
    
}

- (void)onEndOfSpeech
{
    
}

- (void)onError:(IFlySpeechError *)errorCode
{
    JLog(@"recognizer state in:%@ ",[self convertStateToString:self.runningState]);
    
    JLog(@"获取网络处理结果:%@ %d:%@",self.recognizedStr, [errorCode errorCode], [errorCode errorDesc]);
    
    [self cancelMissionTimeOut];
    
    switch (self.runningState) {
        case STATE_READY:
            JLog(@"state error!");
            self.runningState = STATE_READY;
            break;
            
        case STATE_RECOGNIZING:
            JLog(@"state error!");
            self.runningState = STATE_READY;
            break;
            
        case STATE_END_AND_WAIT_RESULT:
        {
            if ([errorCode errorCode] == 0) {
                [self dispatchSuccessMSG];
                [self resetState:@"任务识别成功结束"];
            }
            else {
                [self dispatchFaildMSG:[@([errorCode errorCode]) stringValue]];
                [self resetState:@"任务识别失败结束"];
            }
            
            self.runningState = STATE_READY;
        }
            break;
            
        default:
            break;
    }
    
    JLog(@"recognizer state out:%@",[self convertStateToString:self.runningState]);
    
}

- (void)onResults:(NSArray *)results
{
    NSString *result = [[[results objectAtIndex:0] allKeys] objectAtIndex:0];
    NSString *reliability = [[results objectAtIndex:0] objectForKey:result];
    
    JLog(@"got result:%@, %@",results, reliability);
    if (self.recognizedStr) {
        self.recognizedStr = [self.recognizedStr stringByAppendingString:result];
    }
    else {
        self.recognizedStr = result;
    }
}

@end
