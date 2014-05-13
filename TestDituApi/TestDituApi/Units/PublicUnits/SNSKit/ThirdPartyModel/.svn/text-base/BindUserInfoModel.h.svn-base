//
//  BindUserInfoModel.h
//  VideoShare
//
//  Created by qin on 13-5-22.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseThirdPartyModel.h"
#import "Global.h"

//绑定用户信息Model
@interface BindUserInfoModel : BaseThirdPartyModel
{
    NSString* _snsid;
    NSString* _snstype;
    NSString* _nickname;
    NSString* _sex; //looklook “sex”:”0”0男 1女 2未知
    NSString* _address;
    NSString* _birthdate;
    NSString* _signature;
    NSString* _headurl;
}

@property (nonatomic, retain) NSString* snsid;
@property (nonatomic, retain) NSString* snstype;
@property (nonatomic, retain) NSString* nickname;
@property (nonatomic, retain) NSString* sex;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* birthdate;
@property (nonatomic, retain) NSString* signature;
@property (nonatomic, retain) NSString* headurl;

-(void)setThirdPartyModelFromDic:(NSDictionary*)data response:(int)reseponsetype;
-(void)setThirdPartyModelFromDic_Sina:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_Tc:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_RENREN:(NSDictionary*)data;
@end
