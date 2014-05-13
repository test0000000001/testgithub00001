//
//  LLDownloadPrivateMessage.h
//  VideoShare
//
//  Created by qin on 13-8-3.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLDaoModelPrivateMessage.h"
#import "LLDownload.h"

@interface LLDownloadPrivateMessageInfo : NSObject

@property (nonatomic, strong) NSString *totalSize;
@property (nonatomic, strong) NSString *downloadidSize;
@property (nonatomic, strong) NSString *mainAttachType;      // 主附件type

@property (nonatomic, strong) NSString *messageid;  //消息id，唯一标示
@property (nonatomic, strong) NSString *privmsg_type; //私信类型 --- 1代表纯文字 2代表语音 3代表日记      4语音加文字
@property (nonatomic, strong) LLDaoModelPrivateMessage *llDaoModelPrivateMessage; //单条私信信息
@property (nonatomic, strong) NSString *downloadurl; //下载地址

@property (nonatomic, strong) NSString        *attachuuid;      //附件id
@property (nonatomic, strong) NSString        *attach_type;     //附件类型  1.视频  2.语音   3.图片
@property (nonatomic, strong) NSString        *videoType;           // 需要下载的视频类型
@property (nonatomic, strong) NSString        *imagetype;           // 需要下载的图片类型
//@property (nonatomic, strong) NSString

-(NSString*)sizeInTotal;
-(float)percent;
-(NSString*)mainAttachType;
@end

@interface LLDownloadPrivateMessage : NSObject<LLDownloadDelegate>
@property (nonatomic, strong) NSMutableArray *downloadArray;
@property (nonatomic, strong) LLDownloadPrivateMessageInfo *lLDownloadPrivateMessageInfo;
-(void)startDownload;
-(void)startDownload:(NSString*)downloadurl Name:(NSString*)filename;
+(LLDownloadPrivateMessage *)llDownloadPrivateMessage;
@end
