//
//  SNSKit.m
//  SNSKit
//
//  Created by wenjie-mac on 12-12-4.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "SNSKit.h"
#import "SNSKitRequest.h"
#import <CommonCrypto/CommonDigest.h>

@interface SNSKit ()

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *appRedirectURI;

@end


@implementation SNSKit

@synthesize userID;
@synthesize accessToken;
@synthesize expirationDate;
@synthesize secret;
@synthesize thirdremind_in;
@synthesize tcopenkey;
@synthesize sessionkey;
@synthesize refreshToken;
@synthesize delegate;

@synthesize appKey;
@synthesize appSecret;
@synthesize appRedirectURI;

@synthesize ssoCallbackScheme;
@synthesize nickname;

-(int)getSNSType
{
    return type;
}

/**
 * @description 初始化构造函数，返回采用默认sso回调地址构造的SinaWeibo对象
 * @param _appKey: 分配给第三方应用的appkey
 * @param _appSecrect: 分配给第三方应用的appsecrect
 * @param _appRedirectURI: 微博开放平台中授权设置的应用回调页 （ps 客户端认证一般回调页用不着 和平台里设置的保持一致就行）
 * @return SinaWeibo对象
 */
- (id)initWithAppKey:(NSString *)_appKey appSecret:(NSString *)_appSecrect
      appRedirectURI:(NSString *)_appRedirectURI
         andDelegate:(id<SNSKitDelegate>)_delegate
             snstype:(SNSTYPE)_type
{
    return [self initWithAppKey:_appKey appSecret:_appSecrect appRedirectURI:_appRedirectURI andDelegate:_delegate snstype:_type ssoCallbackScheme:nil];
}

- (id)initWithAppKey:(NSString *)_appKey appSecret:(NSString *)_appSecrect
      appRedirectURI:(NSString *)_appRedirectURI
         andDelegate:(id<SNSKitDelegate>)_delegate
             snstype:(SNSTYPE)_type
   ssoCallbackScheme:(NSString *)_ssoCallbackScheme
{
    if ((self = [super init]))
    {
        self.appKey = _appKey;
        self.appSecret = _appSecrect;
        self.appRedirectURI = _appRedirectURI;
        self.delegate = _delegate;
        type = _type;
        
        if (!_ssoCallbackScheme && type==SINA)
        {
            _ssoCallbackScheme = [NSString stringWithFormat:@"sinaweibosso.%@://", self.appKey];
        }
        self.ssoCallbackScheme = _ssoCallbackScheme;
        
        requests = [[NSMutableSet alloc] init];
        
    }
    
    return self;
}
#pragma mark - Send request with token

/**
 * @description 微博API的请求接口，方法中自动完成token信息的拼接
 * @param url: 请求的接口
 * @param params: 请求的参数，如发微博所带的文字内容等
 * @param httpMethod: http类型，GET或POST
 * @param _delegate: 处理请求结果的回调的对象，SinaweiboRequestDelegate类
 * @return 完成实际请求操作的SinaWeiboRequest对象
 */

- (SNSKitRequest *)requestWithURL:(NSString *)url
                              params:(NSMutableDictionary *)params
                          httpMethod:(NSString *)httpMethod
                            delegate:(id<SNSKitRequestDelegate>)_delegate
{
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    if ([self isAuthValid])
    {
        NSString *fullURL;
        if (type == SINA) {
            [params setValue:self.accessToken forKey:@"access_token"];
            fullURL = [kSinaWeiboSDKAPIDomain stringByAppendingString:url];
            
        }else if(type == TC) {
            fullURL = [TCWBSDKAPIDomain stringByAppendingString:url];
            
            NSString *clientip = @"";//客户端IP
            NSString *oauth_version = @"2.a";
            NSString *scope = @"all";//请求权限范围（默认“all”）
            NSString *from = @"cmmobi";
            NSLog(@"xxxtc self.userID[%@]", self.userID);
            
//            [params setObject:self.userID      forKey:@"openid"];
//            [params setObject:self.accessToken forKey:@"access_token"];
//            [params setObject:self.appKey      forKey:@"oauth_consumer_key"];
//            [params setObject:clientip         forKey:clientip];
//            [params setObject:oauth_version    forKey:@"oauth_version"];
//            [params setObject:scope            forKey:@"scope"];
            [params setObject:from             forKey:@"appfrom"];
            [params setObject:@"json"           forKey:@"format"];
            
            NSMutableDictionary *mutableParams = [[NSMutableDictionary alloc]initWithCapacity:6];
            
            [mutableParams setObject:self.userID      forKey:@"openid"];
            [mutableParams setObject:self.accessToken forKey:@"access_token"];
            [mutableParams setObject:self.appKey      forKey:@"oauth_consumer_key"];
            [mutableParams setObject:clientip         forKey:@"clientip"];
            [mutableParams setObject:oauth_version    forKey:@"oauth_version"];
            [mutableParams setObject:scope            forKey:@"scope"];
            NSLog(@"mutableParams%@",mutableParams);
            
            NSString *commentUrl = [SNSKitRequest stringFromDictionary:mutableParams];
            
            fullURL = [fullURL stringByAppendingFormat:@"%@%@",@"?",commentUrl];
        }else if(type == RENREN){
            /* 用于设置通用的一些参数到param对象中。*/
            // 这里假设此前已经调用[self isSessionValid],并且返回Ture。
            [params setValue:sessionkey forKey:@"session_key"];
            [params setValue:self.appSecret forKey:@"api_key"];
            [params setValue:@"1" forKey:@"xn_ss"];
            [params setValue:@"json" forKey:@"format"];
            [params setValue:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] forKey:@"call_id"];
            [params setValue:kRENRENSDKversion forKey:@"v"];
            [params setValue:url forKey:@"method"];
            
            NSString* sig = [self generateSig:params secretKey:self.secret];
            if (sig != nil && ![sig isEqualToString:@""]) {
                [params setObject:sig forKey:@"sig"];
            }
            NSLog(@"mutableParams%@",params);
            
//            NSString *commentUrl = [SNSKitRequest stringFromDictionary:mutableParams];
            
            fullURL = kRENRENRestserverBaseURL;//[kRENRENRestserverBaseURL stringByAppendingFormat:@"%@%@",@"?",commentUrl];
        }
        
        NSLog(@"FULL URL%@",fullURL);
        NSLog(@"params%@",params);
        SNSKitRequest *_request = [SNSKitRequest requestWithURL:fullURL
                                                     httpMethod:httpMethod
                                                         params:params
                                                       delegate:_delegate];
        _request.snskit = self;
        [requests addObject:_request];
        [_request connect];
        return _request;
        
    }
    else
    {
        //notify token expired in next runloop
        [self performSelectorOnMainThread:@selector(notifyTokenExpired:)
                               withObject:_delegate
                            waitUntilDone:NO];
        
        return nil;
    }
}
#pragma mark - sign

/**
 * 针对人人开放平台接口传参需求计算sig码的工具方法。
 */
- (NSString *)generateSig:(NSMutableDictionary *)paramsDict secretKey:(NSString *)secretKey{
    NSMutableString* joined = [NSMutableString string];
	NSArray* keys = [paramsDict.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (id obj in [keys objectEnumerator]) {
		id value = [paramsDict valueForKey:obj];
		if ([value isKindOfClass:[NSString class]]) {
			[joined appendString:obj];
			[joined appendString:@"="];
			[joined appendString:value];
		}
	}
	[joined appendString:secretKey];
	return [self md5HexDigest:joined];
}

/**
 * 对输入的字符串进行MD5计算并输出验证码的工具方法。
 */
- (NSString *)md5HexDigest:(NSString *)input{
    const char* str = [input UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
    NSMutableString *returnHashSum = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [returnHashSum appendFormat:@"%02x", result[i]];
    }
	
	return returnHashSum;
}

#pragma mark - Validation

/**
 * @description 判断是否登录
 * @return YES为已登录；NO为未登录
 */
- (BOOL)isLoggedIn
{
    return (userID != nil ||secret != nil) && accessToken && expirationDate;
}

/**
 * @description 判断登录是否过期
 * @return YES为已过期；NO为未为期
 */
- (BOOL)isAuthorizeExpired
{
    NSDate *now = [NSDate date];
    return ([now compare:expirationDate] == NSOrderedDescending);
}


/**
 * @description 判断登录是否有效，当已登录并且登录未过期时为有效状态
 * @return YES为有效；NO为无效
 */
- (BOOL)isAuthValid
{
    return([self isLoggedIn] && ![self isAuthorizeExpired]);
}
/**
 * @description 清空认证信息
 */
- (void)removeAuthData
{
    self.accessToken = nil;
    self.userID = nil;
    self.expirationDate = nil;
    self.secret = nil;
    self.sessionkey = nil;
    self.refreshToken = nil;
    self.tcopenkey = nil;
    self.thirdremind_in = nil;
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* sinaweiboCookies = [cookies cookiesForURL:
                                 [NSURL URLWithString:@"https://open.weibo.cn"]];
    
    NSArray* qqweiboCookies = [cookies cookiesForURL:
                                 [NSURL URLWithString:@"https://open.t.qq.com"]];
    
    NSArray* graphCookies = [cookies cookiesForURL:
                             [NSURL URLWithString:@"http://graph.renren.com"]];
	
    NSArray* widgetCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://widget.renren.com"]];
    
	for (NSHTTPCookie* cookie in graphCookies) {
		[cookies deleteCookie:cookie];
	}
    
	for (NSHTTPCookie* cookie in widgetCookies) {
		[cookies deleteCookie:cookie];
	}
    
    for (NSHTTPCookie* cookie in qqweiboCookies)
    {
        [cookies deleteCookie:cookie];
    }
    
    for (NSHTTPCookie* cookie in sinaweiboCookies)
    {
        [cookies deleteCookie:cookie];
    }
    //清除本地的NSUserDefaults
    switch (type) {
        case SINA:
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:SinaAuthData];
            break;
        case TC:
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:TCAuthData];
            break;
        case RENREN:
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:RENRENAuthData];
            break;
        default:
            break;
    }
    
}
/**
 * @description 本地存储认证信息
 */
- (void)storeAuthData
{
    NSDictionary *authData;
    if (type == SINA) {
        authData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.accessToken, SinaAccessTokenKey,
                                  self.expirationDate, SinaExpirationDateKey,
                                  self.userID, SinaUserIDKey,
                                  self.thirdremind_in, SinaThirdRemind_in,
                                  //self.refreshToken, @"refresh_token",
                                  nil];
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:SinaAuthData];
    } else if (type == TC) {
        authData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.accessToken, TCAccessTokenKey,
                                  self.expirationDate, TCExpirationDateKey,
                                  self.userID, TCUserIDKey,
                                  self.refreshToken, TCRefresh_token,
                                  self.tcopenkey, TCopenkey,
                                  self.thirdremind_in, TCthirdremind_in,
                                  nil];
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:TCAuthData];
    }else if(type == RENREN){
        authData = [NSDictionary dictionaryWithObjectsAndKeys:
                    self.accessToken, RENRENAccessTokenKey,
                    self.expirationDate, RENRENExpirationDateKey,
                    self.secret, RENRENSECRETKey,
                    self.sessionkey, RENRENSESSIONkey,
                    //self.refreshToken, @"refresh_token",
                    nil];
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:RENRENAuthData];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"本地持久化授权\n storeAuthData=%@", authData);
}
#pragma mark - LogIn / LogOut

/**
 * @description 登录入口，当初始化SNSKit对象完成后直接调用此方法完成登录
 */
- (void)logIn
{
    if ([self isAuthValid])
    {
        if ([delegate respondsToSelector:@selector(snskitDidLogIn:)])
        {
            [delegate snskitDidLogIn:self];
        }
    }
    else
    {
        [self removeAuthData];
        
        ssoLoggingIn = NO;
        
        // open authorize view
        NSDictionary *params;
        
        if(type == SINA){
            // open sina weibo app
            UIDevice *device = [UIDevice currentDevice];
            if ([device respondsToSelector:@selector(isMultitaskingSupported)] &&
                [device isMultitaskingSupported])
            {
                NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        self.appKey, @"client_id",
                                        self.appRedirectURI, @"redirect_uri",
                                        self.ssoCallbackScheme, @"callback_uri", nil];
                
                // 先用iPad微博打开
                NSString *appAuthBaseURL = kSinaWeiboAppAuthURL_iPad;
                if(IsDeviceIPad() && [SNSKit canLoginUseAPP])
                {
                    NSString *appAuthURL = [SNSKitRequest serializeURL:appAuthBaseURL
                                                                   params:params httpMethod:@"GET"];
                    ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthURL]];
                }
                
                // 在用iPhone微博打开
                if (!ssoLoggingIn && [SNSKit canLoginUseAPP])
                {
                    appAuthBaseURL = kSinaWeiboAppAuthURL_iPhone;
                    NSString *appAuthURL = [SNSKitRequest serializeURL:appAuthBaseURL
                                                                   params:params httpMethod:@"GET"];
                    ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthURL]];
                }
            }
        }
        
        if (!ssoLoggingIn)
        {
            if (type == SINA) {
                params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          self.appKey, @"client_id",
                          @"code",     @"response_type",
                          self.appRedirectURI, @"redirect_uri",
                          @"mobile", @"display",
                          @"true",@"forcelogin",nil];
            } else if (type == TC) {
                
                params = [[NSDictionary alloc]initWithObjectsAndKeys:
                          appKey,  @"client_id",
                          @"token", @"response_type",
                          appRedirectURI,@"redirect_uri",
                          @"ios",@"appfrom",
                          [NSNumber numberWithInt:1],@"htmlVersion",nil];
            } else if (type == RENREN){
                //人人网权限列表
                NSArray *permissions = [NSArray arrayWithObjects:@"read_user_album",@"status_update",@"photo_upload",@"publish_feed",@"create_album",@"operate_like",nil];
                if (nil != permissions) {
                    NSString *permissionScope = [permissions componentsJoinedByString:@","];
//                    [params setValue:permissionScope forKey:@"scope"];
                    params = [[NSDictionary alloc]initWithObjectsAndKeys:
                              self.appKey,@"client_id",
                              kRENRENRRSuccessURL,@"redirect_uri",
                              @"token",@"response_type",
                              @"touch",@"display",
                              kRENRENWidgetDialogUA,@"ua",permissionScope,@"scope",nil];
                }else{
                    params = [[NSDictionary alloc]initWithObjectsAndKeys:
                              self.appKey,@"client_id",
                              kRENRENRRSuccessURL,@"redirect_uri",
                              @"token",@"response_type",
                              @"touch",@"display",
                              kRENRENWidgetDialogUA,@"ua",nil];
                }
                
            }
            
            
            SNSKitAuthorizeView *authorizeView =
            [[SNSKitAuthorizeView alloc] initWithAuthParams:params
                                                   delegate:self snstype:type];
            [authorizeView show];
        }
    }
}
+(BOOL)canLoginUseAPP{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [defaults objectForKey:@"NSUserDefaultsLoginUseAPP"];
    if([str isEqualToString:@"y"] || STR_IS_NIL(str)){
        return YES;
    }
    return NO;
}
+(void)setCanLoginUseAPP:(BOOL)b{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if(b){
        [defaults setObject:@"y" forKey:@"NSUserDefaultsLoginUseAPP"];
    }else{
        [defaults setObject:@"n" forKey:@"NSUserDefaultsLoginUseAPP"];
    }
    [defaults synchronize];
}
/**
 * @description 退出方法，需要退出时直接调用此方法
 */
- (void)logOut
{
    [self removeAuthData];
    
    if ([delegate respondsToSelector:@selector(snskitDidLogOut:)])
    {
        [delegate snskitDidLogOut:self];
    }
}
//用户取消授权 回调
- (void)logInDidCancel
{
    if ([delegate respondsToSelector:@selector(snskitLogInDidCancel:)])
    {
        [delegate snskitLogInDidCancel:self];
    }
}

//用户登录成功 回调
- (void)logInDidFinishWithAuthInfo:(NSDictionary *)authInfo
{
    NSString *access_token;
    NSString *uid;
    NSString *remind_in;
    NSString *refresh_token;
    
    if (type == SINA) {
        access_token = [authInfo objectForKey:@"access_token"];
        uid = [authInfo objectForKey:@"uid"];
        remind_in = [authInfo objectForKey:@"remind_in"];
        refresh_token = [authInfo objectForKey:@"refresh_token"];
        
    }else if (type == TC) {
//        access_token=0e38e64b9b376182634bae08965fd295&
//        expires_in=604800&
//        openid=E5B0880AD0D0B5C5F6850BF2E89434FC&
//        openkey=832E0BBE0EE5FD39838D75826A252ADF&
//        refresh_token=3b1635c3cf6294f491ecdcf356a9fa09
        NSLog(@"腾讯 access token result = %@", authInfo);
        access_token = [authInfo objectForKey:@"access_token"];
        remind_in = [authInfo objectForKey:@"expires_in"];//腾讯返回的貌似是有效的时长
        uid = [authInfo objectForKey:@"openid"];
        NSString *openkey = [authInfo objectForKey:@"openkey"];////?????????
        self.tcopenkey= [authInfo objectForKey:@"openkey"];////?????????
        refresh_token = [authInfo objectForKey:@"refresh_token"];
        
        int nowdate = [remind_in intValue];//+[[NSDate date] timeIntervalSince1970];//+当前日期 算出过期日期
        remind_in = [NSString stringWithFormat:@"%d",nowdate];

    }else if(type == RENREN){
        NSLog(@"人人 access token result = %@", authInfo);
        access_token = [[authInfo objectForKey:@"access_token"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        remind_in = [authInfo objectForKey:@"expires_in"];
        secret = [SNSKitRequest getSecretKeyByToken:access_token];
        sessionkey = [SNSKitRequest getSessionKeyByToken:access_token];
    }
    
    if (access_token && (uid||secret))
    {
        if (remind_in != nil)
        {
            self.thirdremind_in = remind_in;
            int expVal = [remind_in intValue];
            if (expVal == 0)
            {
                self.expirationDate = [NSDate distantFuture];
            }
            else
            {
                self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }
        NSLog(@"%@",self.expirationDate);
        self.accessToken = access_token;
        self.userID = uid;
        self.refreshToken = refresh_token;
        
        if ([delegate respondsToSelector:@selector(snskitDidLogIn:)])
        {
            [delegate snskitDidLogIn:self];
        }
    }
    
    NSLog(@"恭喜你登录成功");
    [self storeAuthData];//存储到本地
}
//用户授失败 回调
- (void)logInDidFailWithErrorInfo:(NSDictionary *)errorInfo
{
    if (type == SINA) {
        NSString *error_code = [errorInfo objectForKey:@"error_code"];
        if ([error_code isEqualToString:@"21330"])
        {
            [self logInDidCancel];
        }
        else
        {
            if ([delegate respondsToSelector:@selector(snskit:logInDidFailWithError:)])
            {
                NSString *error_description = [errorInfo objectForKey:@"error_description"];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          errorInfo, @"error",
                                          error_description, NSLocalizedDescriptionKey, nil];
                NSError *error = [NSError errorWithDomain:kSinaWeiboSDKErrorDomain
                                                     code:[error_code intValue]
                                                 userInfo:userInfo];
                NSLog(@"sina授权失败NSError=%@",error.userInfo);
                [delegate snskit:self logInDidFailWithError:error];
            }
            
        }
    } else if (type == TC) {
        
        NSError *error = [NSError errorWithDomain:TCWBSDKErrorDomain
                                             code:TCWBErrorCodeSDK
                                         userInfo:[NSDictionary
                            dictionaryWithObject:[NSString stringWithFormat:@"%d", TCWBSDKErrorCodeAuthorizeError]
                                                                              forKey:TCWBSDKErrorCodeKey]];
        NSLog(@"腾讯授权失败NSError=%@",error.userInfo);
        [delegate snskit:self logInDidFailWithError:error];
    }
    
}

#pragma mark - public methods
//创建字典存储返回信息
- (NSDictionary *)createDicforAccesstoken:(NSString *)returnString{
    NSMutableDictionary *accessDic = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *returnArray = [[NSArray alloc] initWithArray:[returnString componentsSeparatedByString:@"&"]];
    for (int i = 0; i < [returnArray count]; i++) {
        NSArray *array = [[returnArray objectAtIndex:i] componentsSeparatedByString:@"="];
        [accessDic setObject:[array objectAtIndex:1]forKey:[array objectAtIndex:0]];
    }
    return accessDic;
}



#pragma mark - Private methods
//用户授权成功后 login
- (void)requestAccessTokenWithAuthorizationCode:(NSString *)code
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.appKey, @"client_id",
                            self.appSecret, @"client_secret",
                            @"authorization_code", @"grant_type",
                            self.appRedirectURI, @"redirect_uri",
                            code, @"code", nil];
    [request disconnect];
    request = nil;
    
    request = [SNSKitRequest requestWithURL:kSinaWeiboWebAccessTokenURL
                                 httpMethod:@"POST"
                                     params:params
                                   delegate:self];
    
    [request connect];
}

- (void)requestDidFinish:(SNSKitRequest *)_request
{
    [requests removeObject:_request];
    _request.snskit = nil;
}

- (void)requestDidFailWithInvalidToken:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(snskit:accessTokenInvalidOrExpired:)])
    {
        [delegate snskit:self accessTokenInvalidOrExpired:error];
    }
}

- (void)notifyTokenExpired:(id<SNSKitRequestDelegate>)requestDelegate
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Token expired", NSLocalizedDescriptionKey, nil];
    
    NSError *error = [NSError errorWithDomain:kSinaWeiboSDKErrorDomain
                                         code:21315
                                     userInfo:userInfo];
    
    if ([delegate respondsToSelector:@selector(snskit:accessTokenInvalidOrExpired:)])
    {
        [delegate snskit:self accessTokenInvalidOrExpired:error];
    }
    
    if ([requestDelegate respondsToSelector:@selector(request:didFailWithError:)])
	{
		[requestDelegate request:nil didFailWithError:error];
	}
}
#pragma mark - SNSKitRequestDelegate Delegate

- (void)request:(SNSKitRequest *)_request didFailWithError:(NSError *)error
{
    if (_request == request)
    {
        if ([delegate respondsToSelector:@selector(snskit:logInDidFailWithError:)])
        {
            [delegate snskit:self logInDidFailWithError:error];
        }
        
        request = nil;
    }
}

- (void)request:(SNSKitRequest *)_request didFinishLoadingWithResult:(id)result
{
    if (_request == request)
    {
        NSLog(@"access token result = %@", result);
        
        [self logInDidFinishWithAuthInfo:result];
        request = nil;
    }
}

#pragma mark - Application life cycle

/**
 * @description 当应用从后台唤起时，应调用此方法，需要完成退出当前登录状态的功能
 */
- (void)applicationDidBecomeActive
{
    if (ssoLoggingIn)
    {
        // user open the app manually
        // clean sso login state
        ssoLoggingIn = NO;
        
        if ([delegate respondsToSelector:@selector(snskitLogInDidCancel:)])
        {
            [delegate snskitLogInDidCancel:self];
        }
    }
}

/**
 * @description sso回调方法，官方客户端完成sso授权后，回调唤起应用，应用中应调用此方法完成sso登录
 * @param url: 官方客户端回调给应用时传回的参数，包含认证信息等
 * @return YES
 */
- (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:self.ssoCallbackScheme])
    {
        if (!ssoLoggingIn)
        {
            // sso callback after user have manually opened the app
            // ignore the request
        }
        else
        {
            ssoLoggingIn = NO;
            
            if ([SNSKitRequest getParamValueFromUrl:urlString paramName:@"sso_error_user_cancelled"])
            {
                if ([delegate respondsToSelector:@selector(snskitLogInDidCancel:)])
                {
                    [delegate snskitLogInDidCancel:self];
                }
            }
            else if ([SNSKitRequest getParamValueFromUrl:urlString paramName:@"sso_error_invalid_params"])
            {
                if ([delegate respondsToSelector:@selector(snskit:logInDidFailWithError:)])
                {
                    NSString *error_description = @"Invalid sso params";
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              error_description, NSLocalizedDescriptionKey, nil];
                    NSError *error = [NSError errorWithDomain:kSinaWeiboSDKErrorDomain
                                                         code:kErrorCodeSSOParamsError
                                                     userInfo:userInfo];
                    [delegate snskit:self logInDidFailWithError:error];
                }
            }
            else if ([SNSKitRequest getParamValueFromUrl:urlString paramName:@"error_code"])
            {
                NSString *error_code = [SNSKitRequest getParamValueFromUrl:urlString paramName:@"error_code"];
                NSString *error = [SNSKitRequest getParamValueFromUrl:urlString paramName:@"error"];
                NSString *error_uri = [SNSKitRequest getParamValueFromUrl:urlString paramName:@"error_uri"];
                NSString *error_description = [SNSKitRequest getParamValueFromUrl:urlString paramName:@"error_description"];
                
                NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                           error, @"error",
                                           error_uri, @"error_uri",
                                           error_code, @"error_code",
                                           error_description, @"error_description", nil];
                
                [self logInDidFailWithErrorInfo:errorInfo];
            }
            else
            {
                NSString *access_token = [SNSKitRequest getParamValueFromUrl:urlString paramName:@"access_token"];
                NSString *expires_in = [SNSKitRequest getParamValueFromUrl:urlString paramName:@"expires_in"];
                NSString *remind_in = [SNSKitRequest getParamValueFromUrl:urlString paramName:@"remind_in"];
                NSString *uid = [SNSKitRequest getParamValueFromUrl:urlString paramName:@"uid"];
                NSString *refresh_token = [SNSKitRequest getParamValueFromUrl:urlString paramName:@"refresh_token"];
                
                NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
                if (access_token) [authInfo setObject:access_token forKey:@"access_token"];
                if (expires_in) [authInfo setObject:expires_in forKey:@"expires_in"];
                if (remind_in) [authInfo setObject:remind_in forKey:@"remind_in"];
                if (refresh_token) [authInfo setObject:refresh_token forKey:@"refresh_token"];
                if (uid) [authInfo setObject:uid forKey:@"uid"];
                
                [self logInDidFinishWithAuthInfo:authInfo];
            }
        }
    }
    return YES;
}

#pragma mark - SNSKitAuthorizeViewDelegate
//成功回调
- (void)authorizeView:(SNSKitAuthorizeView *)authView
didRecieveAuthorizationCode:(NSString *)code
{
    if (type == SINA) {
        [self requestAccessTokenWithAuthorizationCode:code];//sina 继续去login
    } else if (type == TC) {
        NSDictionary* info = [self createDicforAccesstoken:code];
        [self logInDidFinishWithAuthInfo:info];
    }else if(type == RENREN){
        NSDictionary* info = [self createDicforAccesstoken:code];
        [self logInDidFinishWithAuthInfo:info];
    }
}
//报错回调
- (void)authorizeView:(SNSKitAuthorizeView *)authView
 didFailWithErrorInfo:(NSDictionary *)errorInfo
{
    [self logInDidFailWithErrorInfo:errorInfo];
}
//取消回调
- (void)authorizeViewDidCancel:(SNSKitAuthorizeView *)authView
{
    [self logInDidCancel];
}

//判断是否是ipad
BOOL IsDeviceIPad()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
#endif
    return NO;
}
@end
