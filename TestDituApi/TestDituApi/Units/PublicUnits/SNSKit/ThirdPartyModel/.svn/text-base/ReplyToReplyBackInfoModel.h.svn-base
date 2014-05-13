//
//  ReplyToReplyBackInfoModel.h
//  VideoShare
//
//  Created by qin on 13-8-5.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseThirdPartyModel.h"

@interface ReplyToReplyBackInfoModel : BaseThirdPartyModel{
    NSString* _replyid;
    NSString* _snstype;
    NSString* _userid;
}

@property (nonatomic, retain) NSString* replyid;
@property (nonatomic, retain) NSString* snstype;
@property (nonatomic, retain) NSString* userid;

-(void)setThirdPartyModelFromDic:(NSDictionary*)data response:(int)reseponsetype;
-(void)setThirdPartyModelFromDic_Sina:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_Tc:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_RENREN:(NSDictionary*)data;

@end
