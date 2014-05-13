//
//  GetNetworkInfoModel.h
//  VideoShare
//
//  Created by capry on 13-5-20.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NETWORK_NOT_AVAILABLE = 0,            // 当前无可用网络
    NETWORK_WIFI = 1,                     // 当前网络为Wi-Fi信号
    NETWORK_2G = 2,                       // 当前网络为2g信号
    NETWORK_3G = 3,                       // 当前网络为3g信号
    NETWORK_OTHER = 4                     // 当前网络为其他信号
} NETWORK_TYPE;

@interface GetNetworkInfoModel : NSObject

/**
 * 功能：获取当前网络状态
 * 参数：无
 * 返回值：NETWORK_TYPE
 
 * 创建者：capry chen
 * 创建日期：2013-05-20
 */
+ (NETWORK_TYPE )getNetworkType;
@end
