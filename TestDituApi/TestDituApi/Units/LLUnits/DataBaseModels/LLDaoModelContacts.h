//
//  LLDaoModelContactsFansList.h
//  VideoShare
//
//  Created by tangyx on 13-6-17.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLDaoModelBase.h"

@interface LLDaoModelContacts : LLDaoModelBase

@property(nonatomic,strong,readonly)NSString* contactskey;
@property(nonatomic,strong)NSString* contactstype;
@property(nonatomic,strong)NSString* userid;
@property(nonatomic,strong)NSString* headimageurl;
@property(nonatomic,strong)NSString* nickname;
@property(nonatomic,strong)NSString* attentioncount;
@property(nonatomic,strong)NSString* fanscount;
@property(nonatomic,strong)NSString* diarycount;
@property(nonatomic,strong)NSString* sex;
@property(nonatomic,strong)NSString* signature;
@property(nonatomic,strong)NSString* key;
-(void)updateKey;//更新首字母
@end
