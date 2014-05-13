//
//  SendWeiboBackInfoModel.h
//  VideoShare
//
//  Created by qin on 13-5-23.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseThirdPartyModel.h"

//发送微博成功返回信息Model
@interface SendWeiboBackInfoModel : BaseThirdPartyModel{
    NSString* _weiboid;
    NSString* _snstype;
    NSString* _userid;
}

@property (nonatomic, retain) NSString* weiboid;
@property (nonatomic, retain) NSString* snstype;
@property (nonatomic, retain) NSString* userid;

-(void)setThirdPartyModelFromDic:(NSDictionary*)data response:(int)reseponsetype;
-(void)setThirdPartyModelFromDic_Sina:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_Tc:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_RENREN:(NSDictionary*)data;

@end
