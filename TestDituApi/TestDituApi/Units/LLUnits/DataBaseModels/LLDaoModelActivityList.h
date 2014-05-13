//
//  LLDaoModelActivityList.h
//  VideoShare
//
//  Created by wan liming on 6/23/13.
//  Copyright (c) 2013 cmmobi. All rights reserved.
//

#import "LLDaoModelBase.h"
#import "DiaryData.h"

//日记数据 纪录一个diaryid用来查询和管理
@interface LLDaoModelActivityDiaryCell:NSObject
@property (nonatomic, strong) NSString *d_diaryid;             // 日记ID， 包括活动和中奖的日记id
@end


//中奖日记列表
@interface LLDaoModelActivityAwardCell:NSObject
@property (nonatomic,strong) NSString* awardid;                //获奖id
@property (nonatomic,strong) NSString* awardname;              //奖项名称
@property (nonatomic,strong) NSMutableArray* diaryAwardArray;  //获奖日记列表，对应LLDaoModelDiaryCell
@end


//参加活动日记列表
@interface LLDaoModelActivityJoinedCell:NSObject
@property (nonatomic,strong) NSMutableArray* diaryJoinedArray;  //参加活动日记列表，对应LLDaoModelDiaryCell
@end



@interface LLDaoModelActivityList : LLDaoModelBase
@property (nonatomic,strong)  NSString* userKey;              //根据活动id和diaryid建力联合主键
@property (nonatomic, strong) NSString *diaryid;             // 日记id
@property (nonatomic, strong) NSString *activeid;             // 活动id
@property (nonatomic, strong) NSString *activename;           // 活动名称
@property (nonatomic, strong) NSString *starttime;            // 开始时间
@property (nonatomic, strong) NSString *endtime;              // 结束时间
@property (nonatomic, strong) NSString *introduction;         // 活动简介
@property (nonatomic, strong) NSString *add_way;              // 参与方式
@property (nonatomic, strong) NSString *rule;                 // 规则
@property (nonatomic, strong) NSString *prize;                // 奖品
@property (nonatomic, strong) NSString *picture;              // 活动图片       /////这里服务器返回的是错误字段，
@property (nonatomic, strong) NSString *isjoin;               // 1代表参加， 0代表未参加
@property (nonatomic, strong) NSString *iseffective;          // 1结束，2未开始，0可以参加

@property (nonatomic, strong) NSMutableArray *joinedDiaryArray; // 参加活动日记列表

@property (nonatomic, strong) NSMutableArray *awardedDiaryArray; //中奖日记列表
@end
