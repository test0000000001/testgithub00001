//
//  GetNetworkInfoModel.m
//  VideoShare
//
//  Created by capry on 13-5-20.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "Reachability.h"

#import "GetNetworkInfoModel.h"

@implementation GetNetworkInfoModel

/**
 * 功能：获取当前网络状态
 * 参数：无
 * 返回值：NETWORK_TYPE
 
 * 创建者：capry chen
 * 创建日期：2013-05-20
 */
+ (NETWORK_TYPE )getNetworkType
{
    NETWORK_TYPE type = NETWORK_NOT_AVAILABLE;
    
    struct sockaddr_in nullAddress;
    bzero(&nullAddress, sizeof(nullAddress));
    nullAddress.sin_len = sizeof(nullAddress);
    nullAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*) &nullAddress);
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(ref, &flags);
    
    NetworkStatus status = [GetNetworkInfoModel networkStatusForFlags:flags];
    switch (status)
    {
        case NotReachable:
            type = NETWORK_NOT_AVAILABLE;
            break;
        case ReachableViaWiFi:
            type = NETWORK_WIFI;
            break;
        case ReachableViaWWAN:
        {
            type = NETWORK_3G;

            if((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable)
            {
                if((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection)
                {
                    if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired)
                    {
                        type = NETWORK_2G;
                    }
                }
            }
        }
            break;
        default:
            type = NETWORK_OTHER;
            break;
    }

    return type;
}


/**
 * 功能：获取当前网络状态
 * 参数：无
 * 返回值：NetworkStatus
 
 * 创建者：capry chen
 * 创建日期：2013-05-20
 */
+ (NetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags
{
	if (flags & kSCNetworkReachabilityFlagsReachable)
    {
		if (flags & kSCNetworkReachabilityFlagsIsWWAN)
        {
            return kReachableViaWWAN;
        }
        
		flags &= ~kSCNetworkReachabilityFlagsReachable;
		flags &= ~kSCNetworkReachabilityFlagsIsDirect;
		flags &= ~kSCNetworkReachabilityFlagsIsLocalAddress;
        
		if (flags == (kSCNetworkReachabilityFlagsConnectionRequired |
                      kSCNetworkReachabilityFlagsTransientConnection))
        
        {
            return kNotReachable;
        }
        
		if (flags & kSCNetworkReachabilityFlagsTransientConnection)
        {
            return kReachableViaWiFi;
        }
        
		if (flags == 0)
        {
            return kReachableViaWiFi;
        }
        
		if (flags & kSCNetworkReachabilityFlagsConnectionRequired)
        {
            return kReachableViaWiFi;
        }
		return kNotReachable;
        
    }
    
	return kNotReachable;
} 


@end
