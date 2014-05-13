//
//  ThirdPartyManager.m
//  VideoShare
//
//  Created by qin on 13-5-22.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "ThirdPartyManager.h"
#import "Global.h"
#import "JsonParseUtil.h"
#import "UrlEncoder.h"

@implementation ThirdPartyManager

@synthesize sinaSnsKit = _sinaSnsKit;
@synthesize tcSnsKit = _tcSnsKit;
@synthesize renRenSnsKit = _renRenSnsKit;
@synthesize userInfo = _userInfo;
@synthesize delegate;
@synthesize tokenInvalidDelegate;
@synthesize llDaoModelUser;
@synthesize tokenInvalid = _tokenInvalid;
@synthesize tc_commentid = _tc_commentid;
@synthesize renren_targetUserId = _renren_targetUserId;

static ThirdPartyManager* singleton = nil;

+(ThirdPartyManager *)defaultThirdPartyManager{
    @synchronized(self) {
        if(singleton == nil){
            singleton=[[self alloc] init];
        }
    };
    return singleton;
}

+(ThirdPartyManager *)defaultThirdPartyManager:(id<SNSKitResponseDelegate>) responseDelegate{
    ThirdPartyManager *thirdPartyManager=[[ThirdPartyManager alloc] init];
    thirdPartyManager.delegate = responseDelegate;
    return thirdPartyManager;
}

-(id)init
{
    if(self = [super init]){
        tokenInvalidDelegate = self;
        self.tokenInvalid = [[TokenInvalid alloc] init];
        self.tc_commentid = nil;
        self.renren_targetUserId = nil;
        [self initSinaSNSKit:YES];
        [self initTCSNSKit:YES];
        [self initRenRenSNSKit:YES];
    }
    return self;
}

//单例销毁
+(void)attemptDealloc
{
    singleton = nil;
}

#pragma mark - initSnskit
- (void)initSinaSNSKit:(BOOL)dataFromLocalDb
{
    _sinaSnsKit = [[SNSKit alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret appRedirectURI:SinaAppRedirectURI andDelegate:self snstype:SINA
              ];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *Info = [defaults objectForKey:SinaAuthData];
    if ([Info objectForKey:SinaAccessTokenKey] && [Info objectForKey:SinaExpirationDateKey] && [Info objectForKey:SinaUserIDKey])
    {
        _sinaSnsKit.accessToken = [Info objectForKey:SinaAccessTokenKey];
        _sinaSnsKit.expirationDate = [Info objectForKey:SinaExpirationDateKey];
        _sinaSnsKit.userID = [Info objectForKey:SinaUserIDKey];
        _sinaSnsKit.thirdremind_in = [Info objectForKey:SinaThirdRemind_in];
    }else if(dataFromLocalDb){
        LLDAOBase *llDaoBase = [LLDAOBase shardLLDAOBase];
        __block LLDaoModelUser *sinallDaoModelUser = [[LLDaoModelUser alloc] init];
        if([APP_USERID length] > 0){
            [llDaoBase searchWhere:sinallDaoModelUser
                            String:[NSString stringWithFormat:@"userid = \'%@\'",APP_USERID]
                           orderBy:nil
                            offset:0 count:1
                          callback:^(NSArray *resultArray) {
                              if(resultArray.count){
                                  sinallDaoModelUser = [resultArray lastObject];
                                  if([sinallDaoModelUser.isBindSina isEqualToString:@"1"] || [sinallDaoModelUser.isBindSina isEqualToString:@"2"]){
                                      if ([UN_NIL(sinallDaoModelUser.bindSinaAuthInfo) isEqualToString:@""] == NO) {
                                          NSError *parseError = nil;
                                          NSDictionary *dic = [JsonParseUtil parseJSONData:sinallDaoModelUser.bindSinaAuthInfo error:&parseError];
                                          if(parseError){
                                              //                                          [root setObject:[[NSNumber alloc] initWithInt:RIA_RESPONSE_CODE_FAILURE]  forKey:@"status"];
                                          }else{
                                              _sinaSnsKit.accessToken = [dic objectForKey:SinaAccessTokenKey];
                                              _sinaSnsKit.userID = [dic objectForKey:SinaUserIDKey];
                                              _sinaSnsKit.thirdremind_in = [dic objectForKey:SinaThirdRemind_in];
                                              NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                              [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                              NSDate* date = [formatter dateFromString:[dic objectForKey:SinaExpirationDateKey]];
                                              _sinaSnsKit.expirationDate = date;
                                              _sinaSnsKit.nickname = [dic objectForKey:THIRDPARTYNICKNAME];
                                              
                                          }
                                          
                                      }
                                  }
                              }
                              
                          }];
        }
    }
}

- (void)initTCSNSKit:(BOOL)dataFromLocalDb
{
    _tcSnsKit = [[SNSKit alloc] initWithAppKey:TCAppKey appSecret:TCAppSecret appRedirectURI:TCAppRedirectURI andDelegate:self snstype:TC
                   ];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *Info = [defaults objectForKey:TCAuthData];
    if ([Info objectForKey:TCAccessTokenKey] && [Info objectForKey:TCExpirationDateKey] && [Info objectForKey:TCUserIDKey])
    {
        _tcSnsKit.accessToken = [Info objectForKey:TCAccessTokenKey];
        _tcSnsKit.expirationDate = [Info objectForKey:TCExpirationDateKey];
        _tcSnsKit.userID = [Info objectForKey:TCUserIDKey];
        _tcSnsKit.thirdremind_in = [Info objectForKey:TCthirdremind_in];
        _tcSnsKit.tcopenkey = [Info objectForKey:TCopenkey];
        _tcSnsKit.refreshToken = [Info objectForKey:TCRefresh_token];
    }else if(dataFromLocalDb){
        LLDAOBase *llDaoBase = [LLDAOBase shardLLDAOBase];
        __block LLDaoModelUser *tcllDaoModelUser = [[LLDaoModelUser alloc] init];
        if([APP_USERID length] > 0){
            [llDaoBase searchWhere:tcllDaoModelUser
                            String:[NSString stringWithFormat:@"userid = \'%@\'",APP_USERID]
                           orderBy:nil
                            offset:0 count:1
                          callback:^(NSArray *resultArray) {
                              if(resultArray.count){
                                  tcllDaoModelUser = [resultArray lastObject];
                                  NSLog(@"%@", tcllDaoModelUser.isBindTC);
                                  if([tcllDaoModelUser.isBindTC isEqualToString:@"1"] || [tcllDaoModelUser.isBindTC isEqualToString:@"2"]){
                                      NSLog(@"%@", tcllDaoModelUser.bindTCAuthInfo);
                                      if ([UN_NIL(tcllDaoModelUser.bindTCAuthInfo) isEqualToString:@""] == NO) {
                                          NSError *parseError = nil;
                                          NSDictionary *dic = [JsonParseUtil parseJSONData:tcllDaoModelUser.bindTCAuthInfo error:&parseError];
                                          if(parseError){
                                              //                                          [root setObject:[[NSNumber alloc] initWithInt:RIA_RESPONSE_CODE_FAILURE]  forKey:@"status"];
                                          }else{
                                              _tcSnsKit.accessToken = [dic objectForKey:TCAccessTokenKey];
                                              _tcSnsKit.userID = [dic objectForKey:TCUserIDKey];
                                              _tcSnsKit.thirdremind_in = [dic objectForKey:TCthirdremind_in];
                                              NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                              [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                              NSDate* date = [formatter dateFromString:[dic objectForKey:TCExpirationDateKey]];
                                              _tcSnsKit.expirationDate = date;
                                              _tcSnsKit.tcopenkey = [dic objectForKey:TCopenkey];
                                              _tcSnsKit.refreshToken = [dic objectForKey:TCRefresh_token];
                                              _tcSnsKit.nickname = [dic objectForKey:THIRDPARTYNICKNAME];
                                          }
                                          
                                      }
                                  }
                              }
                              
                          }];
        }
    }
}

- (void)initRenRenSNSKit:(BOOL)dataFromLocalDb
{
    _renRenSnsKit = [[SNSKit alloc] init];
//    _renRenSnsKit = [[SNSKit alloc] initWithAppKey:RENRENAppKey appSecret:RENRENAppSecret appRedirectURI:RENRENAppRedirectURI andDelegate:self snstype:RENREN
//                ];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *Info = [defaults objectForKey:RENRENAuthData];
//    if ([Info objectForKey:RENRENAccessTokenKey] && [Info objectForKey:RENRENExpirationDateKey] && [Info objectForKey:RENRENSECRETKey])
//    {
//        _renRenSnsKit.accessToken = [Info objectForKey:RENRENAccessTokenKey];
//        _renRenSnsKit.expirationDate = [Info objectForKey:RENRENExpirationDateKey];
//        _renRenSnsKit.secret = [Info objectForKey:RENRENSECRETKey];
//        _renRenSnsKit.sessionkey = [Info objectForKey:RENRENSESSIONkey];
//        _renRenSnsKit.userID = [Info objectForKey:RENRENUserIDKey];
//    }
    [RennClient initWithAppId:RENRENAppId apiKey:RENRENAPIKey secretKey:RENRENSECRETKey];
    //不设置则默认使用bearer token
    //[RennClient setTokenType:@"mac"];
    
    //不设置则获取默认权限
    [RennClient setScope:@"read_user_blog read_user_photo read_user_status read_user_album read_user_comment read_user_share publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed operate_like"];
    LLDAOBase *llDaoBase = [LLDAOBase shardLLDAOBase];
    __block LLDaoModelUser *renrenllDaoModelUser = [[LLDaoModelUser alloc] init];
    if([APP_USERID length] > 0 && dataFromLocalDb){
        [llDaoBase searchWhere:renrenllDaoModelUser
                        String:[NSString stringWithFormat:@"userid = \'%@\'",APP_USERID]
                       orderBy:nil
                        offset:0 count:1
                      callback:^(NSArray *resultArray) {
                          if(resultArray.count){
                              renrenllDaoModelUser = [resultArray lastObject];
                              NSLog(@"%@", renrenllDaoModelUser.isBindRENREN);
                              if([renrenllDaoModelUser.isBindRENREN isEqualToString:@"1"] || [renrenllDaoModelUser.isBindRENREN isEqualToString:@"2"]){
                                  NSLog(@"%@", renrenllDaoModelUser.bindRENRENAuthInfo);
                                  if ([UN_NIL(renrenllDaoModelUser.bindRENRENAuthInfo) isEqualToString:@""] == NO) {
                                      NSError *parseError = nil;
                                      NSDictionary *dic = [JsonParseUtil parseJSONData:renrenllDaoModelUser.bindRENRENAuthInfo error:&parseError];
                                      if(parseError){
                                          //                                          [root setObject:[[NSNumber alloc] initWithInt:RIA_RESPONSE_CODE_FAILURE]  forKey:@"status"];
                                      }else{
                                          _renRenSnsKit.accessToken = [dic objectForKey:RENRENAccessTokenKey];
                                          _renRenSnsKit.nickname = [dic objectForKey:THIRDPARTYNICKNAME];
                                          _renRenSnsKit.userID = [dic objectForKey:RENRENUserIDKey];
                                      }
                                      
                                  }
                              }
                          }
                          
                      }];
    }
}

- (void)logout:(NSString*)snstype
{
    if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_SINA]){
        [[[ThirdPartyManager defaultThirdPartyManager] sinaSnsKit] logOut];
        _sinaSnsKit = nil;
        [[ThirdPartyManager defaultThirdPartyManager] initSinaSNSKit:YES];
    }else if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_TC]){
        [[[ThirdPartyManager defaultThirdPartyManager] tcSnsKit] logOut];
        _tcSnsKit = nil;
        [[ThirdPartyManager defaultThirdPartyManager] initTCSNSKit:YES];
    }if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_RENREN]){
//        [[[ThirdPartyManager defaultThirdPartyManager] renRenSnsKit] logOut];
        [RennClient logoutWithDelegate:self];
        [RennClient initWithAppId:RENRENAppId apiKey:RENRENAPIKey secretKey:RENRENSECRETKey];
        _renRenSnsKit = nil;
        [self initRenRenSNSKit:YES];
//        [[ThirdPartyManager defaultThirdPartyManager] initRenRenSNSKit];
    }
}

- (void)logoutMyInit:(NSString*)snstype
{
    if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_SINA]){
        [[[ThirdPartyManager defaultThirdPartyManager] sinaSnsKit] logOut];
        _sinaSnsKit = nil;
        [[ThirdPartyManager defaultThirdPartyManager] initSinaSNSKit:NO];
    }else if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_TC]){
        [[[ThirdPartyManager defaultThirdPartyManager] tcSnsKit] logOut];
        _tcSnsKit = nil;
        [[ThirdPartyManager defaultThirdPartyManager] initTCSNSKit:NO];
    }if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_RENREN]){
        //        [[[ThirdPartyManager defaultThirdPartyManager] renRenSnsKit] logOut];
        [RennClient logoutWithDelegate:self];
        [RennClient initWithAppId:RENRENAppId apiKey:RENRENAPIKey secretKey:RENRENSECRETKey];
        _renRenSnsKit = nil;
        [self initRenRenSNSKit:NO];
        //        [[ThirdPartyManager defaultThirdPartyManager] initRenRenSNSKit];
    }
}

- (void)logoutRenren{
    [[[ThirdPartyManager defaultThirdPartyManager] renRenSnsKit] logOut];
    _renRenSnsKit = nil;
    [self initRenRenSNSKit:YES];
}

#pragma mark - SNSKitDelegate
- (void)snskitDidLogIn:(SNSKit *)snskit
{
    if(snskit == _sinaSnsKit){
        [snskit requestWithURL:@"users/show.json"
                        params:[NSMutableDictionary dictionaryWithObject:snskit.userID forKey:@"uid"]
                    httpMethod:@"GET"
                      delegate:self];
    }else if(snskit == _renRenSnsKit){
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:10];
        
       
        [params setValue:[NSString stringWithFormat:@"uid,name,sex,birthday,headurl"] forKey:@"fields"];
        [snskit requestWithURL:@"users.getInfo"
                        params:params
                    httpMethod:@"POST" delegate:self];
    }else if(snskit == _tcSnsKit){
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:10];
        
        [snskit requestWithURL:@"user/info"
                                  params:params
                              httpMethod:@"GET"
                                delegate:self];
    }
    NSLog(@"snskitDidLogIn");
    //    SNSKit *loginsnskit = [self snskit];
}
- (void)snskitDidLogOut:(SNSKit *)snskit
{
    NSLog(@"snskitDidLogOut");
    
}

- (void)snskitLogInDidCancel:(SNSKit *)snskit
{
    NSLog(@"snskitLogInDidCancel");
    
}

- (void)snskit:(SNSKit *)snskit logInDidFailWithError:(NSError *)error
{
    NSLog(@"logInDidFailWithError");
}

- (void)snskit:(SNSKit *)snskit accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"accessTokenInvalidOrExpired");
    if([snskit getSNSType] == SINA){
        //ADD: FOR TOKEN过期
        [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA];
        [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_SINA];
    }else if([snskit getSNSType] == TC){
        //ADD: FOR TOKEN过期
        [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_TC];
        [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_TC];
    }else if([snskit getSNSType] == RENREN){
        //ADD: FOR TOKEN过期
        [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_RENREN];
        [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_RENREN];
    }
    
}


#pragma mark - SNSKitRequestDelegate
- (void)request:(SNSKitRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    
}
- (void)request:(SNSKitRequest *)request didReceiveRawData:(NSData *)data
{
    NSLog(@"didReceiveRawData");
    NSString *responseContent = [[NSString alloc] initWithData:(NSData*)data encoding:NSUTF8StringEncoding];
    NSDictionary * dic = [responseContent JSONValue];
    if ([request.url rangeOfString:@"t/add_pic"].location != NSNotFound)
    {
    } else if ([request.url rangeOfString:@"statuses/upload.json"].location != NSNotFound) {
        
        if (dic != nil) {
            if ([[dic objectForKey:@"error"] isEqualToString:@"repeat content!"]) {
//                [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_SEND_PICWEIBO_SINA];
            }
        }
    }else if([[request.params objectForKey:@"method"] isEqualToString:@"photos.upload"]){
        
    }else if ([request.url rangeOfString:@"comments/create.json"].location != NSNotFound) {
        
        if (dic != nil) {
            if ([[dic objectForKey:@"error"] isEqualToString:@"repeat content!"]) {
                //                [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_SEND_PICWEIBO_SINA];
            }
        }
    }else if([request.url rangeOfString:@"comments/reply.json"].location != NSNotFound){
        if (dic != nil) {
            if ([[dic objectForKey:@"error"] isEqualToString:@"repeat content!"]) {
                //                [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_SEND_PICWEIBO_SINA];
            }
        }
    }
}

- (void)request:(SNSKitRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    if([request.url rangeOfString:@"statuses/upload_url_text.json"].location != NSNotFound){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_SEND_URLWEIBO_SINA];
        }
    }else if([request.url rangeOfString:@"t/add_pic_url"].location != NSNotFound){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_SEND_URLPICWEIBO_TC];
        }
    }
    else if ([request.url rangeOfString:@"t/add_pic"].location != NSNotFound)
    {
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_SEND_PICWEIBO_TC];
        }
    } else if ([request.url rangeOfString:@"statuses/upload.json"].location != NSNotFound) {
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_SEND_PICWEIBO_SINA];
        }
        
    }else if([[request.params objectForKey:@"method"] isEqualToString:@"photos.upload"]){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_RENREN Sharetype:SNSKIT_SEND_PICWEIBO_RENREN];
        }
    }else if([request.url rangeOfString:@"t/comment"].location != NSNotFound && self.tc_commentid == nil)
    {
        self.tc_commentid = nil;
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_COMMENT_WEIBO_TC];
        }
    }else if([request.url rangeOfString:@"t/comment"].location != NSNotFound && self.tc_commentid != nil)
    {
        self.tc_commentid = nil;
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_REPLY_COMMENT_TC];
        }
    }else if([request.url rangeOfString:@"comments/create.json"].location != NSNotFound)
    {
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_COMMENT_WEIBO_SINA];
        }
    }else if([request.url rangeOfString:@"comments/reply.json"].location != NSNotFound){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_REPLY_COMMENT_SINA];
        }
    }else if([request.url rangeOfString:@"statuses/destroy.json"].location != NSNotFound){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_DELETE_WEIBO_SINA];
        }
    }else if([request.url rangeOfString:@"t/del"].location != NSNotFound){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_DELETE_WEIBO_TC];
        }
    }else if([request.url rangeOfString:@"friendships/create.json"].location != NSNotFound){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_ATTENTION_WEIBO_SINA];
        }
    }else if([request.url rangeOfString:@"friends/add"].location != NSNotFound){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_ATTENTION_WEIBO_TC];
        }
    }else if([request.url rangeOfString:@"comments/show.json"].location != NSNotFound){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_GETCOMMENTS_WEIBO_SINA];
        }
    }else if([request.url rangeOfString:@"t/re_list"].location != NSNotFound){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_GETCOMMENTS_WEIBO_TC];
        }
    }else if([request.url rangeOfString:@"friendships/friends/bilateral.json"].location != NSNotFound){
        
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_GETFRIENDS_WEIBO_SINA];
        }
        
    }else if([request.url rangeOfString:@"friends/mutual_list"].location != NSNotFound){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_GETFRIENDS_WEIBO_TC];
        }
    }else if([request.url rangeOfString:@"comments/reply.json"].location != NSNotFound){
        if ([delegate respondsToSelector:@selector(shareFail:Sharetype:)]) {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_REPLY_COMMENT_SINA];
        }
    }
    
}
- (void)request:(SNSKitRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"didFinishLoadingWithResult");
    NSLog(@"didFinishLoadingWithResult  %@", result);
    /**
     *获取用户信息
     */
    if ([request.url rangeOfString:@"users/show.json"].location != NSNotFound)
    {
        _userInfo = result;
        [delegate response:SNSKIT_BIND_USERINFO_SINA responseValue:_userInfo];
    }
    if ([request.url rangeOfString:@"user/info"].location != NSNotFound)
    {
        _userInfo = result;
        [delegate response:SNSKIT_BIND_USERINFO_TC responseValue:_userInfo];
    }
    if([[request.params objectForKey:@"method"] isEqualToString:@"users.getInfo"]){
        _userInfo = result;
        [delegate response:SNSKIT_BIND_USERINFO_RENREN responseValue:_userInfo];
    }
    
    /**
     *发送带有URL的微博
     */
    if([request.url rangeOfString:@"statuses/upload_url_text.json"].location != NSNotFound){
        NSLog(@"send sina weibo result===%@===sinaweibo[%@]",result, [result objectForKey:@"id"]);
        NSString * sinawbid =  [result objectForKey:@"id"];
        if (sinawbid) {
            _userInfo = result;
            [delegate response:SNSKIT_SEND_URLWEIBO_SINA responseValue:_userInfo];
        } else {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_SEND_URLWEIBO_SINA];
        }
        
    }else if([request.url rangeOfString:@"t/add_pic_url"].location != NSNotFound){
        NSString * ret = (NSString*)[result objectForKey:@"ret"];
        int status = [ret intValue];
        if (status == 0) {
            _userInfo = result;
            [delegate response:SNSKIT_SEND_URLPICWEIBO_TC responseValue:_userInfo];
        } else {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_SEND_URLPICWEIBO_TC];
        }
    }
    /**
     *发送微博
     */
    else if ([request.url rangeOfString:@"t/add_pic"].location != NSNotFound)
    {
        NSString * ret = (NSString*)[result objectForKey:@"ret"];
        int status = [ret intValue];
        if (status == 0) {
            _userInfo = result;
            [delegate response:SNSKIT_SEND_PICWEIBO_TC responseValue:_userInfo];
        } else {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_SEND_PICWEIBO_TC];
        }
        
    } else if ([request.url rangeOfString:@"statuses/upload.json"].location != NSNotFound) {
        
        NSLog(@"send sina weibo result===%@===sinaweibo[%@]",result, [result objectForKey:@"id"]);
        NSString * sinawbid =  [result objectForKey:@"id"];
        if (sinawbid) {
            _userInfo = result;
            [delegate response:SNSKIT_SEND_PICWEIBO_SINA responseValue:_userInfo];
        } else {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_SEND_PICWEIBO_SINA];
        }
        
    }
    
    /**
     *评论微博
     */
    
    if([request.url rangeOfString:@"t/comment"].location != NSNotFound && self.tc_commentid == nil)  //评论
    {
        self.tc_commentid = nil;
        NSString * ret = (NSString*)[result objectForKey:@"ret"];
        int status = [ret intValue];
        if (status == 0) {
            _userInfo = result;
            [delegate response:SNSKIT_COMMENT_WEIBO_TC responseValue:_userInfo];
        } else {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_COMMENT_WEIBO_TC];
        }
    }else if([request.url rangeOfString:@"t/comment"].location != NSNotFound && self.tc_commentid != nil ){      //回复
        self.tc_commentid = nil;
        NSString * ret = (NSString*)[result objectForKey:@"ret"];
        int status = [ret intValue];
        if (status == 0) {
            _userInfo = result;
            [delegate response:SNSKIT_REPLY_COMMENT_TC responseValue:_userInfo];
        } else {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_REPLY_COMMENT_TC];
        }
    }else if([request.url rangeOfString:@"comments/create.json"].location != NSNotFound)
    {
        if([result objectForKey:@"id"] != nil){
            _userInfo = result;
            [delegate response:SNSKIT_COMMENT_WEIBO_SINA responseValue:_userInfo];
        }else{
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_COMMENT_WEIBO_SINA];
        }
    }else if([request.url rangeOfString:@"comments/reply.json"].location != NSNotFound){
        if([result objectForKey:@"id"] != nil){
            _userInfo = result;
            [delegate response:SNSKIT_REPLY_COMMENT_SINA responseValue:_userInfo];
        }else{
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_REPLY_COMMENT_SINA];
        }
    }
    //else  人人网评论
    
    /**
     *删除微博
     */
    if([request.url rangeOfString:@"t/del"].location != NSNotFound)
    {
        NSString * ret = (NSString*)[result objectForKey:@"ret"];
        int status = [ret intValue];
        if (status == 0) {
            _userInfo = result;
            [delegate response:SNSKIT_DELETE_WEIBO_TC responseValue:_userInfo];
        } else {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_COMMENT_WEIBO_TC];
        }
    }else if([request.url rangeOfString:@"statuses/destroy.json"].location != NSNotFound)
    {
        if([result objectForKey:@"id"] != nil){
            _userInfo = result;
            [delegate response:SNSKIT_DELETE_WEIBO_SINA responseValue:_userInfo];
        }else{
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_COMMENT_WEIBO_SINA];
        }
    }
    //else  删除人人网发送信息
    
    /**
     *关注某人
     */
    if([request.url rangeOfString:@"friendships/create.json"].location != NSNotFound){
        if([result objectForKey:@"id"] != nil){
            _userInfo = result;
            [delegate response:SNSKIT_ATTENTION_WEIBO_SINA responseValue:_userInfo];
        }else{
            [delegate shareFail:THIRDPARTY_SNS_TYPE_SINA Sharetype:SNSKIT_ATTENTION_WEIBO_SINA];
        }
    }else if([request.url rangeOfString:@"friends/add"].location != NSNotFound){
        NSString * ret = (NSString*)[result objectForKey:@"ret"];
        int status = [ret intValue];
        if (status == 0) {
            _userInfo = result;
            [delegate response:SNSKIT_ATTENTION_WEIBO_TC responseValue:_userInfo];
        } else {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_ATTENTION_WEIBO_TC];
        }
    }
    //else  关注人人网好友
    
    /**
     *获取微博评论
     */
    if([request.url rangeOfString:@"comments/show.json"].location != NSNotFound){
        _userInfo = result;
        [delegate response:SNSKIT_GETCOMMENTS_WEIBO_SINA responseValue:_userInfo];
    }else if([request.url rangeOfString:@"t/re_list"].location != NSNotFound){
        NSString * ret = (NSString*)[result objectForKey:@"ret"];
        int status = [ret intValue];
        if (status == 0) {
            _userInfo = result;
            [delegate response:SNSKIT_GETCOMMENTS_WEIBO_TC responseValue:_userInfo];
        } else {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_GETCOMMENTS_WEIBO_TC];
        }
    }
    
    /**
     *获取互相关注的好友信息
     */
    if([request.url rangeOfString:@"friendships/friends/bilateral.json"].location != NSNotFound){
        _userInfo = result;
        [delegate response:SNSKIT_GETFRIENDS_WEIBO_SINA responseValue:_userInfo];
    }else if([request.url rangeOfString:@"friends/mutual_list"].location != NSNotFound){
        NSString * ret = (NSString*)[result objectForKey:@"ret"];
        int status = [ret intValue];
        if (status == 0) {
            _userInfo = result;
            [delegate response:SNSKIT_GETFRIENDS_WEIBO_TC responseValue:_userInfo];
        } else {
            [delegate shareFail:THIRDPARTY_SNS_TYPE_TC Sharetype:SNSKIT_GETFRIENDS_WEIBO_TC];
        }
    }

}

#pragma mark - login 
- (void)loginThirtyParty:(NSString*)snstype{
    if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_SINA]){
        [_sinaSnsKit logIn];
    }else if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_TC]){
        [_tcSnsKit logIn];
    }else if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_RENREN]){
//        [_renRenSnsKit logIn];
        [RennClient loginWithDelegate:self];
    }
}

#pragma mark - RennLoginDelegate
- (void)rennLoginSuccess{
    NSLog(@"rennLoginSuccess");
    GetUserParam *param = [[GetUserParam alloc] init];
    param.userId = [RennClient uid];
    [RennClient sendAsynRequest:param delegate:self];
}
- (void)getRenRenUserInformation:(NSString*)userid{
    GetUserParam *param = [[GetUserParam alloc] init];
    param.userId = userid;
    [RennClient sendAsynRequest:param delegate:self];
}
- (void)rennLogoutSuccess{
    NSLog(@"rennLogoutSuccess");
}

- (void)rennLoginCancelded{
    NSLog(@"rennLoginCancelded");
}

- (void)rennLoginDidFailWithError:(NSError *)error{
    NSLog(@"rennLoginDidFailWithError");
}

- (void)rennLoginAccessTokenInvalidOrExpired:(NSError *)error{
    NSLog(@"rennLoginAccessTokenInvalidOrExpired");
}

#pragma mark - RennServiveDelegate
    
- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response;
{
    //NSLog(@"requestSuccessWithResponse:%@", [response description]);
    //    NSDictionary *dic = [response JSONValue];
    NSLog(@"requestSuccessWithResponse  %@", response);
    //    NSLog(@"requestSuccessWithResponse:%@", [[SBJson new]  stringWithObject:response error:nil]);
    NSLog(@"请求成功:%@", service.type);
    if([service.type isEqualToString:@"GetUser"]){
        [delegate response:SNSKIT_BIND_USERINFO_RENREN responseValue:response];
    }else if([service.type isEqualToString:@"UploadPhoto"]){
        [delegate response:SNSKIT_SEND_PICWEIBO_RENREN responseValue:response];
    }else if([service.type isEqualToString:@"PutComment"] && self.renren_targetUserId == nil){
        self.renren_targetUserId = nil;
        [delegate response:SNSKIT_COMMENT_WEIBO_RENREN responseValue:response];
    }else if([service.type isEqualToString:@"PutComment"] && self.renren_targetUserId != nil){
        self.renren_targetUserId = nil;
        [delegate response:SNSKIT_REPLY_COMMENT_RENREN responseValue:response];
    }else if([service.type isEqualToString:@"ListComment"]){
        [delegate response:SNSKIT_GETCOMMENTS_WEIBO_RENREN responseValue:response];
    }else if([service.type isEqualToString:@"ListUserFriend"]){
        [delegate response:SNSKIT_GETFRIENDS_WEIBO_RENREN responseValue:response];
    }else if([service.type isEqualToString:@"PutShareUrl"]){
        [delegate response:SNSKIT_SEND_URLPICWEIBO_RENREN responseValue:response];
    }
}
    
- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
    {
        //NSLog(@"requestFailWithError:%@", [error description]);
        NSString *domain = [error domain];
        NSString *code = [[error userInfo] objectForKey:@"code"];
        NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@ Error:%@", domain, code,error);
        NSLog(@"请求失败: %@", domain);
        
        if([service.type isEqualToString:@"GetUser"]){
            [delegate shareFail:THIRDPARTY_SNS_TYPE_RENREN Sharetype:SNSKIT_BIND_USERINFO_RENREN];
        }else if([service.type isEqualToString:@"UploadPhoto"]){
            [delegate shareFail:THIRDPARTY_SNS_TYPE_RENREN Sharetype:SNSKIT_SEND_PICWEIBO_RENREN];
        }else if([service.type isEqualToString:@"PutComment"] && self.renren_targetUserId == nil){
            self.renren_targetUserId = nil;
            [delegate shareFail:THIRDPARTY_SNS_TYPE_RENREN Sharetype:SNSKIT_COMMENT_WEIBO_RENREN];
        }else if([service.type isEqualToString:@"ListComment"]){
            [delegate shareFail:THIRDPARTY_SNS_TYPE_RENREN Sharetype:SNSKIT_GETCOMMENTS_WEIBO_RENREN];
        }else if([service.type isEqualToString:@"PutComment"] && self.renren_targetUserId != nil){
            self.renren_targetUserId = nil;
           [delegate shareFail:THIRDPARTY_SNS_TYPE_RENREN Sharetype:SNSKIT_REPLY_COMMENT_RENREN];
        }else if([service.type isEqualToString:@"ListUserFriend"]){
            [delegate shareFail:THIRDPARTY_SNS_TYPE_RENREN Sharetype:SNSKIT_GETFRIENDS_WEIBO_RENREN];
        }else if([service.type isEqualToString:@"PutShareUrl"]){
            [delegate shareFail:THIRDPARTY_SNS_TYPE_RENREN Sharetype:SNSKIT_SEND_URLPICWEIBO_RENREN];
        }
}
    
#pragma mark - 发送微博  （发送文字+发送文字及图片）
//发送文字及图片
-(void)sendContentAndPic:(NSString *)content uploadImage:(UIImage *)image WeiboType:(int)weibotype{
    
    
    if(weibotype == SNSKIT_SEND_PICWEIBO_SINA){
        if(_sinaSnsKit.isAuthValid){
            NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           content,@"status",
                                           image,@"pic",
                                           nil];
            [_sinaSnsKit requestWithURL:@"statuses/upload.json"
                                 params:params
                             httpMethod:@"POST"
                               delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_SINA];
        }
        

    }else if(weibotype == SNSKIT_SEND_PICWEIBO_TC){
        if(_tcSnsKit.isAuthValid){
            NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           content,@"content",
                                           image,@"pic",
                                           nil];

            [_tcSnsKit requestWithURL:@"t/add_pic"
                               params:params
                           httpMethod:@"POST"
                             delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_TC];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_TC];
        }
        
    }else if(weibotype == SNSKIT_SEND_PICWEIBO_RENREN){
        if([RennClient isAuthorizeValid]){
            
//            NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
//            if (image != nil) {
//                [params setObject:image forKey:@"upload"];
//            }
//            
//            if (content != nil && ![content isEqualToString:@""]) {
//                [params setObject:content forKey:@"caption"];
//            }
//            [_renRenSnsKit requestWithURL:@"photos.upload"
//                               params:params
//                           httpMethod:@"POST"
//                             delegate:self];
            UploadPhotoParam *param = [[UploadPhotoParam alloc] init];
            param.description = content;
            //            param.file = UIImagePNGRepresentation([UIImage imageNamed:@"test.png"]);
            if (UIImagePNGRepresentation(image) == nil) {
                
                param.file = UIImageJPEGRepresentation(image, 1);
                
            } else {
                
                param.file = UIImagePNGRepresentation(image);
            }
            [RennClient sendAsynRequest:param delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_RENREN];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_RENREN];
        }
    }
}

//发送文字及Url
//weibotype 微博类型
-(void)sendContentAndUrl:(NSString *)content ShareUrl:(NSString *)shareUrl WeiboType:(int)weibotype{
    if(weibotype == SNSKIT_SEND_URLWEIBO_SINA){
        if(_sinaSnsKit.isAuthValid){
//            shareUrl = @"";
            NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           content,@"status",
                                           shareUrl,@"url",
                                           nil];
            [_sinaSnsKit requestWithURL:@"statuses/upload_url_text.json"
                                 params:params
                             httpMethod:@"POST"
                               delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_SINA];
        }
    }else if(weibotype == SNSKIT_SEND_URLPICWEIBO_TC){
        if(_tcSnsKit.isAuthValid){
            NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           content,@"content",
                                           shareUrl,@"pic_url",
                                           @"0",@"compatibleflag",nil];
            
            [_tcSnsKit requestWithURL:@"t/add_pic_url"
                               params:params
                           httpMethod:@"POST"
                             delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_TC];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_TC];
        }
    }else if(weibotype == SNSKIT_SEND_URLPICWEIBO_RENREN){
        if([RennClient isAuthorizeValid]){
            PutShareUrlParam *param = [[PutShareUrlParam alloc] init];
            param.comment = content;
            param.url = shareUrl;
            [RennClient sendAsynRequest:param delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_RENREN];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_RENREN];
        }
    }

}

#pragma mark - 评论微博
//评论微博
-(void)commentWeibo:(NSString *)content weiboid:(NSString *)weiboid  WeiboType:(int)weibotype{
    
    if(weibotype == SNSKIT_COMMENT_WEIBO_SINA){
        if(_sinaSnsKit.isAuthValid){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:10];
            [dic setObject:weiboid forKey:@"id"];//评论id
            [dic setObject:content forKey:@"comment"];
            [_sinaSnsKit requestWithURL:@"comments/create.json"
                             params:dic
                         httpMethod:@"POST"
                           delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_SINA];
        }
    }else if(weibotype == SNSKIT_COMMENT_WEIBO_TC){
        if(_tcSnsKit.isAuthValid){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:10];
            [dic setObject:weiboid forKey:@"reid"];//评论id
            [dic setObject:content forKey:@"content"];
            [dic setObject:[@"" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"test"];
            [_tcSnsKit requestWithURL:@"t/comment"
                               params:dic
                           httpMethod:@"POST"
                             delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_TC];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_TC];
        }
        
    }else if(weibotype == SNSKIT_COMMENT_WEIBO_RENREN){
        if([RennClient isAuthorizeValid]){
            
            PutCommentParam *param = [[PutCommentParam alloc] init];
            param.entryOwnerId = [RennClient uid];
            param.entryId = weiboid;
            param.commentType = kCommentTypePhoto;
            param.content = content;
            [RennClient sendAsynRequest:param delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_RENREN];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_RENREN];
        }
    }//else  人人网评论
}
//回复评论微博
-(void)replyWeiboCommentID:(NSString*)cid content:(NSString *)content weiboid:(NSString *)weiboid  WeiboType:(int)weibotype
              targetUserId:(NSString*) targetUserId{
    
    if(weibotype == SNSKIT_REPLY_COMMENT_SINA){
        if(_sinaSnsKit.isAuthValid){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:10];
            [dic setObject:weiboid forKey:@"id"];//微博id
            [dic setObject:content forKey:@"comment"];
            [dic setObject:cid forKey:@"cid"];//评论id
            [_sinaSnsKit requestWithURL:@"comments/reply.json"
                                 params:dic
                             httpMethod:@"POST"
                               delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA];
            if([delegate respondsToSelector:@selector(tokenInvalid:type:)]){
                [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA type:weibotype];
            }
//            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_SINA];
        }
    }else if(weibotype == SNSKIT_REPLY_COMMENT_TC){
        if(_tcSnsKit.isAuthValid){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:10];
            [dic setObject:cid forKey:@"reid"];//评论id
            [dic setObject:content forKey:@"content"];
            [dic setObject:[@"" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"test"];
            [_tcSnsKit requestWithURL:@"t/comment"
                               params:dic
                           httpMethod:@"POST"
                             delegate:self];
            self.tc_commentid = cid;
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_TC];
            if([delegate respondsToSelector:@selector(tokenInvalid:type:)]){
                [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA type:weibotype];
            }
            self.tc_commentid = nil;
        }
        
    }else if(weibotype == SNSKIT_REPLY_COMMENT_RENREN){
        if([RennClient isAuthorizeValid]){
            
            PutCommentParam *param = [[PutCommentParam alloc] init];
            param.entryOwnerId = [RennClient uid];
            param.entryId = cid;
            param.commentType = kRennServiceTypePutComment;
            param.content = content;
            param.targetUserId = targetUserId;
            [RennClient sendAsynRequest:param delegate:self];
            self.renren_targetUserId = targetUserId;
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_RENREN];
            if([delegate respondsToSelector:@selector(tokenInvalid:type:)]){
                [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA type:weibotype];
            }
            self.renren_targetUserId = nil;
        }
    }//else  人人网评论
}

#pragma mark - 删除微博
//删除微博
-(void)deleteWeibo:(NSString *)weiboid  WeiboType:(int)weibotype{
    if(weibotype == SNSKIT_DELETE_WEIBO_SINA){
        if(_sinaSnsKit.isAuthValid){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:10];
            [dic setObject:weiboid forKey:@"id"];//评论id
            [_sinaSnsKit requestWithURL:@"statuses/destroy.json"
                                 params:dic
                             httpMethod:@"POST"
                               delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_SINA];
        }
    }else if(weibotype == SNSKIT_DELETE_WEIBO_TC){
        if(_tcSnsKit.isAuthValid){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:10];
            [dic setObject:weiboid forKey:@"id"];//评论id
            [_tcSnsKit requestWithURL:@"t/del"
                               params:dic
                           httpMethod:@"POST"
                             delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_TC];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_TC];
        }
        
    }else if(weibotype == SNSKIT_DELETE_WEIBO_RENREN){
        if(_renRenSnsKit.isAuthValid){
            
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_RENREN];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_RENREN];
        }
    }//else  人人网删除
}

#pragma mark - 关注某人
//关注某人  uid和screen_name参数值传递一个既可以 （新浪type：screen_name	 需要关注的用户昵称，腾讯type：name否
//要收听人的微博帐号列表（非昵称），用“,”隔开，例如：abc,bcde,effg（可选，最多30个））
-(void)attentionWeibo:(NSString *)uid nickName:(NSString*)screen_name  WeiboType:(int)weibotype
{
    if(weibotype == SNSKIT_ATTENTION_WEIBO_SINA){
        if(_sinaSnsKit.isAuthValid){
            NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:10];
                [params setObject:uid forKey:@"uid"];
                [params setObject:screen_name forKey:@"screen_name"];
                [_sinaSnsKit requestWithURL:@"friendships/create.json"
                                params:params
                            httpMethod:@"POST"
                              delegate:self] ;
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_SINA];
        }
    }else if(weibotype == SNSKIT_ATTENTION_WEIBO_TC){
        if(_tcSnsKit.isAuthValid){
            NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:10];
            [params setObject:uid forKey:@"fopenids"];
            [params setObject:screen_name forKey:@"name"];
            [_tcSnsKit requestWithURL:@"friends/add"
                              params:params
                          httpMethod:@"POST"
                            delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_TC];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_TC];
        }
        
    }else if(weibotype == SNSKIT_ATTENTION_WEIBO_RENREN){
        if(_renRenSnsKit.isAuthValid){
            
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_RENREN];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_RENREN];
        }
    }//else  人人网删除
}

#pragma mark - 获取微博评论微博
//获取微博评论微博
/**使用说明
 *新浪微博获取评论以后，设置comment_id参数（max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。）
 *腾讯微博获取到评论以后，同时设置comment_id和pagetime参数（m微博id，与pageflag、pagetime共同使用，实现翻页功能（第1页填0，继续向下翻页，填上一次请求返回的最后一条记录id，pagetime本页起始时间，与pageflag、twitterid共同使用，实现翻页功能（第一页：填0，向上翻页：填上一次请求返回的第一条记录时间，向下翻页：填上一次请求返回的最后一条记录时间））
 ）
 */
-(void)getWeiboComment:(NSString *)weiboid Pagesize:(NSString *)Pagesize
                  Page:(int)page Comment_ID:(NSString *)comment_id pagetime:(NSString *)pagetime WeiboType:(int)weibotype
{
    if(weibotype == SNSKIT_GETCOMMENTS_WEIBO_SINA){
        
        if(_sinaSnsKit.isAuthValid){
            NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:10];
            [params setObject:UN_NIL(_sinaSnsKit.userID) forKey:@"uid"];
            [params setObject:weiboid forKey:@"id"];
            [params setObject:Pagesize forKey:@"count"];
            if(page > 0){
                [params setObject:UN_NIL(comment_id) forKey:@"max_id"];
                [params setObject:Pagesize forKey:@"page"];
            }
            
            [_sinaSnsKit requestWithURL:@"comments/show.json"
                             params:params
                         httpMethod:@"GET"
                           delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_SINA];
        }
    }else if(weibotype == SNSKIT_GETCOMMENTS_WEIBO_TC){
        if(_tcSnsKit.isAuthValid){
            NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:10];
            [params setObject:weiboid forKey:@"rootid"];
            [params setObject:@"1" forKey:@"flag"];// 类型标识。0－转播列表，1－点评列表，2－点评与转播列表
            [params setObject:@"1" forKey:@"pageflag"];//分页标识，用于翻页（0：第一页，1：向下翻页，2：向上翻页）
            [params setObject:Pagesize forKey:@"reqnum"];//每次请求记录的条数（1-100条）,默认为20条
            if(page == 0){
                comment_id = @"";
            }else{
                [params setObject:pagetime forKey:@"pagetime"];
            }
            [params setObject:comment_id forKey:@"twitterid"];//微博id，与pageflag、pagetime共同使用，实现翻页功能（第1页填0，继续向下翻页，填上一次请求返回的最后一条记录id）

            [_tcSnsKit requestWithURL:@"t/re_list"
                               params:params
                           httpMethod:@"GET"
                             delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_TC];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_TC];
        }
        
    }else if(weibotype == SNSKIT_GETCOMMENTS_WEIBO_RENREN){
        if([RennClient isAuthorizeValid]){
            ListCommentParam *param = [[ListCommentParam alloc] init];
            param.entryOwnerId = [RennClient uid];
            param.entryId = weiboid;
            param.commentType = kCommentTypePhoto;
            param.pageNumber = page;
            param.pageSize = [Pagesize integerValue];
            [RennClient sendAsynRequest:param delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_RENREN];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_RENREN];
        }
    }//else  人人网获取评论
}

#pragma mark - 获取好友列表
//获取获取微博好友列表
/**
 *pageSize  每页请求数量
 *page  新浪请求第几页数据
 *startpos  腾讯开始的下一个索引
 *name 腾讯需要传递用户昵称  可以为空串
 */
-(void)getweiboFriends:(NSString*)pageSize SinaPage:(NSString*)page TC_startpos:(NSString *)startpos TCName:(NSString*)nam WeiboType:(int)weibotype{
    if(weibotype == SNSKIT_GETFRIENDS_WEIBO_SINA){
        
        if(_sinaSnsKit.isAuthValid){
            NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:10];
            [params setValue:_sinaSnsKit.userID  forKey:@"uid"];
            [params setValue:page forKey:@"page"];
            [params setValue:pageSize forKey:@"count"];
            [_sinaSnsKit requestWithURL:@"friendships/friends/bilateral.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self] ;
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_SINA];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_SINA];
        }
    }else if(weibotype == SNSKIT_GETFRIENDS_WEIBO_TC){
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:10];
        if(_tcSnsKit.isAuthValid){
            [params setValue:_tcSnsKit.userID forKey:@"fopenid"];
            [params setValue:startpos forKey:@"startindex"];
            [params setValue:pageSize forKey:@"reqnum"];
            [_tcSnsKit requestWithURL:@"friends/mutual_list"
                              params:params
                          httpMethod:@"GET"
                            delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_TC];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_TC];
        }
        
    }else if(weibotype == SNSKIT_GETFRIENDS_WEIBO_RENREN){
        if([RennClient isAuthorizeValid]){
            ListUserFriendParam *param = [[ListUserFriendParam alloc] init];
            param.userId = [RennClient uid];
            param.pageSize = [pageSize integerValue];
            param.pageNumber = [page integerValue];
            [RennClient sendAsynRequest:param delegate:self];
        }else{
            [delegate tokenInvalid:THIRDPARTY_SNS_TYPE_RENREN];
            [tokenInvalidDelegate tokenInvalidHint:THIRDPARTY_SNS_TYPE_RENREN];
        }
    }//else  人人网获取评论
}

/**
 *获取第三方accessToken
 */
-(NSString*)getAccessToken:(NSString*)snstype ResponseType:(int)reseponsetype{
    NSString* accessToken = @"";
    if(reseponsetype == SNSKIT_BIND_USERINFO_SINA){
        accessToken = _sinaSnsKit.accessToken;
    }else if(reseponsetype == SNSKIT_BIND_USERINFO_RENREN){
        accessToken = [RennClient accessToken].accessToken;
    }else if(reseponsetype == SNSKIT_BIND_USERINFO_TC){
        accessToken = _tcSnsKit.accessToken;
    }
    return UN_NIL(accessToken);
}

/**
 *获取第三方有效时间
 */
-(NSString*)getRemindIn:(NSString*)snstype ResponseType:(int)reseponsetype{
    NSString* expiresIn = @"";
    if(reseponsetype == SNSKIT_BIND_USERINFO_SINA){
        expiresIn = _sinaSnsKit.thirdremind_in;
    }else if(reseponsetype == SNSKIT_BIND_USERINFO_RENREN){
        expiresIn = [[NSString alloc] initWithFormat:@"%d",[RennClient accessToken].expiresIn];
    }else if(reseponsetype == SNSKIT_BIND_USERINFO_TC){
        expiresIn = [[ThirdPartyManager defaultThirdPartyManager] tcSnsKit].thirdremind_in;
    }
    return UN_NIL(expiresIn);
}

/**
 *获取第三方刷新Token
 */
-(NSString*)getRefreshToken:(NSString*)snstype ResponseType:(int)reseponsetype{
    NSString* refresh_token = @"";
    if(reseponsetype == SNSKIT_BIND_USERINFO_SINA){
        refresh_token = _sinaSnsKit.refreshToken == nil ? @"" :_sinaSnsKit.refreshToken;
    }else if(reseponsetype == SNSKIT_BIND_USERINFO_RENREN){
        refresh_token = [RennClient accessToken].refreshToken == nil ? @"" : [RennClient accessToken].refreshToken;
    }else if(reseponsetype == SNSKIT_BIND_USERINFO_TC){
        refresh_token = _tcSnsKit.refreshToken;
    }
    return UN_NIL(refresh_token);
}

/**
 *获取过期时间
 */
-(NSString*)getExpirationTime:(NSString*)snstype ResponseType:(int)reseponsetype{
    NSString* expirationTime = @"";
    if(reseponsetype == SNSKIT_BIND_USERINFO_SINA){
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
        NSString *currentDateStr = [dateFormat stringFromDate:_sinaSnsKit.expirationDate];
        expirationTime = STR_IS_NIL(currentDateStr)?@"":currentDateStr;
    }else if(reseponsetype == SNSKIT_BIND_USERINFO_RENREN){
        expirationTime = @"";
    }else if(reseponsetype == SNSKIT_BIND_USERINFO_TC){
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
        NSString *currentDateStr = [dateFormat stringFromDate:_tcSnsKit.expirationDate];
        expirationTime = STR_IS_NIL(currentDateStr)?@"":currentDateStr;
    }
    return UN_NIL(expirationTime);
}

/**
 *获取腾讯Openkey
 */
-(NSString*)getOpenKey:(NSString*)snstype ResponseType:(int)reseponsetype{
    NSString* openkey = @"";
    if(reseponsetype == SNSKIT_BIND_USERINFO_TC){
        openkey = _tcSnsKit.tcopenkey;
    }
    return openkey;
}

- (BOOL)isThirdPartyAuthValid:(NSString*)snstype{
    if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_SINA]){
        return [self.sinaSnsKit isAuthValid];
    }else if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_TC]){
        return [self.tcSnsKit isAuthValid];
    }else if([snstype isEqualToString:THIRDPARTY_SNS_TYPE_RENREN]){
        return [RennClient isAuthorizeValid];
    }
    return NO;
}

#pragma mark -- SNSKitResponseTokenExpiredDelegate
/**
 token失效的snsType类型==微博类型 SNSKitResponseTokenExpiredDelegate
 */
- (void)tokenInvalidHint:(NSString*)snsType
{
    [[ThirdPartyManager defaultThirdPartyManager] logout:snsType];
    [self.tokenInvalid tokenInvalidBind:snsType];
}
@end
