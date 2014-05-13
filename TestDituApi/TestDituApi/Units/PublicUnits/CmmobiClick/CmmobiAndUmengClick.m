//
//  CmmobiAndUmengClick.m
//  VideoShare
//
//  Created by wan liming on 8/5/13.
//  Copyright (c) 2013 cmmobi. All rights reserved.
//

#import "CmmobiAndUmengClick.h"

@implementation CmmobiAndUmengClick

//启动统计工具

+(void)startAppClick
{
    [MobClick startWithAppkey:@"50383bfb5270154b560000d9"];
    [MobClick setCrashReportEnabled:NO];
    [CmmobiClickAgent startWithAppkey:@"3" channelId:@"looklook" sdkType:SDKType_Iphone];
}




//打开log, 只针对cmmobiclickagent统计工具
+(void)startClickLog:(BOOL)open
{
    [CmmobiClickAgent setLogEnabled:open];
    [MobClick setLogEnabled:open];
}



//统计方法－start
+ (void)logPageView:(NSString *)pageName seconds:(int)seconds
{
//    [CmmobiClickAgent logPageView:pageName seconds:seconds];
//    [MobClick logPageView:pageName seconds:seconds];
}

+ (void)beginLogPageView:(NSString *)pageName
{
//    [CmmobiClickAgent beginLogPageView:pageName];
//    [MobClick beginLogPageView:pageName];
}

+ (void)endLogPageView:(NSString *)pageName
{
//    [CmmobiClickAgent endLogPageView:pageName];
//    [MobClick endLogPageView:pageName];
}



//带eventid 埋点
//次数统计－－start  //可自动统计也可以手动统计
+ (void)event:(NSString *)eventId
{
//    [CmmobiClickAgent event:eventId];
//    [MobClick event:eventId];
}

+ (void)event:(NSString *)eventId label:(NSString *)label
{
//    [CmmobiClickAgent event:eventId label:label];
//    [MobClick event:eventId label:label];
}

+ (void)event:(NSString *)eventId acc:(NSInteger)accumulation
{
//    [CmmobiClickAgent event:eventId acc:accumulation];
//    [MobClick event:eventId acc:accumulation];
}

+ (void)event:(NSString *)eventId label:(NSString *)label acc:(NSInteger)accumulation
{
//    [CmmobiClickAgent event:eventId label:label acc:accumulation];
//    [MobClick event:eventId label:label acc:accumulation];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes
{
//    [CmmobiClickAgent event:eventId attributes:attributes];
//    [MobClick event:eventId attributes:attributes];
}

//次数统计－－end

//时长统计－－ start //可自动统计也可以手动统计
+ (void)beginEvent:(NSString *)eventId
{
//    [CmmobiClickAgent beginEvent:eventId];
//    [MobClick beginEvent:eventId];
}

+ (void)endEvent:(NSString *)eventId
{
//    [CmmobiClickAgent endEvent:eventId];
//    [MobClick endEvent:eventId];
}

+ (void)beginEvent:(NSString *)eventId label:(NSString *)label
{
//    [CmmobiClickAgent beginEvent:eventId label:label];
//    [MobClick beginEvent:eventId label:label];
}

+ (void)endEvent:(NSString *)eventId label:(NSString *)label
{
//    [CmmobiClickAgent endEvent:eventId label:label];
//    [MobClick endEvent:eventId label:label];
}
+ (void)event:(NSString *)eventId durations:(int)millisecond
{
//    [CmmobiClickAgent event:eventId durations:millisecond];
//    [MobClick event:eventId durations:millisecond];
}

+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond
{
//    [CmmobiClickAgent event:eventId label:label durations:millisecond];
//    [MobClick event:eventId label:label durations:millisecond];
}
//时长统计－－ end



//经纬度
+ (void)setLatitude:(double)latitude longitude:(double)longitude
{
//    [CmmobiClickAgent setLatitude:latitude longitude:longitude];
//    [MobClick setLatitude:latitude longitude:longitude];
}
//统计方法－end
@end
