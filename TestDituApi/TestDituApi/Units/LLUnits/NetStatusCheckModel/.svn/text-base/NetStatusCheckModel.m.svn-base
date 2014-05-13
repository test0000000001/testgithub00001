//
//  NetStatusCheckModel.m
//  VideoShare
//
//  Created by zengchao on 13-1-31.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "NetStatusCheckModel.h"
#import "Tools.h"
#import "GetNetworkInfoModel.h"
#import "LLDefines.h"
#import "LLFreeTaskManager.h"
#import "Reachability.h"

@interface NetStatusCheckModel ()
{
    
}
@property(nonatomic,assign) BOOL netStatus;//可用，不可用
@property(nonatomic,strong) Reachability* reachability;
@end


@implementation NetStatusCheckModel

static id SharedInstance;
//管理器单例
+(NetStatusCheckModel *)sharedNetStatusCheckModel
{
    @synchronized(SharedInstance)
    {
        if (!SharedInstance)
        {
            SharedInstance=[[self alloc]init];
        }
    }
    return SharedInstance;
}
-(id)init
{
    if (self=[super init]) {
        if([GetNetworkInfoModel getNetworkType] == NETWORK_NOT_AVAILABLE)
        {
            self.netStatus = NO;
        }
        else
        {
            self.netStatus = YES;
        }
        self.reachability = [Reachability reachabilityForInternetConnection];
        [_reachability startNotifier];
        [[NSNotificationCenter defaultCenter]
         addObserver: self
         selector: @selector(inetAvailabilityChanged:)
         name:  kReachabilityChangedNotification
         object: _reachability];
    }
    return self;
}

-(void)inetAvailabilityChanged:(NSNotification *)notice {
    if (notice.object == _reachability) {
        if (!STR_IS_NIL(APP_USERID)) {
            if([GetNetworkInfoModel getNetworkType] == NETWORK_NOT_AVAILABLE && _netStatus == YES)
            {
                self.netStatus = NO;
                //可用－－－》不可用
                [[LLFreeTaskManager sharedLLFreeTaskManager] stopTask];
                [[LLFreeTaskManager sharedLLFreeTaskManager] reSetAllTaskAlive];
                [[LLFreeTaskManager sharedLLFreeTaskManager] reSetTasksFromDataBase];
                [[LLFreeTaskManager sharedLLFreeTaskManager] stopTask];
                
            }
            else if([GetNetworkInfoModel getNetworkType] != NETWORK_NOT_AVAILABLE && _netStatus == NO)
            {
                self.netStatus = YES;
                //不可用－－－》可用
                [[LLFreeTaskManager sharedLLFreeTaskManager] stopTask];
                [[LLFreeTaskManager sharedLLFreeTaskManager] reSetAllTaskAlive];
                [[LLFreeTaskManager sharedLLFreeTaskManager] reSetTasksFromDataBase];
                [[LLFreeTaskManager sharedLLFreeTaskManager] startTask];
            }
        }
    }
}

//单例销毁
-(void)attemptDealloc
{
    SharedInstance = nil;
}

@end
