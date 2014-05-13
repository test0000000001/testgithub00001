//
//  LLDaoModelActivtyJoinedVideo.h
//  VideoShare
//
//  Created by wan liming on 7/15/13.
//  Copyright (c) 2013 cmmobi. All rights reserved.
//

#import "LLDaoModelBase.h"

@interface LLDaoModelActivtyJoinedVideo : LLDaoModelBase
@property (nonatomic,strong) NSString* userKey;             //联合主键
@property (nonatomic, strong) NSString *activeid;           // 活动id
@property (nonatomic, strong) NSString *diaryid;            // 日记的id
@end
