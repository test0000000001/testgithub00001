//
//  LLUploadTask.h
//  VideoShare
//
//  Created by zengchao on 13-6-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLTaskBase.h"
#import "LLUpload.h"
#import "CreateStructureResponseData.h"
#import "LLDaoModelDiary.h"
#import "LLDownload.h"

@interface LLDownLoadTaskInfo : NSObject
@property (nonatomic, strong) LLDaoModelDiary *modelDiary;          // 需要下载的日记
@property (nonatomic, assign) int             attachNumber;
@property (nonatomic, strong) NSString        *totalSize;
@property (nonatomic, strong) NSString        *downloadidSize;
@property (nonatomic, strong) NSString        *imageForShow;
@property (nonatomic, strong) NSString        *mainAttachType;      // 主附件type
@property (nonatomic, strong) NSString        *videoType;           // 需要下载的视频类型
@property (nonatomic, strong) NSString        *imagetype;           // 需要下载的图片类型
@property (nonatomic, strong) NSString        *audiotype;           // 需要下载的音频类型
-(NSString*)sizeInTotal;
-(float)percent;
-(NSString*)mainAttachType;
@end

@interface LLDownLoadTask : LLTaskBase<LLDownloadDelegate>

@end
