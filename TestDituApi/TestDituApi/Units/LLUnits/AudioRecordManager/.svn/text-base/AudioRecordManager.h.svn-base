//
//  RecordManager.h 底层库二次封装
//  VideoShare
//
//  Created by xu dongsheng on 13-6-7.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioRecoderUseApi.h"

@interface AudioRecordManager : NSObject

@property(nonatomic,strong)AudioRecoderUseApi* audioRecorderApi;
+ (AudioRecordManager *) audioRecordManagerWithOuterDelegate:(id<recoderDelegate>)outerDelegate;

/**
  录音，并根据指定的目录存放生成的录音文件 path/fieid/xxx-0.mp4 path/fieid/xxx-1.mp4 path/fieid/xxx.mp4
 名称：startRecodeAudio:::
 param：path 文件保存路径。
 param：id  文件id（用作文件名当bcat为true时，分割完的文件名为id_x的格式）
 param：bcat 是否分割文件。
 **/
- (void) startRecodeAudio:(NSString*)path id:(NSString*)fileid cat:(BOOL)bcat;

- (void) stopRecodeAudio;
- (void) pauseRecodeAudio;
- (void) resumeRecodeAudio;
- (BOOL) isRecode;
- (BOOL) isPaused;

@end
