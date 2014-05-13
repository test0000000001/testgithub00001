//
//  LLSharePublishManager.h
//  VideoShare
//
//  Created by tangyx on 13-6-20.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLShareTask.h"
#import "LLPublishTask.h"
#import "RIAWebRequestLib.h"
#import "DiaryShareUrlData.h"
@interface LLSharePublishManager : NSObject
//第三方分享 私信
+(void)thirdPublishSend:(LLShareTaskInfo*)taskInfo;

//取消发布
+(void)cancelPublishDiary:(NSString*)diaryuuid :(NSString*)userid;
//发布
+(void)publishDiary:(NSString*)diaryuuid :(NSString*)userid;
+(NSString*)getStringFrom:(NSArray*)array nameAppendStr:(NSString*)nameAppend separation:(NSString*)separation;
//获取服务器分享url
+(void)getDiaryShareUrlData:(NSString*)diaryid return:(void(^)(DiaryShareUrlData* data))block;
@end
