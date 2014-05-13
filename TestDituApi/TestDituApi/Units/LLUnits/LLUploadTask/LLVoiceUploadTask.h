//
//  LLVoiceUploadTask.h
//  VideoShare
//
//  Created by capry on 13-6-20.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLTaskBase.h"
#import "LLUpload.h"


@interface LLVoiceUploadTaskInfo : NSObject
@property (nonatomic, strong) NSString    *ip;
@property (nonatomic, strong) NSString    *port;
@property (nonatomic, strong) RequestData *requestData;
@property (nonatomic)         NSInteger    fileinterval;
@property (nonatomic,strong)NSString* localPath;
@end

@interface LLVoiceUploadTask : LLTaskBase<LLUploadDelegate>
- (void)infoChanged:(ResponseData*)responseData:(int)partialLength;
@end
