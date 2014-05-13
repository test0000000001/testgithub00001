//
//  Recognizer.h
//  VideoShare
//
//  Created by Shu Peng on 13-8-17.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <iflyMSC/IFlySpeechRecognizer.h>

#define RECOGNIZE_ERROR_APP_SHUTDOWN    @"99997"
#define RECOGNIZE_ERROR_UNVALID_FILE    @"99998"
#define RECOGNIZE_ERROR_CANCELED        @"99999"
#define RECOGNIZE_ERROR_CONNECTION      @"10114"


typedef void (^RECOGNIZER_SUCCESS_BLOCK)(NSString *recognizedStr);
typedef void (^RECOGNIZER_FAILED_BLOCK) (NSString *recognizedStr, NSString *errorDescription);

@interface Recognizer : NSObject

+(id)defaultRecognizer;


// 判断语音识别是否属于空闲状态.
- (BOOL)isRecognizerIdel;

// 确保 begin 与 end 配对使用. 否则始终不会给 receiver 回掉
- (void)beginRecognizingWithSuccessBlock:(RECOGNIZER_SUCCESS_BLOCK)successBlock withFailedBlock:(RECOGNIZER_FAILED_BLOCK)failedBlock;
- (void)writeStream:(NSData *)streamData withLength:(NSInteger)length;
- (void)endRecognizing;

// 识别单个MP4文件
- (void)recognizeMP4File:(NSString *)filePath WithSuccessBlock:(RECOGNIZER_SUCCESS_BLOCK)successBlock withFailedBlock:(RECOGNIZER_FAILED_BLOCK)failedBlock;
@end