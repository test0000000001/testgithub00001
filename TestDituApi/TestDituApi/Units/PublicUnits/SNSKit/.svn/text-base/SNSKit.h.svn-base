//
//  SNSKit.h
//  SNSKit
//
//  Created by wenjie-mac on 12-12-4.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSKitAuthorizeView.h"
#import "SNSKitRequest.h"
#import "RennSDK/RennSDK.h"

typedef enum {
    SINA = 0, //新浪微博
    WEIXIN = 1,//微信
    TC = 2,//腾讯微博
    RENREN = 3,
} SNSTYPE;//微博类型

typedef enum
{
	kSinaWeiboSDKErrorCodeParseError       = 200,
	kErrorCodeSSOParamsError   = 202,
} SNSKitErrorCode;
/*
 * NSUserDefaults KEY 持久化在UserDefaults里面的key
 */
//NSDictionary 新浪微博
#define SinaAuthData @"SinaAuthData"
#define SinaUserIDKey @"SinaUserIDKey"
#define SinaAccessTokenKey @"SinaAccessTokenKey"
#define SinaExpirationDateKey @"SinaExpirationDateKey"
#define SinaThirdRemind_in    @"SinaThirdRemind_in"

//腾讯微博
#define TCAuthData @"TCAuthData"
#define TCUserIDKey @"TCUserIDKey"
#define TCAccessTokenKey @"TCAccessTokenKey"
#define TCExpirationDateKey @"TCExpirationDateKey"
#define TCRefresh_token  @"TCRefresh_token"
#define TCopenkey  @"TCopenkey"
#define TCthirdremind_in  @"TCthirdremind_in"

//人人网
#define RENRENAuthData @"RENRENAuthData"
#define RENRENUserIDKey @"RENRENUserIDKey"
#define RENRENAccessTokenKey @"RENRENAccessTokenKey"
#define RENRENExpirationDateKey @"RENRENExpirationDateKey"
#define RENRENSECRETKey @"RENRENSECRETKey"
#define RENRENSESSIONkey @"RENRENSESSIONkey"

//第三方昵称
#define THIRDPARTYNICKNAME @"THIRDPARTYNICKNAME"

//新浪认证地址
#define SinaWeiboSdkVersion                @"2.0"
#define kSinaWeiboSDKErrorDomain           @"SinaWeiboSDKErrorDomain"
#define kSinaWeiboSDKErrorCodeKey          @"SinaWeiboSDKErrorCodeKey"
#define kSinaWeiboSDKAPIDomain             @"https://open.weibo.cn/2/"
#define kSinaWeiboSDKOAuth2APIDomain       @"https://open.weibo.cn/2/oauth2/"
#define kSinaWeiboWebAuthURL               @"https://open.weibo.cn/2/oauth2/authorize"
#define kSinaWeiboWebAccessTokenURL        @"https://open.weibo.cn/2/oauth2/access_token"

#define kSinaWeiboAppAuthURL_iPhone        @"sinaweibosso://login"
#define kSinaWeiboAppAuthURL_iPad          @"sinaweibohdsso://login"


//腾讯认证地址
#define TCWBSDKAPIDomain        @"https://open.t.qq.com/api/"
#define kTCWBAuthorizeURL         @"https://open.t.qq.com/cgi-bin/oauth2/authorize/ios"
#define kTCWBAccessTokenURL       @"https://open.t.qq.com/cgi-bin/oauth2/access_token"
#define kTCWBLonAndLatURL         @"http://ugc.map.soso.com/rgeoc/"

//人人网 授权及api相关
#define kRENRENAuthBaseURL            @"http://graph.renren.com/oauth/authorize"
#define kRENRENDialogBaseURL          @"http://widget.renren.com/dialog/"
#define kRENRENRestserverBaseURL      @"http://api.renren.com/restserver.do"
#define kRENRENRRSessionKeyURL        @"http://graph.renren.com/renren_api/session_key"
#define kRENRENRRSuccessURL           @"http://widget.renren.com/callback.html"
#define kRENRENSDKversion             @"3.0"
#define kRENRENPasswordFlowBaseURL    @"https://graph.renren.com/oauth/token"

//人人网 dialog相关
#define kRENRENWidgetURL @"http://widget.renren.com/callback.html"
#define kRENRENWidgetDialogURL @"//widget.renren.com/dialog"
#define kRENRENWidgetDialogUA @"18da8a1a68e2ee89805959b6c8441864"

@protocol SNSKitDelegate;

@interface SNSKit : NSObject<SNSKitAuthorizeViewDelegate,SNSKitRequestDelegate>
{
    NSString *userID;//微博ID openID
    NSString *accessToken;//token
    NSDate *expirationDate;//有效期
    NSString *thirdremind_in;  //第三方返回的有效时间
    NSString *tcopenkey; //腾讯  与openid对应的用户key，是验证openid身份的验证密钥
    NSString *refreshToken; //刷新token
    NSString *secret; //人人网secret
    NSString *sessionkey; //人人网sessionkey
    
//    id<SNSKitDelegate> delegate;
    
    NSString *appKey;
    NSString *appSecret;
    NSString *appRedirectURI;
    NSString *ssoCallbackScheme;
    
    SNSKitRequest *request;
    NSMutableSet *requests;
    BOOL ssoLoggingIn;
    
    SNSTYPE type;
    NSString* nickname;
}
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSDate *expirationDate;
@property (nonatomic, copy) NSString *thirdremind_in;
@property (nonatomic, copy) NSString *tcopenkey;
@property (nonatomic, copy) NSString *secret; 
@property (nonatomic, copy) NSString *sessionkey; 
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *ssoCallbackScheme;
@property (nonatomic, strong) id<SNSKitDelegate> delegate;
@property (nonatomic, copy) NSString *nickname;

-(int)getSNSType;

//初始化
- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
      appRedirectURI:(NSString *)appRedirectURI
         andDelegate:(id<SNSKitDelegate>)delegate
             snstype:(SNSTYPE)type;

//初始化
- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
      appRedirectURI:(NSString *)appRedirectURI
         andDelegate:(id<SNSKitDelegate>)delegate
             snstype:(SNSTYPE)type
            ssoCallbackScheme:(NSString *)ssoCallbackScheme;

- (void)applicationDidBecomeActive;
- (BOOL)handleOpenURL:(NSURL *)url;
+ (BOOL)canLoginUseAPP;
+ (void)setCanLoginUseAPP:(BOOL)b;
//验证证书 是否有效
- (BOOL)isAuthValid;
//验证是否有效
- (BOOL)isLoggedIn;
//验证是否过期
- (BOOL)isAuthorizeExpired;
//清空认证信息
- (void)removeAuthData;
// 本地存储认证信息
- (void)storeAuthData;
// Log in using OAuth Web authorization.
// If succeed, snskitDidLogIn will be called.
- (void)logIn;
// Log out.
// If succeed, snskitDidLogOut will be called.
- (void)logOut;

//API的请求接口 
- (SNSKitRequest *)requestWithURL:(NSString *)url
                           params:(NSMutableDictionary *)params
                       httpMethod:(NSString *)httpMethod
                         delegate:(id<SNSKitRequestDelegate>)_delegate;

@end

/**
 * @description 实现此协议，登录时传入此类对象，用于完成登录结果的回调
 */
@protocol SNSKitDelegate <NSObject>

@optional

- (void)snskitDidLogIn:(SNSKit *)snskit;
- (void)snskitDidLogOut:(SNSKit *)snskit;
- (void)snskitLogInDidCancel:(SNSKit *)snskit;
- (void)snskit:(SNSKit *)snskit logInDidFailWithError:(NSError *)error;
- (void)snskit:(SNSKit *)snskit accessTokenInvalidOrExpired:(NSError *)error;

@end
extern BOOL IsDeviceIPad();
