//
//  NetTaskCheckModel.m
//  VideoShare
//
//  Created by zengchao on 13-1-31.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "NetTaskCheckModel.h"
#import "Tools.h"
#import "LLTaskManager.h"
#import "GetNetworkInfoModel.h"
#import "LLDefines.h"
#import "Reachability.h"

@interface NetTaskCheckModel ()
{
    
}
@property(nonatomic,strong) Reachability* reachability;
@end


@implementation NetTaskCheckModel




static id SharedInstance;
//管理器单例
+(NetTaskCheckModel *)sharedNetTaskCheckModel
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
        self.reachability = [Reachability reachabilityForInternetConnection];
        [_reachability startNotifier];
        [[NSNotificationCenter defaultCenter]
         addObserver: self
         selector: @selector(inetAvailabilityChanged:)
         name:  kReachabilityChangedNotification
         object: _reachability];
        
        [self networkTruenRound];
    }
    return self;
}

-(void)inetAvailabilityChanged:(NSNotification *)notice
{
    if (notice.object == _reachability) {
        if (!STR_IS_NIL(APP_USERID)) {
            if ([APP_SYSC_TYPE isEqualToString:@"2"]) {//2仅WIFI
                if ([GetNetworkInfoModel getNetworkType] == NETWORK_WIFI) {
                    //启动任务
                    if ([LLTaskManager sharedLLTaskManager].taskListAlive == NO) {
                        [[LLTaskManager sharedLLTaskManager] stopTask];
                    }
                    [[LLTaskManager sharedLLTaskManager] reSetAllTaskAlive];
                    [LLTaskManager sharedLLTaskManager].taskListAlive = YES;
                    [[LLTaskManager sharedLLTaskManager] reSetTasksFromDataBase];
                    
                    [[LLTaskManager sharedLLTaskManager] startTask];
                }
                else
                {
                    //停止任务
                    /*if ([LLTaskManager sharedLLTaskManager].taskListAlive == YES)
                    {
                        [[LLTaskManager sharedLLTaskManager] stopTask];
                    }*/
                    [[LLTaskManager sharedLLTaskManager] reSetAllTaskSleep];
                    [[LLTaskManager sharedLLTaskManager] stopTask];
                    
                    [LLTaskManager sharedLLTaskManager].taskListAlive = NO;
                    [[LLTaskManager sharedLLTaskManager] reSetTasksFromDataBase];
                }
            }
            else//3任何网络
            {
                if([GetNetworkInfoModel getNetworkType] != NETWORK_NOT_AVAILABLE)
                {
                    //启动任务
                    if ([LLTaskManager sharedLLTaskManager].taskListAlive == NO)
                    {
                        [[LLTaskManager sharedLLTaskManager] stopTask];
                    }
                    [[LLTaskManager sharedLLTaskManager] reSetAllTaskAlive];
                    [LLTaskManager sharedLLTaskManager].taskListAlive = YES;
                    [[LLTaskManager sharedLLTaskManager] reSetTasksFromDataBase];
                    
                    [[LLTaskManager sharedLLTaskManager] startTask];
                    
                }
                else
                {
                    //停止任务
                    /*if ([LLTaskManager sharedLLTaskManager].taskListAlive == YES)
                    {
                        [[LLTaskManager sharedLLTaskManager] stopTask];
                    }*/
                    [[LLTaskManager sharedLLTaskManager] reSetAllTaskSleep];
                    [[LLTaskManager sharedLLTaskManager] stopTask];
                    
                    [LLTaskManager sharedLLTaskManager].taskListAlive = NO;
                    [[LLTaskManager sharedLLTaskManager] reSetTasksFromDataBase];
                }
            }
        }
    }
}

- (void)networkTruenRound {
    
    if ([APP_SYSC_TYPE isEqualToString:@"2"]) {//2仅WIFI
        if ([GetNetworkInfoModel getNetworkType] == NETWORK_WIFI) {
            //启动任务
            if ([LLTaskManager sharedLLTaskManager].taskListAlive == NO) {
                [[LLTaskManager sharedLLTaskManager] stopTask];
            }
            [[LLTaskManager sharedLLTaskManager] reSetAllTaskAlive];
            [LLTaskManager sharedLLTaskManager].taskListAlive = YES;
            [[LLTaskManager sharedLLTaskManager] reSetTasksFromDataBase];
            
            [[LLTaskManager sharedLLTaskManager] startTask];
        }
        else
        {
            //停止任务
            /*if ([LLTaskManager sharedLLTaskManager].taskListAlive == YES)
             {
             [[LLTaskManager sharedLLTaskManager] stopTask];
             }*/
            [[LLTaskManager sharedLLTaskManager] reSetAllTaskSleep];
            [[LLTaskManager sharedLLTaskManager] stopTask];
            
            [LLTaskManager sharedLLTaskManager].taskListAlive = NO;
            [[LLTaskManager sharedLLTaskManager] reSetTasksFromDataBase];
        }
    }
    else//3任何网络
    {
        if([GetNetworkInfoModel getNetworkType] != NETWORK_NOT_AVAILABLE)
        {
            //启动任务
            if ([LLTaskManager sharedLLTaskManager].taskListAlive == NO)
            {
                [[LLTaskManager sharedLLTaskManager] stopTask];
            }
            [[LLTaskManager sharedLLTaskManager] reSetAllTaskAlive];
            [LLTaskManager sharedLLTaskManager].taskListAlive = YES;
            [[LLTaskManager sharedLLTaskManager] reSetTasksFromDataBase];
            
            [[LLTaskManager sharedLLTaskManager] startTask];
            
        }
        else
        {
            //停止任务
            /*if ([LLTaskManager sharedLLTaskManager].taskListAlive == YES)
             {
             [[LLTaskManager sharedLLTaskManager] stopTask];
             }*/
            [[LLTaskManager sharedLLTaskManager] reSetAllTaskSleep];
            [[LLTaskManager sharedLLTaskManager] stopTask];
            
            [LLTaskManager sharedLLTaskManager].taskListAlive = NO;
            [[LLTaskManager sharedLLTaskManager] reSetTasksFromDataBase];
        }
    }
}

//单例销毁
-(void)attemptDealloc
{
    SharedInstance = nil;
}

@end
