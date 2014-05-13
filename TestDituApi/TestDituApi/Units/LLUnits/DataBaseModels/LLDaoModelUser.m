//
//  LLDaoModelUser.m
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelUser.h"

@implementation LLDaoModelUser
@synthesize userid;                      // 用户id
@synthesize fingerPassword;              // 保险箱密码
@synthesize firstPhone;                  // 绑定look的手机号
@synthesize secondPhone;                 // 绑定保险箱密码的手机号
@synthesize emailAddress;                 // 绑定的email地址

@synthesize isBindSina;   //是否绑定了新浪微博  0：未绑定  1：绑定打开  2：绑定关闭
@synthesize bindSinaAuthInfo;  //新浪授权信息
@synthesize isBindTC;   //是否绑定了腾讯微博  0：未绑定  1：绑定打开  2：绑定关闭
@synthesize bindTCAuthInfo;  //腾讯授权信息
@synthesize isBindRENREN;   //是否绑定了人人网  0：未绑定  1：绑定打开  2：绑定关闭
@synthesize bindRENRENAuthInfo;  //人人网授权信息
@synthesize binddingEmail;  //绑定的邮箱地址
@synthesize binddingEmailStatus;  //绑定邮箱的激活状态
@synthesize binddingPhone;  //绑定的手机号

@synthesize nickname;  //昵称
@synthesize logintype;
@synthesize headimageurl; //头像地址
@synthesize sex; //性别
@synthesize address;  //地址
@synthesize birthdate; //生日
@synthesize signature; //签名
@synthesize app_downloadurl; //looklook官方下载地址
@synthesize mood; //心情

@synthesize privmsg_type;//谁可以给我发私信，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
@synthesize friends_type; //谁可以看我的朋友关系，1全部人可见（黑名单人除外）2关注人可见  4仅自己可见
@synthesize diary_type; //谁可以看我内容（日记和评论），1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
@synthesize position_type; //谁可以看我的位置，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
@synthesize audio_type; //谁可以听我的语音，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
@synthesize audio_encrypt_type; //加密类型， audio_type=2或4，有效
@synthesize launch_type; //启动1观看模式 2摄影模式
@synthesize sysc_type;//"1"  //数据同步，1关闭 2仅WIFI 3任何网络
@synthesize coverimageurl;


@synthesize officialUsersJsonStr; // 官方用户列表Json串
-(id)init
{
    self = [super init];
    if (self)
    {
        self.primaryKey = @"userid";//主健
        self.safeBoxOpenRemainNum = @"5";
        self.taskListAlive = 1;
    }
    return self;
}
@end
