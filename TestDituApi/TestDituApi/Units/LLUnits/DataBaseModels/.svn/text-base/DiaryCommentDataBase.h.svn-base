//
//  DiaryCommentDataBase.h
//  VideoShare
//
//  Created by capry on 13-6-18.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentListModel.h"

@interface ReplyedUserInfo : NSObject

@property (nonatomic, strong) NSString *userid;           // 评论用户ID
@property (nonatomic, strong) NSString *headimageurl;     // 头像URL
@property (nonatomic, strong) NSString *nickname;         // 昵称
@property (nonatomic, strong) NSString *commentcontent;   // 评论
@property (nonatomic, strong) NSString *commentid;        // 回复那条评论ID，当前
@property (nonatomic, strong) NSString *createtime;       // 时间戳
@property (nonatomic, strong) NSString *signature;        // 是编码的，需要解码
@property (nonatomic, strong) NSString *sex;              // 0男，1女， 2未知
@property (nonatomic, strong) NSString *isattention;      // 0 未关注  1是已关注
@property (nonatomic, strong) NSString *audiourl;         // 语音地址
@property (nonatomic, strong) NSString *playtime;         // 语音播放时长

@end

@interface DiaryCommentDataBase : LLDaoModelBase
@property (nonatomic, strong) NSString *diaryCommentKey;//主键
@property (nonatomic, strong) NSString *userid;         // 评论用户ID
@property (nonatomic, strong) NSString *headimageurl;   // …jpg",//头像URL
@property (nonatomic, strong) NSString *nickname;       // 昵称
@property (nonatomic, strong) NSString *diaryid;        // 日记ID
@property (nonatomic, strong) NSString *commentcontent; // 评论
@property (nonatomic, strong) NSString *commentid;      // 评论ID
//@property (nonatomic, strong) NSString *localCommentid; // 本地生成得评论ID
@property (nonatomic, strong) NSString *commentuuid;    // 本地生成得评论ID
@property (nonatomic, strong) NSString *createtime;     // 时间戳
@property (nonatomic, strong) NSString *signature;      // 是编码的，需要解码
@property (nonatomic, strong) NSString *sex;            // 0男，1女， 2未知
@property (nonatomic, strong) NSString *isattention;    // 0 未关注  1是已关注
@property (nonatomic, strong) NSString *audiourl;       // 语音地址
@property (nonatomic, strong) NSString *commentway;     // 评论方式1、文字 2、声音3、声音加文字
@property (nonatomic, strong) NSString *commenttype;    // 评论类型：1、评论 2回复
@property (nonatomic, strong) NSString *isLocalComment; // 是否是本地尚未提交的评论y、服务器尚未接收 空或者其他值、服务器已经接收
@property (nonatomic, strong) NSString *playtime;       // 语音播放时长
@property (nonatomic, strong) ReplyedUserInfo *replycomment; // 回复userinfo
@property (nonatomic, assign) int taskId;               // 任务id
@property (nonatomic, assign) int changeInfoTaskId;     // 更改评论任务id
@property (nonatomic, strong) CommentInfoListCell* thirdPartCommentCell;
@end
