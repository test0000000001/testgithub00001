//
//  LLGlobalService.h
//  VideoShare
//
//  Created by zengchao on 13-5-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APPLoadModel.h"
#import "LocationManager.h"
#import "AppDelegateModel.h"
#import "MBProgressHUDExtend.h"

@interface LLGlobalService : NSObject
{
    
}

+(LLGlobalService *)sharedLLGlobalService;
@property(strong,nonatomic)NSMutableDictionary* imageCacheDic;
@property(strong, nonatomic) APPLoadModel* appLoadModel;
@property (strong, nonatomic) LocationManager *locManager;
@property (nonatomic, strong) AppDelegateModel *appDelegateModel;
@property (nonatomic, strong) MBProgressHUDExtend *progressHUDExtend; //等待框
@property (nonatomic, strong) NSMutableDictionary *textImageCacheArray;
@property (nonatomic, strong) NSMutableDictionary *seletfaceDictionary;
@property (nonatomic, strong) NSString* weather;
@property (nonatomic, strong) NSString* weather_info;
@property (nonatomic,strong) NSMutableArray * audioRecordManagerArray;
//单例销毁
-(void)attemptDealloc; 
@end
