//
//  MBProgressHUDExtend.h
//  VideoShare
//
//  Created by xu dongsheng on 13-7-1.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressSyncMidView.h"
#import "MBProgressHUD.h"

@interface MBProgressHUDExtend : NSObject<MBProgressHUDDelegate, MBProgressSyncMidViewDelegate> {
}

@property(nonatomic,strong)MBProgressHUD* HUD;


+(MBProgressHUDExtend *)sharedMBProgressHUDExtend;

// 延时关闭LOADING页
-(void)hideWaiting;

// 关闭LOADING页
-(void)delayhideWating;

// 阻塞模式,直到用户显式调用hideWaiting方法
- (void)showWaitingWithText:(NSString *)text;

/* 阻塞模式,在间断后通知调用者LOADING阻塞结束
 传入需要LOADING的时间间隔,以S为单位
 BLOCK异步执行,interval之后LOADING页消失
 **/
- (void)showWaitingWithText:(NSString *)text ShowInterval:(NSTimeInterval)interval Block:(NSString* (^)(void))block;

// 非阻塞模式,需要传入父窗口视图
- (void)showSyncWaitingWithText:(NSString *)text FatherView:(UIView *)view;

/* 非阻塞模式,在间断后通知调用者LOADING阻塞结束
 传入需要LOADING的时间间隔,以S为单位
 BLOCK异步执行,interval之后LOADING页消失
 **/
- (void)showSyncWaitingWithText:(NSString *)text FaterView:(UIView *)view ShowInterval:(NSTimeInterval)interval Block:(NSString* (^)(void))block;


- (void)showWaitingWithText:(NSString *)text ShowInterval:(NSTimeInterval)interval;



- (void)showWaitingWithTextWithoutJudgeConnection:(NSString *)text;
@end
