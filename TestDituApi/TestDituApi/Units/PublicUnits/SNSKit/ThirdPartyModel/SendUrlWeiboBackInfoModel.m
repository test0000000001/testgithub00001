//
//  SendUrlWeiboBackInfoModel.m
//  VideoShare
//
//  Created by qin on 13-6-17.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "SendUrlWeiboBackInfoModel.h"

@implementation SendUrlWeiboBackInfoModel
@synthesize weiboid = _weiboid;
@synthesize snstype = _snstype;
@synthesize errorMessage = _errorMessage;
@synthesize isErrorWithSendFrequency;
-(id)init
{
    if (self=[super init]) {
        isErrorWithSendFrequency = NO;
    }
    return self;
}

-(void)setThirdPartyModelFromDic:(NSDictionary*)data response:(int)reseponsetype
{
    if(reseponsetype == SNSKIT_SEND_URLWEIBO_SINA){
        [self setThirdPartyModelFromDic_Sina:data];
    }else if(reseponsetype == SNSKIT_SEND_URLPICWEIBO_TC){
        [self setThirdPartyModelFromDic_Tc:data];
    }else if(reseponsetype == SNSKIT_SEND_URLPICWEIBO_RENREN){
        [self setThirdPartyModelFromDic_RENREN:data];
    }
}

-(void)setThirdPartyModelFromDic_Sina:(NSDictionary*)data{
    if(data != nil){
        if(STR_IS_NIL([data objectForKey:@"error_code"])){//无错误
            _snstype = THIRDPARTY_SNS_TYPE_SINA;
            _weiboid = [NSString stringWithFormat:@"%lld",[[data objectForKey:@"id"] longLongValue]];
        }else{
            int errorCode = [[data objectForKey:@"error_code"]intValue];
            switch (errorCode) {
                case 10004:
                    self.errorMessage = @"IP限制不能请求该资源";
                    break;
                case 10009:
                    self.errorMessage = @"任务过多，系统繁忙";
                    self.isErrorWithSendFrequency = YES;
                    break;
                case 10018:
                    self.errorMessage = @"请求长度超过限制";
                    break;
                case 10022:
                    self.errorMessage = @"IP请求频次超过上限";
                    self.isErrorWithSendFrequency = YES;
                    break;
                case 10023:
                    self.errorMessage = @"用户请求频次超过上限";
                    self.isErrorWithSendFrequency = YES;
                    break;
                case 20005:
                    self.errorMessage = @"不支持的图片类型，仅仅支持JPG、GIF、PNG";
                    break;
                case 20006:
                    self.errorMessage = @"图片太大";
                    break;
                case 20012:
                    self.errorMessage = @"输入文字太长，请确认不超过140个字符";
                    break;
                case 20013:
                    self.errorMessage = @"输入文字太长，请确认不超过300个字符";
                    break;
                case 20016:
                    self.errorMessage = @"发布内容过于频繁";
                    self.isErrorWithSendFrequency = YES;
                    break;
                case 20018:
                    self.errorMessage = @"包含非法网址";
                    break;
                case 20019:
                    self.errorMessage = @"提交相同的信息";
                    break;
                case 20020:
                    self.errorMessage = @"包含广告信息";
                    break;
                case 20021:
                    self.errorMessage = @"包含非法内容";
                    break;
                    
                default:
                    break;
            }
        }
        
//        NSDictionary *userdata = [data objectForKey:@"user"];
//        _userid = [userdata objectForKey:@"id"];
    }
}

-(void)setThirdPartyModelFromDic_Tc:(NSDictionary*)data{
    /**
     data =     {
     id = 259168118937421;
     time = 1369300663;
     };
     */
    if(data != nil && [[[data objectForKey:@"ret"] description] isEqualToString:@"0"]){
        _snstype = THIRDPARTY_SNS_TYPE_TC;
        _weiboid = [[data objectForKey:@"data"] objectForKey:@"id"];
        int errcode= [[data objectForKey:@"errcode"]intValue];
        int ret = [[data objectForKey:@"ret"]intValue];
        switch (ret) {
            case 1:
                switch (errcode) {
                    case 1:
                        self.errorMessage = @"调用接口时所填写的clientip错误，必须为用户侧真实ip，不能为内网ip、以127及255开头的ip";
                        break;
                    case 2:
                        self.errorMessage = @"微博内容超出长度限制或为空，建议缩减要发表内容";
                        break;
                    case 3:
                        self.errorMessage = @"经度值错误，请仔细检查后重新填写";
                        break;
                    case 4:
                        self.errorMessage = @"纬度值错误，请仔细检查后重新填写";
                        break;
                    default:
                        break;
                }
                break;
            case 4:
                switch (errcode) {
                    case 2:
                        self.errorMessage = @"系统错误";
                        break;
                    case 3:
                        self.errorMessage = @"格式错误、用户无效（非微博用户）等，请确定用户是否是微博用户";
                        break;
                    case 4:
                        self.errorMessage = @"表示有过多脏话，请认真检查content内容";
                        break;
                    case 5:
                        self.errorMessage = @"禁止访问，如城市，uin黑名单限制等";
                        break;
                    case 9:
                        self.errorMessage = @"包含垃圾信息：广告，恶意链接、黑名单号码等，请认真检查";
                        break;
                    case 10:
                        self.errorMessage = @"发表太快，被频率限制，请控制发表频率";
                        self.isErrorWithSendFrequency = YES;
                        break;
                    case 12:
                        self.errorMessage = @"源消息审核中";
                        break;
                    case 13:
                        self.errorMessage = @"重复发表，请不要连续发表重复内容";
                        break;
                    case 14:
                        self.errorMessage = @"未实名认证，用户未进行实名认证，请引导用户进行实名认证";
                        break;
                    case 16:
                        self.errorMessage = @"服务器内部错误导致发表失败，请联系我们反馈问题";
                        break;
                    case 1001:
                        self.errorMessage = @"公共uin黑名单限制";
                        break;
                    case 1002:
                        self.errorMessage = @"公共IP黑名单限制";
                        break;
                    case 1003:
                        self.errorMessage = @"微博黑名单限制";
                        break;
                    case 1004:
                        self.errorMessage = @"单UIN访问微博过快";
                        break;
                    case 1472:
                        self.errorMessage = @"服务器内部错误导致发表失败，请联系我们反馈问题";
                        break;
                    default:
                        break;
                }
                break;
            case 5:
                switch (errcode) {
                    case 73:
                        self.errorMessage = @"用户设置禁止转播评论";
                        break;
                    case 74:
                        self.errorMessage = @"防伪造";
                        break;
                    case 75:
                        self.errorMessage = @"防重发-命中刚刚删除的微博消息";
                        break;
                    default:
                        break;
                }
                break;
                
            default:
                break;
        }
    }
}

-(void)setThirdPartyModelFromDic_RENREN:(NSDictionary*)data{
    if(data != nil){
        _snstype = THIRDPARTY_SNS_TYPE_RENREN;
        _weiboid = [NSString stringWithFormat:@"%lld",[[data objectForKey:@"id"] longLongValue]];
//        _userid = [data objectForKey:@"ownerId"];
    }
}

@end
