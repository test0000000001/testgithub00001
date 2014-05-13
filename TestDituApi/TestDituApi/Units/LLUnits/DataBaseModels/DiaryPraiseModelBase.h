//
//  DiaryPraiseModelBase.h
//  VideoShare
//
//  Created by capry on 13-6-18.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLDaoModelBase.h"

@interface DiaryPraiseModelBase : LLDaoModelBase

@property (nonatomic, strong) NSString *diaryid;         // 日记id
@property (nonatomic, strong) NSString *userid;         // 用户ID
@property (nonatomic, strong) NSString *update_time;    // 修改时间
@property (nonatomic, strong) NSString *headimageurl;   // …jpg", //头像URL，可为空
@property (nonatomic, strong) NSString *nickname;       // 昵称
@property (nonatomic, strong) NSString *diarycount;     // 日记数
@property (nonatomic, strong) NSString *sex;            // 0男，1女， 2未知
@property (nonatomic, strong) NSString *signature;      // 是编码的，需要解码
@property (nonatomic, strong) NSString *key;            // 主键

@end
