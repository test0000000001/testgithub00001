//
//  LLShareTask.h
//  VideoShare
//
//  Created by tangyx on 13-6-19.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLTaskBase.h"
#import "LLDaoModelDiary.h"




//lookShortUrl(looklook分享短链接),content(用户输入的内容）,targetUserIds(类型私信好友列表),targetTCUserIds(类型腾讯好友列表）,targetSINAUserIds(类型新浪好友列表）,targetRenRenUserIds(类型人人好友列表）,isShareTc(是否发布到腾讯微博，y：发 n：否）,isShareSina(是否发布到新浪微博，y：发 n：否）,isShareRenRen(是否发布到人人微博，y：发 n：否）,isShareSiXin(是否发送私信，y：发 n：否）,userid(用户ID）
@interface LLShareTaskInfo : NSObject

@property(nonatomic,strong)NSString* diaryuuid;           // *

@property(nonatomic,strong)NSString* privatemsgtype;      // *
@property(nonatomic,strong)NSString* userid;              // *
@property(nonatomic,strong)NSString* lookShortUrl;        // 废弃
@property(nonatomic,strong)NSString* content;             // *
@property(nonatomic,strong)NSString* targetUserIds;       // *私信 isShareSiXin为y的时候
@property(nonatomic,strong)NSString* targetTCUserIds;     // *腾讯isShareTc为y的时候
@property(nonatomic,strong)NSString* targetSINAUserIds;   // *新浪isShareSina为y的时候
@property(nonatomic,strong)NSString* targetRenRenUserIds; // *人人isShareRenRen为y的时候
@property(nonatomic,strong)NSString* isShareTc;           // *是否发布到腾讯微博，y：发 n：否
@property(nonatomic,strong)NSString* isShareSina;         // *(是否发布到新浪微博，y：发 n：否
@property(nonatomic,strong)NSString* isShareRenRen;       // *是否发布到人人微博，y：发 n：否
@property(nonatomic,strong)NSString* isShareSiXin;        // *是否发送私信，y：发 n：否
@property(nonatomic,strong)NSString* position; //分享位置，base64编码,可能为空
@property(nonatomic,strong)NSString* longitude;//分享经度，可能为空
@property(nonatomic,strong)NSString* latitude;//分享纬度可能为空
@property(nonatomic,strong)NSString* isReport;//内部字段，是否将分享轨迹记录到服务器

@property(nonatomic,strong)NSString* diaryid;//内部字段，内部会根据diaryuuid获取
@property(nonatomic,strong)NSString* tcweiboid;//内部字段 腾讯微博id，分享成功后返回
@property(nonatomic,strong)NSString* sinaweiboid;//内部字段 sinaid，分享成功后返回
@property(nonatomic,strong)NSString* renrenweiboid;//内部字段 renren id，分享成功后返回
@property(nonatomic,strong)NSString* tcShareUrl;//内部字段 腾讯分享链接
@property(nonatomic,strong)NSString* sinaShareUrl;//内部字段 sina分享链接
@property(nonatomic,strong)NSString* renRenShareUrl;//内部字段 人人分享链接
@property(nonatomic,strong)NSString* siXinShareUrl;//内部字段 looklook分享链接
@property(nonatomic,strong)NSString* shareimageurl;//分享图片地址
@property(nonatomic,strong)NSString* tcsnsid;//内部字段 腾讯微博用户id
@property(nonatomic,strong)NSString* sinasnsid;//内部字段sina微博用户id
@property(nonatomic,strong)NSString* renrensnsid;//内部字段sina微博用户id
@property(nonatomic,strong)NSString* privateMessageIds;//私信消息id列表，@“，”隔开
@end

@interface LLShareTask : LLTaskBase

@end
