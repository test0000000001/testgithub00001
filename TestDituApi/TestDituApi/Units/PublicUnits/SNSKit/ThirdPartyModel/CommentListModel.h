//
//  CommentListModel.h
//  VideoShare
//
//  Created by qin on 13-5-24.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseThirdPartyModel.h"

@interface CommentInfoListCell : NSObject//评论元素
@property (nonatomic,retain) NSString* snstype;
@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) NSString* content;
@property (nonatomic,retain) NSString* image;
@property (nonatomic,retain) NSString* userid;
@property (nonatomic,retain) NSString* videoid;
@property (nonatomic,retain) NSString* commentId;
@property (nonatomic,retain) NSString* statusid;//微博id
@property (nonatomic,retain) NSString* timeRequestReturn;//请求返回的记录时间
@property (nonatomic,strong) NSString* timeStamp;
@property (nonatomic,retain) NSString* signature;//签名，站内专用

@property (nonatomic,retain) NSString* sex;
@property (nonatomic,retain) NSString* isattention;
@end

@interface CommentListModel : BaseThirdPartyModel{
    NSString* _snstype;
    NSMutableArray* _CommentList;
}

@property (nonatomic,retain) NSString* snstype;
@property (nonatomic,retain) NSMutableArray* CommentList;//评论列表

-(void)setThirdPartyModelFromDic:(NSDictionary*)data response:(int)reseponsetype;
-(void)setThirdPartyModelFromDic_Sina:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_Tc:(NSDictionary*)data;
-(void)setThirdPartyModelFromDic_RENREN:(NSDictionary*)data;

-(void)addCommentFromSinaResponse:(NSArray*)commentList;
-(void)addCommentFromTencentResponse:(NSDictionary*)dataDictionary;
-(void)addCommentFromRenRenResponse:(NSArray*)commentList;

@end
