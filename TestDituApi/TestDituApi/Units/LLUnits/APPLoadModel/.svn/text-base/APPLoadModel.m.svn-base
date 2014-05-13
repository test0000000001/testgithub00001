//
//  APPLoadModel.m
//  VideoShare
//
//  Created by zengchao on 13-5-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "Global.h"
#import "LLDaoBase.h"
#import "APPLoadModel.h"
#import "LocalResourceModel.h"

#import "LLDaoModelUser.h"
#import "LLTaskManager.h"
#import "Tools.h"

@implementation APPLoadModel
-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

-(void)doLoadWithCompleteBlock:(void (^)(NSString* result))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //写载入逻辑
        if(APP_USERID.length != 0){
            
        }
//        [self initUserDefault];
        dispatch_async(dispatch_get_main_queue(), ^{
            //更具载入逻辑写结果
            block(@"gotoMainView");
        });
    });
}

-(void)initUserDefault
{
    //先判断有无记录,无则创建默认记录
    __block LLDaoModelUser *llDaoModelUser = nil;

    LLDaoModelUser *daoModelUser = [[LLDaoModelUser alloc] init];
    LLDAOBase *llDaoBase = [LLDAOBase shardLLDAOBase];
    [llDaoBase searchWhere:daoModelUser
                    String:[NSString stringWithFormat:@"userid = \'%@\'",APP_USERID]
                   orderBy:nil
                    offset:0
                     count:1
                  callback:^(NSArray *resultArray)
     {
         // 无纪录则创建纪录并将默认值设置进去
         if (resultArray.count <= 0)
         {
             llDaoModelUser = [[LLDaoModelUser alloc] init];
             llDaoModelUser.userid = APP_USERID;

             llDaoModelUser.isBindSina = @"0";  //新浪未绑定
             llDaoModelUser.bindSinaAuthInfo = @""; //新浪绑定信息
             
             llDaoModelUser.isBindTC = @"0"; //腾讯未绑定
             llDaoModelUser.bindTCAuthInfo = @""; //腾讯绑定信息
             
             llDaoModelUser.isBindRENREN = @"0";//人人未绑定
             llDaoModelUser.bindRENRENAuthInfo = @""; //人人绑定信息
             
         }
     }
     ];
    
    if (llDaoModelUser)
    {
        [llDaoBase insertToDB:llDaoModelUser
                     callback:^(BOOL result)
         {
             // to-do 失败时候属于异常情况，目前不做处理
         }
         ];
    }
}

@end
