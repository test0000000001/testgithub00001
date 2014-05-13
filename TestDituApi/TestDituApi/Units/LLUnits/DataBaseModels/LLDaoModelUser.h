//
//  LLDaoModelUser.h
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelBase.h"

@interface LLDaoModelUser : LLDaoModelBase
@property (nonatomic,strong) NSString* userid;                      // 用户id
@property (nonatomic,strong) NSString* fingerPassword;              // 保险箱密码
@property (nonatomic,strong) NSString* firstPhone;                  // 绑定look的手机号
@property (nonatomic,strong) NSString* secondPhone;                 // 绑定保险箱密码的手机号
@property (nonatomic,strong) NSString* emailAddress;                 // 绑定的email地址

@property (nonatomic,strong) NSString* isSafeBoxOpen;               // 保险箱是否是打开的 y：打开 n：关闭
@property (nonatomic,strong)NSString* safeBoxOpenRemainNum;//保险箱剩余输入次数

@property (nonatomic, strong) NSString *isBindSina;   //是否绑定了新浪微博  0：未绑定  1：绑定打开  2：绑定关闭
@property (nonatomic, strong) NSString *bindSinaAuthInfo;  //新浪授权信息
@property (nonatomic, strong) NSString *isBindTC;   //是否绑定了腾讯微博  0：未绑定  1：绑定打开  2：绑定关闭
@property (nonatomic, strong) NSString *bindTCAuthInfo;  //腾讯授权信息
@property (nonatomic, strong) NSString *isBindRENREN;   //是否绑定了人人网  0：未绑定  1：绑定打开  2：绑定关闭
@property (nonatomic, strong) NSString *bindRENRENAuthInfo;  //人人网授权信息
@property (nonatomic, strong) NSString *binddingEmail;  //绑定的邮箱地址
@property (nonatomic, strong) NSString *binddingEmailStatus;  //绑定邮箱的激活状态
@property (nonatomic, strong) NSString *binddingPhone;  //绑定的手机号

@property (nonatomic, strong) NSString *nickname;  //昵称
@property (nonatomic, strong) NSString *logintype; //登录类型
@property (nonatomic, strong) NSString *headimageurl; //头像地址
@property (nonatomic, strong) NSString *sex; //性别
@property (nonatomic, strong) NSString *address;  //地址
@property (nonatomic, strong) NSString *birthdate; //生日
@property (nonatomic, strong) NSString *signature; //签名
@property (nonatomic, strong) NSString *app_downloadurl; //looklook官方下载地址
@property (nonatomic, strong) NSString *mood; //心情

@property (nonatomic, strong) NSString *privmsg_type;//谁可以给我发私信，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
@property (nonatomic, strong) NSString *friends_type; //谁可以看我的朋友关系，1全部人可见（黑名单人除外）2关注人可见  4仅自己可见
@property (nonatomic, strong) NSString *diary_type; //谁可以看我内容（日记和评论），1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
@property (nonatomic, strong) NSString *position_type; //谁可以看我的位置，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
@property (nonatomic, strong) NSString *audio_type; //谁可以听我的语音，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
@property (nonatomic, strong) NSString *audio_encrypt_type; //加密类型， audio_type=2或4，有效
@property (nonatomic, strong) NSString *launch_type; //启动1观看模式 2摄影模式
@property (nonatomic, strong) NSString *sysc_type;//"1"  //数据同步，1关闭 2仅WIFI 3任何网络

@property (nonatomic, strong) NSString *coverimageurl;//用户空间封面

@property (nonatomic, strong) NSString *officialUsersJsonStr; // 官方用户列表Json串

@property (nonatomic, assign) int taskListAlive; //1全部开始，0全部暂停

@property (nonatomic, strong) NSString *firstDiaryTime;//最新的日记时间
@property (nonatomic, strong) NSString *lastDiaryTime;//最老的日记时间


@end





