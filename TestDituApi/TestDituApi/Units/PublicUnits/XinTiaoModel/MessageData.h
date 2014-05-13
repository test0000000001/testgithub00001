//
//  MessageData.h
//  VideoShare
//
//  Created by tangyx on 13-6-26.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "BaseData.h"

@interface MessageData : BaseData
@property(nonatomic,strong)NSString* server_time;       //服务器时间
@property(nonatomic,strong)NSString* last_timemilli;
@property(nonatomic,strong)NSString* hasnextpage;
@property(nonatomic,strong)NSArray* users;
@property(nonatomic,strong)NSString *attentionnum;
@property(nonatomic,strong)NSString *fansnum;
@property(nonatomic,strong)NSMutableArray *diaries;
@property(nonatomic,strong)NSString* commentnum;
@property(nonatomic,strong)NSString* commentid;
@end
