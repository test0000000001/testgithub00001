//
//  LLUpload.h
//  VideoShare
//  通过 GCDAsyncSocket 实现断点上传视频文件
//  Created by 曾超 on 13-6-9.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@class LLDaoModelDiary;
@class LLUploadTaskInfo;
@class LLVoiceUploadTaskInfo;


@interface RequestData : NSObject
@property (nonatomic,strong)NSString* ContentLength;//文件大小	单位 byte
@property (nonatomic,strong)NSString* userid;//	用户id
@property (nonatomic,strong)NSString* nuid;//	边拍边传时的第几段文件	第一段文件值为0，依次递增
@property (nonatomic,strong)NSString* over;//	文件是否上传文成标识	0 未完成 1完成
@property (nonatomic,strong)NSString* filename;//	文件物理路径	年_月_日_日记ID_时分秒&文件名
@property (nonatomic,strong)NSString* type;//	上传方式	1 单文件上传 n 边拍边传
@property (nonatomic,strong)NSString* rotation;//	视频旋转角度
@property (nonatomic,strong)NSString* filetype;//	文件类型	1 普清视频 2 高清视频 3 录音 4 图片 5语音描述
@property (nonatomic,strong)NSString* businesstype;//	业务类型	1 日记 2 评论 3 私信 4 陌生人消息
@property (nonatomic,strong)NSString* diaryid;//	日记表id
@property (nonatomic,strong)NSString* attachmentid;//	附件表id	根据businesstype的不同对于不同表中的id
@property (nonatomic,strong)NSString* isencrypt;//	音频文件是否加密	0未加密 1已加密
//add by xudongsheng 
@property (nonatomic,strong)NSString* nickname;//	用户昵称
@end

@interface ResponseData : NSObject
@property (strong,nonatomic) NSString* position;//文件上次字节
@property (strong,nonatomic) NSString* nuid;//上次分段文件id:0 1 2 3 。。。
@property (strong,nonatomic) NSString* over;//0未完成 1完成
@property (strong,nonatomic) NSString* dataover;//0 错误 1 头信息接收完成 2文件接收完 3交互完成
@end


@protocol LLUploadDelegate
@optional
-(void)socketClosed:(NSString*)serverFilePath:(BOOL)error;
-(void)infoChanged:(ResponseData*)responseData:(int)partialLength;
@end

@interface LLUpload : NSObject<GCDAsyncSocketDelegate>
-(id)initWithDelegate:(id<LLUploadDelegate>)delegate;//setp 1
-(void)initSocket:(LLUploadTaskInfo*)lLUploadTaskInfo;//step 2
-(void)startUpload;//step 3
-(void)reSetFiles;//step 4
-(NSArray*)files;
-(void)closeSocket;

/**
 * 功能：初始化一个上传评论语音的socket
 * 参数：(LLVoiceUploadTaskInfo *)lLVoiceUploadTaskInfo 语音task
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-17
 */
- (void) initVoiceSocket:(LLVoiceUploadTaskInfo *)lLVoiceUploadTaskInfo;

@end
