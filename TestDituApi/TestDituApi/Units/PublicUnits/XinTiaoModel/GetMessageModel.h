//
//  GetMessageModel.h
//  VideoShare
//
//  Created by tangyx on 13-6-26.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "BaseModelWithRIARequestLib.h"



@interface GetMessageModel : BaseModelWithRIARequestLib
{
    @private
        NSTimeInterval errorTimeValue;                   // 本机时间与系统时间的差值
}
//获取评论数
+(int)getCommentnum;
/**
 * 功能：开启获取消息心跳
 * 参数：(NSString *)userId
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-05-24
 */
+(void) startGetMessage;

/**
 * 功能：停止获取消息心跳
 * 参数：(NSString *)userId
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-05-24
 */
+(void) stopGetMessage;

/**
 * 功能：获取系统当前时间
 * 参数：无
 * 返回值：当前系统时间（规则： 1 如果抓到了系统时间则计算差值并记住差值，本机时间和差值相加后返回，
 2 如果没抓到系统时间则返回本机时间）
 
 * 创建者：capry chen
 * 创建日期：2013-05-23
 */
+(NSString *) getSystemCurrentTime;

/**
 * 功能：获取系统当前时间(微秒级别）
 * 参数：无
 * 返回值：当前系统时间（规则： 1 如果抓到了系统时间则计算差值并记住差值，本机时间和差值相加后返回，
 2 如果没抓到系统时间则返回本机时间）
 
 * 创建者：capry chen
 * 创建日期：2013-05-23
 */
+(NSString *) getSystemCurrentTimeMilli;

@end
