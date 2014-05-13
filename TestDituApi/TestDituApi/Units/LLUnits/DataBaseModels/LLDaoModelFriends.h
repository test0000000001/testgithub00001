//
//  LLDaoModelFriends.h
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelBase.h"

@interface LLDaoModelFriends : LLDaoModelBase
@property (nonatomic,strong) NSString* userid;
@property (nonatomic,strong) NSString* headimageurl;
@property (nonatomic,strong) NSString* nickname;
@property (nonatomic,strong) NSString* diarycount;
@property (nonatomic,strong) NSString* attentioncount;
@property (nonatomic,strong) NSString* fanscount;
@property (nonatomic,strong) NSString* sex;
@property (nonatomic,strong) NSString* signature;
@property (nonatomic,strong) NSString* isattention;
@property (nonatomic,strong) NSString* isattentionme;
@end
