//
//  DeleteWeiboBackInfoModel.m
//  VideoShare
//
//  Created by qin on 13-5-23.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "DeleteWeiboBackInfoModel.h"
#import "ThirdPartyManager.h"

@implementation DeleteWeiboBackInfoModel

@synthesize weiboid = _weiboid;
@synthesize snstype = _snstype;

-(id)init
{
    if (self=[super init]) {
    }
    return self;
}

-(void)setThirdPartyModelFromDic:(NSDictionary*)data response:(int)reseponsetype
{
    if(reseponsetype == SNSKIT_DELETE_WEIBO_SINA){
        [self setThirdPartyModelFromDic_Sina:data];
    }else if(reseponsetype == SNSKIT_DELETE_WEIBO_TC){
        [self setThirdPartyModelFromDic_Tc:data];
    }else if(reseponsetype == SNSKIT_DELETE_WEIBO_RENREN){
        [self setThirdPartyModelFromDic_RENREN:data];
    }
}

-(void)setThirdPartyModelFromDic_Sina:(NSDictionary*)data
{
    if(data != nil){
        _snstype = THIRDPARTY_SNS_TYPE_SINA;
        _weiboid = [data objectForKey:@"id"];
    }
}

-(void)setThirdPartyModelFromDic_Tc:(NSDictionary*)data
{
    /**
     data =     {
     id = 259168118937421;
     time = 1369300663;
     };
     */
    if(data != nil && [[[data objectForKey:@"ret"] description] isEqualToString:@"0"]){
        _snstype = THIRDPARTY_SNS_TYPE_TC;
        _weiboid = [data objectForKey:@"id"];
    }
}

-(void)setThirdPartyModelFromDic_RENREN:(NSDictionary*)data
{
    
}

@end
