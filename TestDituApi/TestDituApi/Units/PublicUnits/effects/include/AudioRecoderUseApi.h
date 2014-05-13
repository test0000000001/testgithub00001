//
//  AudioRecoderUseApi.h
//  EfAVWriter
//
//  Created by penggang xi on 5/30/13.
//
//

#import <Foundation/Foundation.h>


@protocol recoderDelegate;

@interface AudioRecoderUseApi : NSObject


- (id)initWithDelegate:(id<recoderDelegate>) delegate;

/**
 名称：startRecodeAudio:::
 param：path 文件保存路径。
 param：id  文件id（用作文件名当bcat为true时，分割完的文件名为id_x的格式）
 param：bcat 是否分割文件。
 **/
- (void) startRecodeAudio:(NSString*)path fileID:(NSString*)fileid cat:(BOOL)bcat;
- (void) stopRecodeAudio;
- (void) pauseRecodeAudio;
- (void) resumeRecodeAudio;
- (BOOL) isRecode;
- (BOOL) isPaused;

@end

