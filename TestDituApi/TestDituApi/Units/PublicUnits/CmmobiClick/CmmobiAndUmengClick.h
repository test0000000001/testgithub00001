//
//  CmmobiAndUmengClick.h
//  VideoShare
//  统一umeng和cmmobi两个统计工具
//  Created by wan liming on 8/5/13.
//  Copyright (c) 2013 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmmobiClickAgent.h"
#import "MobClick.h"

@interface CmmobiAndUmengClick : NSObject
+(void)startAppClick; //启动
+(void)startClickLog:(BOOL)open; //开启log

//统计方法－start
+ (void)logPageView:(NSString *)pageName seconds:(int)seconds;  //纪录当前view的时间，手动
+ (void)beginLogPageView:(NSString *)pageName;                  //纪录当前viewpage的时间－开始
+ (void)endLogPageView:(NSString *)pageName;                    //纪录当前viewpage的时间－结束

//带eventid 埋点
//次数统计－－start  //可自动统计也可以手动统计
+ (void)event:(NSString *)eventId; //不带参数
+ (void)event:(NSString *)eventId label:(NSString *)label; //带一个参数
+ (void)event:(NSString *)eventId acc:(NSInteger)accumulation; //自行统计触发次数
+ (void)event:(NSString *)eventId label:(NSString *)label acc:(NSInteger)accumulation; //一个参数加自行统计
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes; //多参数
//次数统计－－end

//时长统计－－ start //可自动统计也可以手动统计
+ (void)beginEvent:(NSString *)eventId;
+ (void)endEvent:(NSString *)eventId;
+ (void)beginEvent:(NSString *)eventId label:(NSString *)label;
+ (void)endEvent:(NSString *)eventId label:(NSString *)label;
+ (void)event:(NSString *)eventId durations:(int)millisecond;
+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond;

//时长统计－－ end


//经纬度
+ (void)setLatitude:(double)latitude longitude:(double)longitude;

//openUUID
+ (NSString*)getOpenUDID;

//统计方法－end

@end
