//
//  LLVoiceUploadTask.m
//  VideoShare
//
//  Created by capry on 13-6-20.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "Global.h"
#import "JSONKit.h"
#import "DiaryCommentDataBase.h"
#import "LLUploadTask.h"
#import "LLVoiceUploadTask.h"

@implementation LLVoiceUploadTaskInfo
-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

+(id)customClassWithProperties:(id)properties
{
    LLVoiceUploadTaskInfo* returnObject = [super customClassWithProperties:properties];
    returnObject.requestData = [RequestData customClassWithProperties:returnObject.requestData];
    return returnObject;
}
@end


@interface LLVoiceUploadTask ()
@property(nonatomic,strong)LLUpload* lLUpload;
@property(nonatomic,strong)LLVoiceUploadTaskInfo* lLVoiceUploadTaskInfo;
@end

@implementation LLVoiceUploadTask

-(void)startUpload
{
    self.lLUpload = [[LLUpload alloc]initWithDelegate:self];
    [_lLUpload initVoiceSocket:_lLVoiceUploadTaskInfo];
    [_lLUpload startUpload];
}

-(void) startTask
{
    self.lLVoiceUploadTaskInfo = [LLVoiceUploadTaskInfo customClassWithProperties:[_taskInfo objectFromJSONString]];
    [self startUpload];
}

#pragma mark LLUploadDelegate

// 语音上传完毕
-(void)socketClosed:(NSString*)serverFilePath:(BOOL)error
{    
    if (error)
    {
        // error不做处理
//        [_delegate taskPaused:_taskID];
    }
    else
    {
        if([self.lLVoiceUploadTaskInfo.requestData.businesstype isEqualToString:@"2"])
        {
            [self diaryCommentFinished];
        }

        [_delegate taskFinished:_taskID:NO];
    }
}

- (void) diaryCommentFinished
{
    NSString *commentid = self.lLVoiceUploadTaskInfo.requestData.attachmentid;
    NSString *whereStr  = [NSString stringWithFormat:@"commentid=\'%@\'",commentid];
    [[LLDAOBase shardLLDAOBase] deleteToDBWithWhere:[[DiaryCommentDataBase alloc] init]
                                              where:whereStr
                                           callback:^(BOOL result)
     {}];
}

- (void)infoChanged:(ResponseData*)responseData:(int)partialLength
{
    
}
@end
