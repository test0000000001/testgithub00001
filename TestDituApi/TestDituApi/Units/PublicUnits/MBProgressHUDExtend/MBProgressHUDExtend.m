//
//  MBProgressHUDExtend.m
//  VideoShare
//
//  Created by xu dongsheng on 13-7-1.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "MBProgressHUDExtend.h"
#import "GetNetworkInfoModel.h"
#import "Tools.h"

@interface MBProgressHUDExtend()
@property (nonatomic, strong) MBProgressSyncMidView *syncMid;
@property (nonatomic, strong) NSString* (^block)(void);
@end

@implementation MBProgressHUDExtend
@synthesize syncMid;

static id SharedInstance = nil;

+ (MBProgressHUDExtend *)sharedMBProgressHUDExtend {
    @synchronized(SharedInstance) {
        if (!SharedInstance) {
            SharedInstance = [[MBProgressHUDExtend alloc]init];
        }
    }
    return SharedInstance;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [_HUD removeFromSuperview];
	self.HUD = nil;
}

#pragma mark -

-(void)delayhideWating {
    
    if (_HUD) {
        [self hudWasHidden:_HUD];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayhideWating) object:nil];
    }
}

// 外部显式隐藏LOADING页
-(void)hideWaiting {
    [self performSelector:@selector(delayhideWating) withObject:nil afterDelay:0.f];
}

#pragma mark -

- (BOOL)canBecontinue {
    if ([GetNetworkInfoModel getNetworkType] == NETWORK_NOT_AVAILABLE) {
        [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"您的网络不给力呀!"];
        return NO;
    }
    return YES;
}

// 阻塞模式,执行INTVER后自动隐藏LOADING页并通知调用者BLOCK
- (void)showWaitingWithText:(NSString *)text ShowInterval:(NSTimeInterval)interval Block:(NSString* (^)(void))block {
    @synchronized(self){
        self.HUD = [[MBProgressHUD alloc] initWithView:[Tools getKeyWindow]];
        [[Tools getKeyWindow] addSubview:_HUD];
        self.HUD.labelText = text;
        _HUD.delegate = self;
        self.block = block;
        [self.HUD showWhileExecuting:@selector(blockExecute) onTarget:self withObject:nil animated:YES];
        [self performSelector:@selector(delayhideWating) withObject:nil afterDelay:interval];
    }
}


- (void)showWaitingWithText:(NSString *)text ShowInterval:(NSTimeInterval)interval
{
    @synchronized(self){
        [self delayhideWating];
        self.HUD = [[MBProgressHUD alloc] initWithView:[Tools getKeyWindow]];
        [[Tools getKeyWindow] addSubview:_HUD];
        self.HUD.labelText = text;
        _HUD.delegate = self;
        [self.HUD show:YES];
        [self performSelector:@selector(delayhideWating) withObject:nil afterDelay:interval];
    }
    
}

-(void)blockExecute {
    if(_block) {
        __block NSString* result = _block();
        if(!STR_IS_NIL(result)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:result];
            });
        }
    }
    _block = nil;
    [self delayhideWating];
}

// 阻塞模式
- (void)showWaitingWithText:(NSString *)text {
    if (![self canBecontinue]) {
        return;
    }
    
    self.HUD = [[MBProgressHUD alloc] initWithView:[Tools getKeyWindow]];
    [[Tools getKeyWindow] addSubview:self.HUD];
    self.HUD.labelText = text;
    _HUD.delegate = self;
    [self.HUD show:YES];
}

- (void)showWaitingWithTextWithoutJudgeConnection:(NSString *)text
{
    self.HUD = [[MBProgressHUD alloc] initWithView:[Tools getKeyWindow]];
    [[Tools getKeyWindow] addSubview:self.HUD];
    self.HUD.labelText = text;
    _HUD.delegate = self;
    [self.HUD show:YES];
}

//显示LOADING页,不阻塞用户操作,执行INTVER后自动隐藏LOADING页并通知调用者BLOCK
- (void)showSyncWaitingWithText:(NSString *)text FaterView:(UIView *)view ShowInterval:(NSTimeInterval)interval Block:(NSString* (^)(void))block {
    if (![self canBecontinue]) {
        return;
    }
    
    if (self.syncMid) {
        [syncMid removeFromSuperview];
    }
    self.syncMid = [[MBProgressSyncMidView alloc] initWithFrame:view.bounds];
    [syncMid setBackgroundColor:[UIColor clearColor]];
    syncMid.deleage = self;
    [view addSubview:syncMid];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:syncMid];
    [syncMid addSubview:self.HUD];
    self.HUD.labelText = text;
    _HUD.delegate = self;
    self.block = block;
    
    [self.HUD showWhileExecuting:@selector(blockExecute) onTarget:self withObject:nil animated:YES];
    [self performSelector:@selector(delayhideWating) withObject:nil afterDelay:interval];
}

//显示LOADING页,不阻塞用户操作
- (void)showSyncWaitingWithText:(NSString *)text FatherView:(UIView *)view {
    if (![self canBecontinue]) {
        return;
    }
    
    if (self.syncMid) {
        [syncMid removeFromSuperview];
    }
    self.syncMid = [[MBProgressSyncMidView alloc] initWithFrame:view.bounds];
    [syncMid setBackgroundColor:[UIColor clearColor]];
    syncMid.deleage = self;
    [view addSubview:syncMid];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:syncMid];
    [syncMid addSubview:self.HUD];
    self.HUD.labelText = text;
    _HUD.delegate = self;
    
    [self.HUD show:YES];
}

#pragma mark - MBProgressSyncMidViewDelegate

- (void)midViewtouched {
    [self delayhideWating];
}

@end
