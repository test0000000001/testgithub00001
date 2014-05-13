//
//  GetMessageModel.m
//  VideoShare
//
//  Created by tangyx on 13-6-26.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "GetMessageModel.h"
#import "MessageData.h"
#import "LLUserDefaults.h"
#import "MessageUserListModelBase.h"
#import "LLDaoModelPrivateMessage.h"
#import "LLDaoBase.h"

#define HEARTPRESSTIME 30


@interface GetMessageModel (){
    
}
@property (nonatomic,assign) NSTimeInterval errorTimeValue; // 本机时间与系统时间的差值

/**
 * 功能：获取消息
 * 参数：(NSString *)userId
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-05-24
 */
-(void) getMessage;

/**
 * 功能：开启定时器
 * 参数：无
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-05-24
 */
-(void) startTimerToGet;

/**
 * 功能：暂停定时器
 * 参数：无
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-05-24
 */
-(void) pauseTimer;

/**
 * 功能：计算系统时间与服务器时间的差值
 * 参数：(NSString *)serverTime 系统时间
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-27
 */
- (void) calculateErrortime:(NSString *)serverTime;

/**
 * 功能：获取当前准确时间
 * 参数：无
 * 返回值：返回一个当前时间的字符串
 
 * 创建者：capry chen
 * 创建日期：2013-06-27
 */
- (NSString *) getCorrectTime;

@end
static GetMessageModel *getInstace;
@implementation GetMessageModel
@synthesize errorTimeValue;
/**
 * 功能：进入私信聊天页时候要在这里注册一下，然后此处开始心跳每隔一定时间来抓取聊天记录
 * 参数：(NSString *)userId
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-05-24
 */
+(id) shareInstace
{
    @synchronized(getInstace)
    {
        if (!getInstace)
        {
            getInstace = [[GetMessageModel alloc] init];
        }
    }
    return getInstace;
}




/**
 * 功能：获取与当前好友的聊天信息
 * 参数：(NSString *)userId
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-05-24
 */
-(void) getMessage
{
    NSString* timemilli = [LLUserDefaults getValueWithKey:MESSAGEDATA_LASTTIMEILLI];
    NSString* commentid = [LLUserDefaults getValueWithKey:USERDEFAULTKEY_COMMENTID];
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setValue:APP_USERID forKey:@"userid"];
    [parameterDic setValue:@"50" forKey:@"pagesize"];
    //空是全查或0.1私信，2活动，3推荐，4附近，5陌生人6LOOKLOOK官方
    [parameterDic setValue:@"0" forKey:@"messagetype"];
    
    [parameterDic setValue:timemilli==nil?@"":timemilli forKey:@"timemilli"];
    [parameterDic setValue:UN_NIL(commentid) forKey:@"commentid"];
    NSString* diarys = [self checkUploadedAndNotSynchronizedDiarys];
    [parameterDic setValue:diarys forKey:@"diaryids"];
    
    RequestModel *requestModel = [[RequestModel alloc] initWithUrl:USER_LISTMESSAGE_URL params:parameterDic];
    
    [_webRequestLib fetchDataFromNet:requestModel
                      dataModelClass:[MessageData class] mainBlock:^(BaseData *responseData) {
                          MessageData* messageData = (MessageData*)responseData;
                          if(messageData.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS){
                              [self checkSynchronizationDiarys:messageData.diaries];
//                              int attentioncount = [[LLUserDefaults getValueWithKey:TOTAL_ATTENTION_COUNT] intValue];
//                              if ([messageData.attentioncount intValue] != attentioncount) {
//                                  NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:messageData.attentioncount,@"attentioncount", nil];
//                                  [[NSNotificationCenter defaultCenter] postNotificationName:BROADCAST_ATTENTION_COUNT_CHANGED object:self userInfo:dic];
//                              }
                              int fanscount = [[LLUserDefaults getValueWithKey:TOTAL_FANS_COUNT] intValue];
                              if ([messageData.fansnum intValue] != fanscount) {
                                  NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:messageData.fansnum,@"fanscount", nil];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:BROADCAST_FANS_COUNT_CHANGED object:self userInfo:dic];
                              }
                              if(messageData.commentid.length > 0){
                                  [LLUserDefaults setValue:messageData.commentid forKey:USERDEFAULTKEY_COMMENTID];
                              }
                              [GetMessageModel addCommentnum:messageData.commentnum.intValue];
                              // 计算本地时间与系统时间的差额
                              NSString *serverTime = messageData.server_time;
                              [self calculateErrortime:serverTime];
                              if([messageData.users count]>0){
                                   [LLUserDefaults setValue:messageData.last_timemilli forKey:MESSAGEDATA_LASTTIMEILLI]; 
                                  for(MessageUserListModelBase* userExpandModel in messageData.users){
                                      __block MessageUserListModelBase* locationModel = nil;
                                      
                                      //查询数据历史记录
                                      [[LLDAOBase shardLLDAOBase]searchAll:userExpandModel dic:[NSDictionary dictionaryWithObjectsAndKeys:userExpandModel.userid,userExpandModel.primaryKey, nil] callback:^(NSArray* array){
                                          if([array count]>0){
                                              locationModel = [array objectAtIndex:0];
                                          }
                                      }];
                                      //更新本地的每条信息的未读数量
                                      if(locationModel){
//                                          userExpandModel.count = [NSString stringWithFormat:@"%i",locationModel.count.intValue+[userExpandModel.message count]];

                                      }else{
//                                          userExpandModel.count = [NSString stringWithFormat:@"%i",[userExpandModel.message count]];
                                      }


//                                      NSArray *messageArray = userExpandModel.message;
//                                      
//                                      userExpandModel.message = messageArray;
                                      [[LLDAOBase shardLLDAOBase]updateInsertToDBFromArray:userExpandModel.message callback:nil];
                                      
                                      userExpandModel.message = [NSArray array];
                                      [[LLDAOBase shardLLDAOBase]updateInsertToDB:userExpandModel callback:nil];
                                     
                                  }
                              }  
                          }
                          if(isHeartEnable){
                              [self performSelector:@selector(getMessage) withObject:nil afterDelay:[messageData.hasnextpage isEqualToString:@"1" ]?0:HEARTPRESSTIME];
                          }
                      }];
}
+(int)getCommentnum{
    return [[LLUserDefaults getValueWithKey:USERDEFAULTKEY_COMMENTNUM]intValue];
}
+(void)addCommentnum:(int)num{
    if(num == 0){
        return;
    }
    [LLUserDefaults setValue:[NSString stringWithFormat:@"%i",[GetMessageModel getCommentnum]+num] forKey:USERDEFAULTKEY_COMMENTNUM];
    [[NSNotificationCenter defaultCenter]postNotificationName:BROADCAST_COMMENTNUM_CHANGE object:nil];
}
/**
 * 功能：开启定时器
 * 参数：无
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-05-24
 */
-(void) startTimerToGet
{
    isHeartEnable = YES;
    [self getMessage];
}

/**
 * 功能：暂停定时器
 * 参数：无
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-05-24
 */
-(void) pauseTimer
{
    isHeartEnable = NO;
    // 去除之前得所有预约
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getMessage) object:nil];
}

static BOOL isHeartEnable;

+(void) startGetMessage{
    [GetMessageModel stopGetMessage];//先移除获取消息心跳
    if(!STR_IS_NIL(APP_USERID)){
        [[GetMessageModel shareInstace]startTimerToGet];
    }

}


+(void) stopGetMessage;{
    [[GetMessageModel shareInstace] pauseTimer];
}

/**
 * 功能：获取系统当前时间
 * 参数：无
 * 返回值：当前系统时间（规则： 1 如果抓到了系统时间则计算差值并记住差值，本机时间和差值相加后返回，
 2 如果没抓到系统时间则返回本机时间）
 
 * 创建者：capry chen
 * 创建日期：2013-05-23
 */
+(NSString *) getSystemCurrentTime
{
    NSString *currentDate;
    if (getInstace)
    {
        currentDate = [getInstace getCorrectTime];
    }
    else
    {
        //        NSDate *nowDate = [NSDate new];
        //        NSDateFormatter *formatter    =  [[NSDateFormatter alloc] init];
        //        [formatter    setDateFormat:@"YY-MM-dd HH:mm:ss ms"];
        //        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
        //        currentDate = [formatter stringFromDate:nowDate];
        NSNumber *number = [NSNumber numberWithDouble:(long long)([[NSDate date]timeIntervalSince1970]*1000)];
        currentDate = [number stringValue];
    }
    
    return currentDate;
}

/**
 * 功能：获取系统当前时间(微秒级别）
 * 参数：无
 * 返回值：当前系统时间（规则： 1 如果抓到了系统时间则计算差值并记住差值，本机时间和差值相加后返回，
 2 如果没抓到系统时间则返回本机时间）
 
 * 创建者：capry chen
 * 创建日期：2013-05-23
 */
+(NSString *) getSystemCurrentTimeMilli
{
    NSString *currentDate;
    if (getInstace)
    {
        NSNumber *number = [NSNumber numberWithDouble:[[getInstace getCorrectTimemilli] doubleValue]*1000];
        currentDate = [number stringValue];
    }
    else
    {
        //        NSDate *nowDate = [NSDate new];
        //        NSDateFormatter *formatter    =  [[NSDateFormatter alloc] init];
        //        [formatter    setDateFormat:@"YY-MM-dd HH:mm:ss ms"];
        //        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
        //        currentDate = [formatter stringFromDate:nowDate];
        NSNumber *number = [NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]*1000];
        currentDate = [number stringValue];
    }
    
    return currentDate;
}

/**
 * 功能：计算系统时间与服务器时间的差值
 * 参数：(NSString *)serverTime 系统时间
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-27
 */
- (void) calculateErrortime:(NSString *)serverTime
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YY-MM-dd HH:mm:ss ms"];
//    NSDate *date = [formatter dateFromString:serverTime];

//    self.errorTimeValue = [date timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970];
    if (!STR_IS_NIL(serverTime) ) {
        if (serverTime.length != 13) {
            return;
        }
    }
    self.errorTimeValue = serverTime.doubleValue/1000.0 - [[NSDate date]timeIntervalSince1970];
    
    [GetMessageModel getSystemCurrentTime];
}


/**
 * 功能：获取当前准确时间
 * 参数：无
 * 返回值：返回一个当前时间的字符串
 
 * 创建者：capry chen
 * 创建日期：2013-06-27
 */
- (NSString *) getCorrectTime
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval currentTimeSine1970 = [currentDate timeIntervalSince1970];
    NSTimeInterval correctTimeSine1970 = currentTimeSine1970 + self.errorTimeValue;
    //    NSDate *correctDate = [NSDate dateWithTimeIntervalSince1970:correctTimeSine1970];
    //
    //    NSString *correctDateStr = @"";
    //    NSDateFormatter *formatter    =  [[NSDateFormatter alloc] init];
    //    [formatter    setDateFormat:@"YY-MM-dd HH:mm:ss ms"];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    //    correctDateStr = [formatter stringFromDate:correctDate];
    NSNumber *number = [NSNumber numberWithDouble:(long long)(correctTimeSine1970*1000)];
    NSString *correctDateStr = [number stringValue];
    
    return correctDateStr;
}

/**
 * 功能：获取当前准确时间
 * 参数：无
 * 返回值：返回一个当前时间的字符串
 
 * 创建者：capry chen
 * 创建日期：2013-06-27
 */
- (NSString *) getCorrectTimemilli
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval currentTimeSine1970 = [currentDate timeIntervalSince1970];
    NSTimeInterval correctTimeSine1970 = currentTimeSine1970 + self.errorTimeValue;
    //    NSDate *correctDate = [NSDate dateWithTimeIntervalSince1970:correctTimeSine1970];
    //
    //    NSString *correctDateStr = @"";
    //    NSDateFormatter *formatter    =  [[NSDateFormatter alloc] init];
    //    [formatter    setDateFormat:@"YY-MM-dd HH:mm:ss ms"];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    //    correctDateStr = [formatter stringFromDate:correctDate];
    NSNumber *number = [NSNumber numberWithDouble:correctTimeSine1970];
    NSString *correctDateStr = [number stringValue];
    
    return correctDateStr;
}

-(void)checkSynchronizationDiarys:(NSMutableArray*)array
{
    if (array.count > 0)
    {
        [Tools isDiaryDataUpdate:array];
    }
}

-(NSString*)checkUploadedAndNotSynchronizedDiarys
{
    __block NSString* result = @"";
    [[LLDAOBase shardLLDAOBase] searchWhere:[[LLDaoModelDiary alloc] init]
                                     String:[NSString stringWithFormat:@"userid = \'%@\' AND synchronization_status = \'%@\' AND upload_status = \'%@\'", APP_USERID ,@"0",@"-3"]
                                    orderBy:@"CAST(updatetimemilli AS double)"
                                        asc:NO
                                     offset:0
                                      count:-1
                                   callback:^(NSArray *resultArray)
     {
         for (LLDaoModelDiary* cell in resultArray) {
             if (!STR_IS_NIL(cell.diaryid)) {
                 if (!STR_IS_NIL(result)) {
                     result = [result stringByAppendingFormat:@"%@",@","];
                 }
                 result = [result stringByAppendingFormat:@"%@",cell.diaryid];
             }
         }
     }];
    NSLog(@"查到已上传并且未同步的视频,%@",result);
    return result;
}
@end
