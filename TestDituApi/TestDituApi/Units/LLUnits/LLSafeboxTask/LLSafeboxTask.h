//
//  LLSafeboxTask.h
//  VideoShare
//
//  Created by zc on 13-7-30.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLTaskBase.h"
#import "LLDaoModelDiary.h"

@interface LLSafeboxTaskInfo : NSObject
@property(nonatomic,strong)NSString* diaryuuid;
@property(nonatomic,strong)NSString* diaryid;
@property(nonatomic,strong)NSString* type;
@end

@interface LLSafeboxTask : LLTaskBase

@end
