//
//  LLGlobalService.m
//  VideoShare
//
//  Created by zengchao on 13-5-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

//实现全局服务对象,生命周期同整个应用

#import "LLGlobalService.h"

@implementation LLGlobalService

@synthesize appLoadModel=_appLoadModel;
@synthesize locManager = _locManager;
@synthesize imageCacheDic= _imageCacheDic;
@synthesize appDelegateModel = _appDelegateModel;

static id SharedInstance;
+(LLGlobalService *)sharedLLGlobalService
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
    if (self = [super init]) {
        self.weather_info = @"";
        self.weather = @"";
        self.appLoadModel = [[APPLoadModel alloc] init];
        self.locManager = [[LocationManager alloc] init];
        self.imageCacheDic = [[NSMutableDictionary alloc]init];
        self.appDelegateModel = [[AppDelegateModel alloc] init];
        self.progressHUDExtend = [[MBProgressHUDExtend alloc]init];
        self.textImageCacheArray = [[NSMutableDictionary alloc]initWithCapacity:10];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"selectface"
                                                              ofType:@"plist"];
        // 读取到一个NSDictionary
        self.seletfaceDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        self.audioRecordManagerArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return self;
}

//单例销毁
-(void)attemptDealloc
{
    SharedInstance = nil;
}
@end
