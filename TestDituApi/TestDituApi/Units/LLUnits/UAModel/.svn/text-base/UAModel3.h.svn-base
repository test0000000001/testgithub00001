//
//  UAModel3.h
//  VideoShare
//
//  Created by qin on 13-5-29.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APP_PositionModel.h"
#import "UIDeviceHardware.h"
#import "UAData.h"
#import "LoginUserInfoData.h"

@interface UAModel3 : NSObject
{
    APP_PositionModel* _aPP_PositionModel;
    
    NSString* _devicetoken;
    NSString* _mobiletype;
    NSString* _openUDID;
    NSString* _mac;
    NSString* _resolution;
    NSString* _basestationinfo;
    NSString* _internetway;
    NSString* _systemversionid;
    NSString* _sdk_imei;
    NSString* _channel_number;
    NSString* _gps;
    NSString* _devicetype;
    NSString* _clientversion;
    NSString* _siteid;
    NSString* _cdr;
    UAData* _uaData;
    LoginUserInfoData* _loginUserInfoData;
}

@property (nonatomic, retain) APP_PositionModel* aPP_PositionModel;

@property (nonatomic, retain) NSString* devicetoken;
@property (nonatomic, retain) NSString* mobiletype;
@property (nonatomic, retain) NSString* openUDID;
@property (nonatomic, retain) NSString* mac;
@property (nonatomic, retain) NSString* resolution;
@property (nonatomic, retain) NSString* basestationinfo;
@property (nonatomic, retain) NSString* internetway;
@property (nonatomic, retain) NSString* systemversionid;
@property (nonatomic, retain) NSString* sdk_imei;
@property (nonatomic, retain) NSString* channel_number;
@property (nonatomic, retain) NSString* gps;
@property (nonatomic, retain) NSString* devicetype;
@property (nonatomic, retain) NSString* clientversion;
@property (nonatomic, retain) NSString* siteid;
@property (nonatomic, retain) NSString* cdr;
@property (nonatomic, retain) UAData * uaData;
@property (nonatomic, retain) LoginUserInfoData* loginUserInfoData;

+(UAModel3 *)defaultUAModel3;
+(NSString*)dataFilePath;
- (NSString *) macaddress;
-(NSString *)getCurrentNetworkType;
-(void)save; //保存获取到的手机公用信息  deviceToken  openUDID  mac  userid
-(void)removeCurrentLoginUserid;

//某个用户第一次使用looklook客户端
-(void)UserFirstLogin;
-(NSString*)getFirstLoginUserId;
// 更新官方用户
- (void)updateOfficialUsersWithJsonStr:(NSString *)JsonStr;
// 判断是否官方用户
- (BOOL)isOfficialForUserID:(NSString *)userID;

-(NSString*)longitude;
-(NSString*)latitude;

//单例销毁
-(void)attemptDealloc;
@end
