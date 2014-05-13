//
//  BindUserInfoModel.m
//  VideoShare
//
//  Created by qin on 13-5-22.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "BindUserInfoModel.h"
#import "ThirdPartyManager.h"


@implementation BindUserInfoModel

@synthesize snsid = _snsid;
@synthesize snstype = _snstype;
@synthesize nickname = _nickname;
@synthesize sex = _sex;
@synthesize birthdate = _birthdate;
@synthesize address = _address;
@synthesize signature = _signature;
@synthesize headurl = _headurl;

-(id)init
{
    if (self=[super init]) {
        self.snstype = @"";
        self.snsid = @"";
        self.nickname = @"";
        self.sex = @"";
        self.birthdate = @"";
        self.address = @"";
        self.signature = @"";
        self.headurl = @"";
    }
    return self;
}

-(void)setThirdPartyModelFromDic:(NSDictionary*)data response:(int)reseponsetype
{
    if(reseponsetype == SNSKIT_BIND_USERINFO_SINA){
        [self setThirdPartyModelFromDic_Sina:data];
    }else if(reseponsetype == SNSKIT_BIND_USERINFO_TC){
        [self setThirdPartyModelFromDic_Tc:data];
    }else if(reseponsetype == SNSKIT_BIND_USERINFO_RENREN){
        [self setThirdPartyModelFromDic_RENREN:data];
    }
}

-(void)setThirdPartyModelFromDic_Sina:(NSDictionary*)data
{
    if(data != nil){
        _snstype = THIRDPARTY_SNS_TYPE_SINA;
        _snsid = [[data objectForKey: @"id"] description];
        _nickname = [data objectForKey:@"screen_name"];
        //sina  gender	string	性别，m：男、f：女、n：未知
        //looklook “sex”:”0”0男 1女 2未知
        if([@"m" isEqualToString:[data objectForKey: @"gender"]]){
            _sex = @"0";
        }else if([@"f" isEqualToString:[data objectForKey: @"gender"]]){
            _sex = @"1";
        }else if([@"n" isEqualToString:[data objectForKey: @"gender"]]){
            _sex = @"2";
        }
        _birthdate = @"";
        _address = @"";
        _signature = [data objectForKey: @"description"];
        _headurl = [data objectForKey: @"profile_image_url"];
    }
}

-(void)setThirdPartyModelFromDic_Tc:(NSDictionary*)data
{
    if(data != nil){
        _snstype = THIRDPARTY_SNS_TYPE_TC;
        if([@"0" isEqualToString:[[data objectForKey:@"ret"] description]]){
            NSDictionary *detaildata = [data objectForKey:@"data"];
            //sex : 用户性别，1-男，2-女，0-未填写,
            //looklook “sex”:”0”0男 1女 2未知
            if([@"1" isEqualToString:[[detaildata objectForKey: @"sex"] description]]){
                _sex = @"0";
            }else if([@"2" isEqualToString:[[detaildata objectForKey: @"sex"] description]]){
                _sex = @"1";
            }else if([@"0" isEqualToString:[[detaildata objectForKey: @"sex"] description]]){
                _sex = @"2";
            }
            _nickname = [detaildata objectForKey:@"name"];
            _snsid = [[detaildata objectForKey:@"openid"] description];
            if(![@"" isEqualToString:UN_NIL([data objectForKey:@"birth_year"])] && ![@"" isEqualToString:UN_NIL([data objectForKey:@"birth_month"])] && ![@"" isEqualToString:UN_NIL([data objectForKey:@"birth_day"])]){
                _birthdate = [NSString stringWithFormat:@"%@-%@-%@",[data objectForKey:@"birth_year"],[data objectForKey:@"birth_month"],[data objectForKey:@"birth_day"]];
            }
            _signature = [data objectForKey: @"introduction"];
            _address = @"";
            _headurl = [detaildata objectForKey:@"head"] ;
        }
    }
    
}

-(void)setThirdPartyModelFromDic_RENREN:(NSDictionary*)data
{
        if(data !=nil){
            _snstype = THIRDPARTY_SNS_TYPE_RENREN;
            
            _snsid =  [[data objectForKey: @"id"] description];
            _nickname = [data objectForKey:@"name"];
            //sex	int	表示性别，值1表示男性；值0表示女性
            NSDictionary *basicInformation = [data objectForKey:@"basicInformation"];
            if(!OBJ_IS_NIL(basicInformation)){
                _sex = [basicInformation objectForKey:@"sex"];
                _birthdate = [basicInformation objectForKey:@"birthday"];
            }else{
                _sex = nil;
            }
            
            if([_sex isEqualToString:@"MALE"]){
                _sex = @"0";
            }else if([_sex isEqualToString:@"FEMALE"]){
                _sex = @"1";
            }else {
                _sex=@"";
            }
            /*
             *表示出生时间，格式为：yyyy-mm-dd，需要自行格式化日期显示格式。注：年份60后，实际返回1760-mm-dd；70后，返回1770-mm-dd；80后，返回1780-mm-dd；90后，返回1790-mm-dd
             */
            
            _signature = @"";
            _address = @"";
//            _headurl = [data objectForKey:@"headurl"] ;
            NSArray *avatars = [data objectForKey:@"avatar"];
            for(NSDictionary *avatar in avatars){
                if([[avatar objectForKey:@"size"] isEqualToString:@"HEAD"]){
                    _headurl = [avatar objectForKey:@"url"];
                    break;
                }
            }
    }
}

@end
