//
//  SendUrlWeiboBackInfoModel.h
//  VideoShare
//
//  Created by qin on 13-6-17.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

//发送带有URL微博成功返回信息Model
@interface SendUrlWeiboBackInfoModel : NSObject
{
    NSString* _weiboid;
    NSString* _snstype;
}

@property (nonatomic, strong) NSString* weiboid;
@property (nonatomic, strong) NSString* snstype;
@property (nonatomic, strong) NSString* errorMessage;
@property (nonatomic, assign) BOOL isErrorWithSendFrequency;//频率发送过快
-(void)setThirdPartyModelFromDic:(NSDictionary*)data response:(int)reseponsetype;
-(void)setThirdPartyModelFromDic_Sina:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_Tc:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_RENREN:(NSDictionary*)data;
@end
