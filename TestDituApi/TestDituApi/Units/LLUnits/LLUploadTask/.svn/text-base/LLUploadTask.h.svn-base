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

@interface LLUploadTaskInfo : NSObject
@property(nonatomic,strong) CreateStructureRequestData* createStructureRequestData;
@property(nonatomic,strong) CreateStructureResponseData* createStructureResponseData;
@property(nonatomic,assign) int fileinterval;
@property(nonatomic,assign) int attachNumber;//已完成几个附件
@property(nonatomic,strong) NSString* totalSize;
@property(nonatomic,strong) NSString* uploadidSize;
@property(nonatomic,strong) NSString* imageForShow;
@property(nonatomic,strong) NSString* mainAttachType;
//-(void)checkFinishedSize;
-(void)checkTotalSize;
-(float)percent;
-(NSString*)sizeInTotal;
//-(NSString*)mainAttachType;
-(BOOL)isPublish;
-(CreateStructureRequestAttachData *)currentRequestAttachData;
@end

@interface LLUploadTask : LLTaskBase<LLUploadDelegate>
-(BOOL)isShare;
-(void)cancelShare;
-(NSString*)mainAttachType;
@end
