//
//  FriendListModel.h
//  VideoShare
//
//  Created by qin on 13-5-24.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseThirdPartyModel.h"

@interface FriendListModel : BaseThirdPartyModel{
    int _tc_hasnext;
    int _sina_total_number;
    int _sina_page_number;
    NSMutableArray* _friendList;
}

//腾讯需要通过该参数判断是否加载下一页好友   hasnext : 0-表示还有数据，1-表示下页没有数据,
@property (nonatomic,assign) int tc_hasnext;
@property (nonatomic,retain) NSString* tc_nextstartpos;
//新浪需要通过该数量与获取到的好友对比，判断是否加载下一页好友
@property (nonatomic,assign) int sina_total_number;
//新浪访问当前第几数据
@property (nonatomic,assign) int sina_page_number;
@property (nonatomic,retain) NSMutableArray* friendList;//好友列表

-(void)setThirdPartyModelFromDic:(NSDictionary*)data response:(int)reseponsetype;
-(void)setThirdPartyModelFromDic_Sina:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_Tc:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_RENREN:(NSDictionary*)data;

@end
