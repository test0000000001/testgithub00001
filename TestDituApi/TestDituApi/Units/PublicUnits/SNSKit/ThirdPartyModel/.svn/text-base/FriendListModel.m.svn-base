//
//  FriendListModel.m
//  VideoShare
//
//  Created by qin on 13-5-24.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "FriendListModel.h"
#import "ThirdPartyManager.h"
#import "Tools.h"

@implementation FriendListModel

@synthesize sina_total_number = _sina_total_number;
@synthesize tc_hasnext = _tc_hasnext;
@synthesize friendList = _friendList;

-(id)init
{
    if (self=[super init]) {
        _friendList = [[NSMutableArray alloc]init];
        _tc_hasnext = 0;
        _sina_total_number = 0;
    }
    return self;
}

-(void)setThirdPartyModelFromDic:(NSDictionary*)data response:(int)reseponsetype{
    if(reseponsetype == SNSKIT_GETFRIENDS_WEIBO_SINA){
        [self setThirdPartyModelFromDic_Sina:data];
    }else if(reseponsetype == SNSKIT_GETFRIENDS_WEIBO_TC){
        [self setThirdPartyModelFromDic_Tc:data];
    }else if(reseponsetype == SNSKIT_GETFRIENDS_WEIBO_RENREN){
        [self setThirdPartyModelFromDic_RENREN:data];
    }
}

-(void)setThirdPartyModelFromDic_Sina:(NSDictionary*)data{
    NSMutableArray *array = [data objectForKey:@"users"];
    
    //获取的个数
    int arrayCount = [array count];
    
    //互粉的总个数
    //if(_sina_total_number == 0){
        _sina_total_number = [[data objectForKey:@"total_number"] intValue];
    //}
    
    
    NSLog(@"sinaFriCount[%d]", _sina_total_number);
    
    if (arrayCount > 0) {
        
        for (NSMutableDictionary *dict in array) {
            
            NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [[dict objectForKey:@"id"] description], @"snsuid",
                                       [dict objectForKey:@"screen_name"], @"nickname",
                                       [[dict objectForKey:@"profile_image_url"] description], @"snsphotourl",
                                       [[dict objectForKey:@"gender"] description], @"snssex",
                                       [[dict objectForKey:@"created_at"] description], @"createtime", nil];
            
            //[self.sinaFridata addObject:dic];
            int flagExsit = 0;
            for (NSDictionary* dic1 in _friendList) {
                if ([[[dic1 objectForKey:@"snsuid"] description] isEqualToString:[[dic objectForKey:@"snsuid"] description]]) {
                    flagExsit = 1;
                    break;
                }
            }
            //NSLog(@"snsuid ======%d",[[dic objectForKey:@"snsuid"] intValue]);
            if (flagExsit==0) {
                [self.friendList addObject:dic];
            }
        }
        
    }
}

-(void)setThirdPartyModelFromDic_Tc:(NSDictionary*)data{
    NSLog(@"tc data===%@",data);
    
    NSString * ret = (NSString*)[data objectForKey:@"ret"];
    
    int status = [ret intValue];
    
    if (status == 0) {
        
        NSMutableDictionary *dict = [data objectForKey:@"data"];
        
        if (dict != nil) {
            
            NSMutableArray *arrayinfo = [dict objectForKey:@"info"];
            
            if ([arrayinfo count] > 0) {
                
                for (NSMutableDictionary *dicsouce in arrayinfo) {
                    if ([[dicsouce objectForKey:@"name"] description].length <= 0)
                    {
                        continue;
                    }
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                [[dicsouce objectForKey:@"openid"] description], @"snsuid",
                                                [dicsouce objectForKey:@"nick"] , @"nickname",
                                                [[dicsouce objectForKey:@"name"] description], @"name",
                                                [NSString stringWithFormat:@"%@/100", [[dicsouce objectForKey:@"headurl"] description]], @"snsphotourl",
                                                @"2", @"snssex",
                                                @"", @"createtime",nil];
                    int flagExsit = 0;
                    for (NSDictionary* dic1 in _friendList) {
                        if ([[[dic1 objectForKey:@"snsuid"] description] isEqualToString:[[dic objectForKey:@"snsuid"] description]]) {
                            flagExsit = 1;
                            break;
                        }
                    }
                    if (flagExsit==0) {
                        [self.friendList addObject:dic];
                    }
                    NSLog(@"wwwwwwww->%@",self.friendList);
                    //[self.qqFridata addObject:dic];
                }
            }
            
        }
        
        _tc_hasnext = [[dict objectForKey:@"hasnext"] intValue];
        if (_tc_hasnext == 0) {
            _tc_nextstartpos = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"nextstartpos"]];
        }
    }
}

-(void)setThirdPartyModelFromDic_RENREN:(NSDictionary*)data{
    NSArray *friends = (NSArray*)data;
    //获取的个数
    int arrayCount = [friends count];
    
    
    NSLog(@"renrenFriCount[%d]", arrayCount);
    
    if (arrayCount > 0) {
        
        for (NSMutableDictionary *dict in friends) {
            NSString *_sex = @"";
            //sex	int	表示性别，值1表示男性；值0表示女性
            NSDictionary *basicInformation = [dict objectForKey:@"basicInformation"];
            
            _sex = basicInformation != nil && (NSNull *)basicInformation != [NSNull null]?[basicInformation objectForKey:@"sex"]:nil;
            if(_sex != nil && [_sex isEqualToString:@"MALE"]){
                _sex = @"0";
            }else if([_sex isEqualToString:@"FEMALE"]){
                _sex = @"1";
            }else {
                _sex=@"";
            }
            
            NSString* snsphotourl = @"";
            NSArray *avatars = [dict objectForKey:@"avatar"];
            for(NSDictionary *avatar in avatars){
                if([[avatar objectForKey:@"size"] isEqualToString:@"HEAD"]){
                    snsphotourl = [avatar objectForKey:@"url"];
                    break;
                }
            }

            
            NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [[dict objectForKey:@"id"] description], @"snsuid",
                                       [dict objectForKey:@"name"], @"nickname",
                                       snsphotourl, @"snsphotourl",
                                       _sex, @"snssex",
                                       @"", @"createtime", nil];
            
            //[self.sinaFridata addObject:dic];
            int flagExsit = 0;
            for (NSDictionary* dic1 in _friendList) {
                if ([[[dic1 objectForKey:@"snsuid"] description] isEqualToString:[[dic objectForKey:@"snsuid"] description]]) {
                    flagExsit = 1;
                    break;
                }
            }
            //NSLog(@"snsuid ======%d",[[dic objectForKey:@"snsuid"] intValue]);
            if (flagExsit==0) {
                [self.friendList addObject:dic];
            }
        }
        
    }

}


@end
