//
//  ThirdPartyManager.h
//  VideoShare
//
//  Created by qin on 13-5-22.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSKit.h"
#import "../JSON/SBjson.h"
#import "LLDaoModelUser.h"
#import "TokenInvalid.h"

/**
 *微博类型
 */
#define THIRDPARTY_SNS_TYPE_SINA @"1"
#define THIRDPARTY_SNS_TYPE_RENREN @"2"
#define THIRDPARTY_SNS_TYPE_TC @"6"

/**
 *微博请求类型
 */
typedef enum{
    //获取第三方登录用户信息
    SNSKIT_BIND_USERINFO_SINA = 0,
    SNSKIT_BIND_USERINFO_TC = 1,
    SNSKIT_BIND_USERINFO_RENREN = 2,
    
    //发送带图片的微博信息
    SNSKIT_SEND_PICWEIBO_SINA =3,
    SNSKIT_SEND_PICWEIBO_TC =4,
    SNSKIT_SEND_PICWEIBO_RENREN =5,
    //评论微博信息
    SNSKIT_COMMENT_WEIBO_SINA = 6,
    SNSKIT_COMMENT_WEIBO_TC = 7,
    SNSKIT_COMMENT_WEIBO_RENREN = 8,
    //（新浪，腾讯）删除通过第三方发送的信息
    SNSKIT_DELETE_WEIBO_SINA = 9,
    SNSKIT_DELETE_WEIBO_TC = 10,
    SNSKIT_DELETE_WEIBO_RENREN = 11,
    //（新浪，腾讯）关注某人
    SNSKIT_ATTENTION_WEIBO_SINA = 12,
    SNSKIT_ATTENTION_WEIBO_TC = 13,
    SNSKIT_ATTENTION_WEIBO_RENREN = 14,
    //获取评论
    SNSKIT_GETCOMMENTS_WEIBO_SINA = 15,
    SNSKIT_GETCOMMENTS_WEIBO_TC = 16,
    SNSKIT_GETCOMMENTS_WEIBO_RENREN = 17,
    //获取好友列表
    SNSKIT_GETFRIENDS_WEIBO_SINA = 18,
    SNSKIT_GETFRIENDS_WEIBO_TC = 19,
    SNSKIT_GETFRIENDS_WEIBO_RENREN = 20,
    //发送带Url的微博信息
    SNSKIT_SEND_URLWEIBO_SINA =21,
    SNSKIT_SEND_URLPICWEIBO_TC =22,
    SNSKIT_SEND_URLPICWEIBO_RENREN =23,
    
    
    //回复评论信息
    SNSKIT_REPLY_COMMENT_SINA = 24,
    SNSKIT_REPLY_COMMENT_TC = 25,
    SNSKIT_REPLY_COMMENT_RENREN = 26,
}SNKIT_OPERATION;

/**
 * @description 请求回调响应
 */
@protocol SNSKitResponseDelegate <NSObject>
@optional
/**
 成功返回，reseponsetype：微博请求类型（例如：SNSKIT_BIND_USERINFO_SINA或者SNSKIT_BIND_USERINFO_TC）
 操作成功后返回的值responsevalue
 */
- (void)response:(int)reseponsetype responseValue:(NSDictionary *)dic;

/**
 分享失败 sharetype：微博请求类型（例如：SNSKIT_BIND_USERINFO_SINA或者SNSKIT_BIND_USERINFO_TC）
 snsType：第三方类型
 */
- (void)shareFail:(NSString*)snsType Sharetype:(int)sharetype;

/**
 token失效的snsType类型==微博类型
 */
- (void)tokenInvalid:(NSString*)snsType;
@optional
- (void)tokenInvalid:(NSString*)snsType type:(int)type;
@end

/**
 *处理token失效，不需要调用人员处理
 */
@protocol SNSKitResponseTokenExpiredDelegate <NSObject>

/**
 token失效的snsType类型==微博类型
 */
- (void)tokenInvalidHint:(NSString*)snsType;

@end

@interface ThirdPartyManager : NSObject <SNSKitDelegate, SNSKitRequestDelegate, RennLoginDelegate, RennServiveDelegate, SNSKitResponseTokenExpiredDelegate>{
//    NSObject<SNSKitResponseDelegate> * delegate;
    SNSKit *_sinaSnsKit;
    SNSKit *_tcSnsKit;
    SNSKit *_renRenSnsKit;
    NSDictionary *_userInfo;
    TokenInvalid *_tokenInvalid;
    NSString *_tc_commentid;
    NSString *_renren_targetUserId;
}

@property(nonatomic, weak) id<SNSKitResponseDelegate>  delegate;
@property(nonatomic, weak) id<SNSKitResponseTokenExpiredDelegate> tokenInvalidDelegate;
@property (nonatomic, retain) SNSKit *sinaSnsKit;
@property (nonatomic, retain) SNSKit *tcSnsKit;
@property (nonatomic, retain) SNSKit *renRenSnsKit;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) LLDaoModelUser *llDaoModelUser;
@property (nonatomic, strong) TokenInvalid *tokenInvalid;

@property (nonatomic, strong) NSString *tc_commentid;
@property (nonatomic, strong) NSString *renren_targetUserId;

//单利使用
+(ThirdPartyManager *)defaultThirdPartyManager;
//每次都生成一个新的实例对象
+(ThirdPartyManager *)defaultThirdPartyManager:(id<SNSKitResponseDelegate>) responseDelegate;

//单例销毁
+(void)attemptDealloc;

#pragma mark - initSnskit
// dataFromLocalDb  是否从数据库获取授权信息
- (void)initSinaSNSKit:(BOOL)dataFromLocalDb;
- (void)initTCSNSKit:(BOOL)dataFromLocalDb;
- (void)initRenRenSNSKit:(BOOL)dataFromLocalDb;
//是从数据库获取授权信息
- (void)logout:(NSString*)snstype;
//否从数据库获取授权信息
- (void)logoutMyInit:(NSString*)snstype;
- (void)logoutRenren;
- (void)getRenRenUserInformation:(NSString*)userid;

#pragma mark - 发送微博  （发送文字+发送文字及图片）
//发送文字及图片
//weibotype 微博类型
/**
 *新浪 要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
 *腾讯  文件域表单名。本字段不要放在签名的参数中，不然请求时会出现签名错误，图片大小限制在4M。
 **/
-(void)sendContentAndPic:(NSString *)content uploadImage:(UIImage *)image WeiboType:(int)weibotype;

//发送文字及Url
//weibotype 微博类型
-(void)sendContentAndUrl:(NSString *)content ShareUrl:(NSString *)shareUrl WeiboType:(int)weibotype;

#pragma mark - 评论微博  
//评论微博
//weibotype 微博类型  weiboid  要评论
-(void)commentWeibo:(NSString *)content weiboid:(NSString *)weiboid  WeiboType:(int)weibotype;
//回复评论
/*
 *公共参数  weibotype  content
 */
//新浪微博参数介绍 cid	true	int64	需要回复的评论ID。 id	true	int64	需要评论的微博ID。
//人人网       targetUserId	long	false	评论回复目标用户的ID，若为0或不传此参数为：添加一条评论    cid   被评论对象的ID
//腾讯微博  cid   点评父节点微博id

-(void)replyWeiboCommentID:(NSString*)cid content:(NSString *)content weiboid:(NSString *)weiboid  WeiboType:(int)weibotype targetUserId:(NSString*) targetUserId;

#pragma mark - 删除微博
//删除微博
-(void)deleteWeibo:(NSString *)weiboid  WeiboType:(int)weibotype;

#pragma mark - 关注某人
//关注某人  uid和screen_name参数值传递一个既可以 （新浪type：screen_name	 需要关注的用户昵称，腾讯type：name否
//要收听人的微博帐号列表（非昵称），用“,”隔开，例如：abc,bcde,effg（可选，最多30个））
-(void)attentionWeibo:(NSString *)uid nickName:(NSString*)screen_name  WeiboType:(int)weibotype;

- (void)loginThirtyParty:(NSString*)snstype;

//#pragma mark - 删除微博
////删除微博
//-(void)deleteWeibo:(NSString *)weiboid  WeiboType:(int)weibotype;

#pragma mark - 获取微博评论微博
//获取微博评论微博
/**使用说明
 *新浪微博获取评论以后，设置comment_id参数（max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。）
 *腾讯微博获取到评论以后，同时设置comment_id和pagetime参数（m微博id，与pageflag、pagetime共同使用，实现翻页功能（第1页填0，继续向下翻页，填上一次请求返回的最后一条记录id，pagetime本页起始时间，与pageflag、twitterid共同使用，实现翻页功能（第一页：填0，向上翻页：填上一次请求返回的第一条记录时间，向下翻页：填上一次请求返回的最后一条记录时间））
）
 */
-(void)getWeiboComment:(NSString *)weiboid Pagesize:(NSString *)Pagesize
                  Page:(int)page Comment_ID:(NSString *)comment_id pagetime:(NSString*)pagetime WeiboType:(int)weibotype;
#pragma mark - 获取好友列表
//获取获取微博好友列表
/**
 *pageSize  每页请求数量
 *page  新浪请求第几页数据
 *startpos  腾讯开始的下一个索引
 *name 腾讯需要传递用户昵称  可以为空串
 */
-(void)getweiboFriends:(NSString*)pageSize SinaPage:(NSString*)page TC_startpos:(NSString *)startpos TCName:(NSString*)name WeiboType:(int)weibotype;


/**
 *获取第三方accessToken
 */
-(NSString*)getAccessToken:(NSString*)snstype ResponseType:(int)reseponsetype;

/**
 *获取第三方有效时间
 */
-(NSString*)getRemindIn:(NSString*)snstype ResponseType:(int)reseponsetype;
/**
 *获取第三方刷新Token
 */
-(NSString*)getRefreshToken:(NSString*)snstype ResponseType:(int)reseponsetype;
/**
 *获取过期时间
 */
-(NSString*)getExpirationTime:(NSString*)snstype ResponseType:(int)reseponsetype;
/**
 *获取腾讯Openkey
 */
-(NSString*)getOpenKey:(NSString*)snstype ResponseType:(int)reseponsetype;

/**
 *验证第三方Token是否有效  snstype:第三方绑定类型
 */
- (BOOL)isThirdPartyAuthValid:(NSString*)snstype;

@end

/**第三方工具类使用说明
 
 
 授权+获取用户信息
 1.人人登录获取登录用户信息
 [ThirdPartyManager defaultThirdPartyManager].delegate= self;
 [[ThirdPartyManager defaultThirdPartyManager] loginThirtyParty:SNS_TYPE_XXXX];    参数传递 微博类型 
 2.实现回调方法代理SNSKitResponseDelegate  个人信息对应的Model  BindUserInfoModel
 在代理中返回成功的方法中- (void)response:(int)reseponsetype responseValue:(NSDictionary *)responsevalue;调用
 BindUserInfoModel *mymodel = [[BindUserInfoModel alloc]    init];
 [mymodel setThirdPartyModelFromDic:responsevalue response:reseponsetype];就可以获取到授权后的用户信息
 
 
 
 发送微博
 1.[ThirdPartyManager defaultThirdPartyManager].delegate = self;
 [[ThirdPartyManager defaultThirdPartyManager] sendContentAndPic:@"这是一张测试照片http://www.baiddu.com@looklook社交应用" uploadImage:[UIImage imageNamed:@"Icon@2x.png"] WeiboType:SNSKIT_SEND_PICWEIBO_RENREN]
 2.实现回调方法代理SNSKitResponseDelegate  个人信息对应的Model  BindUserInfoModel
 在代理中返回成功的方法中- (void)response:(int)reseponsetype responseValue:(NSDictionary *)responsevalue;调用
 SendWeiboBackInfoModel *mymodel = [[SendWeiboBackInfoModel alloc]    init];
 [mymodel setThirdPartyModelFromDic:responsevalue response:reseponsetype];获取发送微博返回的信息
 token失效的snsType类型
- (void)tokenInvalid:(NSString*)snsType;
 分享失败 sharetype：微博请求类型（例如：SNSKIT_BIND_USERINFO_SINA或者SNSKIT_BIND_USERINFO_TC）
 snsType：第三方类型
- (void)shareFail:(NSString*)snsType Sharetype:(int)sharetype;
 
 
 
 评论微博
 [ThirdPartyManager defaultThirdPartyManager].delegate = self;
 [[ThirdPartyManager defaultThirdPartyManager] commentWeibo:@"looklook新评论，新焦点" weiboid:@"7185116075" WeiboType:SNSKIT_COMMENT_WEIBO_RENREN];
 在代理中返回成功的方法中- (void)response:(int)reseponsetype responseValue:(NSDictionary *)responsevalue;
 token失效的snsType类型
 - (void)tokenInvalid:(NSString*)snsType;
 分享失败 sharetype：微博请求类型（例如：SNSKIT_BIND_USERINFO_SINA或者SNSKIT_BIND_USERINFO_TC）
 snsType：第三方类型
 - (void)shareFail:(NSString*)snsType Sharetype:(int)sharetype;
 
 
 
 获取评论列表
 tc
    //first page
     [[ThirdPartyManager defaultThirdPartyManager] getWeiboComment:@"253361121109017" Pagesize:@"2" Page:0 Comment_ID:@"" pagetime:@"" WeiboType:SNSKIT_GETCOMMENTS_WEIBO_TC];
     //next page
     NSString *commentid = @"";
     NSString *timeStamp = @"";
     if ([[model CommentList] count]>0) {
         CommentInfoListCell* last = [[model CommentList] lastObject];
         commentid = last.commentId;
         timeStamp = last.timeStamp?last.timeStamp:@"";
     }
     [[ThirdPartyManager defaultThirdPartyManager] getWeiboComment:@"253361121109017" Pagesize:@"2" Page:1 Comment_ID:commentid pagetime:timeStamp WeiboType:SNSKIT_GETCOMMENTS_WEIBO_TC];
 
 
 
 //sina
 //first page
     [[ThirdPartyManager defaultThirdPartyManager] getWeiboComment:@"3581511837791277" Pagesize:@"2" Page:0 Comment_ID:@"" pagetime:@"" WeiboType:SNSKIT_GETCOMMENTS_WEIBO_SINA];
    //second page
     NSString * max_id = @"";
    if([[model CommentList] count] > 0){
        max_id = [[[model CommentList] objectAtIndex:0] commentId];
     }

     [[ThirdPartyManager defaultThirdPartyManager] getWeiboComment:@"3581511837791277" Pagesize:@"2" Page:1 Comment_ID:max_id pagetime:@"" WeiboType:SNSKIT_GETCOMMENTS_WEIBO_SINA];
     
 在代理中返回成功的方法中- (void)response:(int)reseponsetype responseValue:(NSDictionary *)responsevalue
 if(model == nil){
    model= [[CommentListModel alloc] init];
 }
 [model setThirdPartyModelFromDic:responsevalue response:reseponsetype];
 token失效的snsType类型
 - (void)tokenInvalid:(NSString*)snsType;
 分享失败 sharetype：微博请求类型（例如：SNSKIT_BIND_USERINFO_SINA或者SNSKIT_BIND_USERINFO_TC）
 snsType：第三方类型
 - (void)shareFail:(NSString*)snsType Sharetype:(int)sharetype;
 
 
 
 
 获取朋友圈好友
 [ThirdPartyManager defaultThirdPartyManager].delegate = self;
 tc
 [[ThirdPartyManager defaultThirdPartyManager] getweiboFriends:@"3" SinaPage:@"" TC_startpos:@"0" TCName:@"" WeiboType:SNSKIT_GETFRIENDS_WEIBO_TC];
 [[ThirdPartyManager defaultThirdPartyManager] getweiboFriends:@"3" SinaPage:@"" TC_startpos:model.tc_nextstartpos TCName:@"" WeiboType:SNSKIT_GETFRIENDS_WEIBO_TC];
     model.sina_page_number = 1;
 renren  
 [[ThirdPartyManager defaultThirdPartyManager] getweiboFriends:@"3" SinaPage:@"1" TC_startpos:@"" TCName:@"" WeiboType:SNSKIT_GETFRIENDS_WEIBO_RENREN];
 sina
 [[ThirdPartyManager defaultThirdPartyManager] getweiboFriends:@"3" SinaPage:@"1" TC_startpos:@"" TCName:@"" WeiboType:SNSKIT_GETFRIENDS_WEIBO_SINA];
 在代理中返回成功的方法中- (void)response:(int)reseponsetype responseValue:(NSDictionary *)responsevalue
 if(model == nil){
 model= [[FriendListModel alloc] init];
 }
 [model setThirdPartyModelFromDic:responsevalue response:reseponsetype];
 
 token失效...
 分享失败 sharetype：微.... 
 
 
 
 
 删除微博  人人暂时没有找到删除分享功能
 1.[[ThirdPartyManager defaultThirdPartyManager] deleteWeibo:@"3581196325588889" WeiboType:SNSKIT_DELETE_WEIBO_SINA];
 2.实现回调方法代理SNSKitResponseDelegate  
 在代理中返回成功的方法中- (void)response:(int)reseponsetype responseValue:(NSDictionary *)responsevalue;调用
 DeleteWeiboBackInfoModel *mymodel = [[DeleteWeiboBackInfoModel alloc]    init];
 [mymodel setThirdPartyModelFromDic:responsevalue response:reseponsetype];
 token失效的snsType类型
 - (void)tokenInvalid:(NSString*)snsType;
 分享失败 sharetype：微博请求类型（例如：SNSKIT_BIND_USERINFO_SINA或者SNSKIT_BIND_USERINFO_TC）
 snsType：第三方类型
 - (void)shareFail:(NSString*)snsType Sharetype:(int)sharetype;
 
 
 
 
 发送关注
 1.[[ThirdPartyManager defaultThirdPartyManager] attentionWeibo:LOOKLOOKTCOPENID nickName:@"" WeiboType:SNSKIT_ATTENTION_WEIBO_TC];
 2.实现回调方法代理SNSKitResponseDelegate
 在代理中返回成功的方法中- (void)response:(int)reseponsetype responseValue:(NSDictionary *)responsevalue;
 关注成功
 token失效的snsType类型
 - (void)tokenInvalid:(NSString*)snsType;
 分享失败 sharetype：微博请求类型（例如：SNSKIT_BIND_USERINFO_SINA或者SNSKIT_BIND_USERINFO_TC）
 snsType：第三方类型
 - (void)shareFail:(NSString*)snsType Sharetype:(int)sharetype;
 
 发送微博带文字及Url
1.
 [ThirdPartyManager defaultThirdPartyManager].delegate = self;
 [[ThirdPartyManager defaultThirdPartyManager] sendContentAndUrl:@"新浪浪子回头金不换" ShareUrl:@"http://v.looklook.cn/ua/ad.jpg" WeiboType:SNSKIT_SEND_URLPICWEIBO_RENREN];
 2.实现回调方法代理SNSKitResponseDelegate
 在代理中返回成功的方法中- (void)response:(int)reseponsetype responseValue:(NSDictionary *)responsevalue;
 发送微博成功
 SendUrlWeiboBackInfoModel  *mymodel = [[SendUrlWeiboBackInfoModel alloc]    init];
 [mymodel setThirdPartyModelFromDic:responsevalue response:reseponsetype];
 token失效的snsType类型
 - (void)tokenInvalid:(NSString*)snsType;
 分享失败 sharetype：微博请求类型（例如：SNSKIT_BIND_USERINFO_SINA或者SNSKIT_BIND_USERINFO_TC）
 snsType：第三方类型
 - (void)shareFail:(NSString*)snsType Sharetype:(int)sharetype;
 
*/

