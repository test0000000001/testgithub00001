//
//  CommentListModel.m
//  VideoShare
//
//  Created by qin on 13-5-24.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "CommentListModel.h"
#import "ThirdPartyManager.h"
#import "Tools.h"
#import "Global.h"

@implementation CommentInfoListCell
@synthesize name=_name;
@synthesize content=_content;
@synthesize image=_image;
@synthesize videoid=_videoid;
@synthesize userid=_userid;
@synthesize commentId=_commentId;
@synthesize statusid=_statusid;
@synthesize timeRequestReturn = _timeRequestReturn;
@synthesize signature = _signature;
@synthesize sex = _sex;
@synthesize isattention = _isattention;
@synthesize timeStamp=_timeStamp;
@end

@implementation CommentListModel
@synthesize snstype = _snstype;
@synthesize CommentList = _CommentList;

-(id)init
{
    if (self=[super init]) {
        _CommentList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setThirdPartyModelFromDic:(NSDictionary*)data response:(int)reseponsetype
{
    if(reseponsetype == SNSKIT_GETCOMMENTS_WEIBO_SINA){
        [self setThirdPartyModelFromDic_Sina:data];
    }else if(reseponsetype == SNSKIT_GETCOMMENTS_WEIBO_TC){
        [self setThirdPartyModelFromDic_Tc:data];
    }else if(reseponsetype == SNSKIT_GETCOMMENTS_WEIBO_RENREN){
        [self setThirdPartyModelFromDic_RENREN:data];
    }
}

-(void)setThirdPartyModelFromDic_Sina:(NSDictionary*)data{
    NSArray* commentlist = [data objectForKey:@"comments"];
    if(!OBJ_IS_NIL(commentlist)){
        [self addCommentFromSinaResponse:commentlist];
    }
    
}

-(void)setThirdPartyModelFromDic_Tc:(NSDictionary*)data{
    NSDictionary* dic_data = [data objectForKey:@"data"];
    if (!OBJ_IS_NIL(dic_data)) {
        [self addCommentFromTencentResponse:dic_data];
    }
}

-(void)setThirdPartyModelFromDic_RENREN:(NSDictionary*)data{
    NSArray* dic_data = (NSArray*)data;
    if (!OBJ_IS_NIL(dic_data)) {
        [self addCommentFromRenRenResponse:dic_data];
    }

}


-(void)addCommentFromSinaResponse:(NSArray*)commentList{
    if (commentList) {
        for(NSMutableDictionary *comment in commentList)
        {
            CommentInfoListCell* commentListCell= [[CommentInfoListCell alloc]init];
            commentListCell.snstype = THIRDPARTY_SNS_TYPE_SINA;
            commentListCell.content = [[comment objectForKey:@"text"]description];
            commentListCell.commentId= [[comment objectForKey:@"id"]description];
//            commentListCell.timeRequestReturn = [Tools timeDifference2:[[comment objectForKey:@"created_at"]description] withFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
            commentListCell.timeStamp =[Tools timeMilliFrom:[[comment objectForKey:@"created_at"]description] format:@"EEE MMM dd HH:mm:ss Z yyyy"] ;
            NSDictionary* userDictionary = [comment objectForKey:@"user"];
            commentListCell.name = [[userDictionary objectForKey:@"screen_name"]description];
            commentListCell.image = [[userDictionary objectForKey:@"profile_image_url"]description];
            commentListCell.userid = [[userDictionary objectForKey:@"id"]description];
            NSDictionary* statusDictionary = [comment objectForKey:@"status"];
            commentListCell.statusid = [statusDictionary objectForKey:@"id"];
            
            int find = 0;
            for (CommentInfoListCell* cell in _CommentList) {
                if ([cell.commentId isEqualToString:commentListCell.commentId]) {
                    find=1;
                    break;
                }
            }
            if(find==0)
                [_CommentList addObject:commentListCell];
        }
    }
}

-(void)addCommentFromTencentResponse:(NSDictionary*)dataDictionary{
    NSArray* infoArray = [dataDictionary objectForKey:@"info"];
    if (infoArray) {
        for(NSMutableDictionary *comment in infoArray)
        {
            CommentInfoListCell* commentListCell= [[CommentInfoListCell alloc]init];
            commentListCell.snstype = THIRDPARTY_SNS_TYPE_TC;
            commentListCell.name = [[comment objectForKey:@"nick"]description];
            commentListCell.content = [[comment objectForKey:@"text"]description];
            commentListCell.commentId= [[comment objectForKey:@"id"]description];
            commentListCell.image = [[[comment objectForKey:@"head"]description] stringByAppendingFormat:@"/180"];//40,50,120,180代表尺寸，错添或不添都不显示
//            commentListCell.timeRequestReturn = [Tools timeDifferenceFromeTimestamp2: [[comment objectForKey:@"timestamp"]description]:0];
            commentListCell.timeStamp = [NSString stringWithFormat:@"%@000",[[comment objectForKey:@"timestamp"] description]];
            commentListCell.userid = [[comment objectForKey:@"openid"]description];
            
            int find = 0;
            for (CommentInfoListCell* cell in _CommentList) {
                if ([cell.commentId isEqualToString:commentListCell.commentId]) {
                    find=1;
                    break;
                }
            }
            if(find==0)
                [_CommentList addObject:commentListCell];
        }
    }

}

-(void)addCommentFromRenRenResponse:(NSArray*)commentList{
    if (commentList) {
        for(NSMutableDictionary *comment in commentList)
        {
            CommentInfoListCell* commentListCell= [[CommentInfoListCell alloc]init];
            commentListCell.snstype = THIRDPARTY_SNS_TYPE_RENREN;
            commentListCell.name = [[comment objectForKey:@"nick"]description];
            commentListCell.content = [[comment objectForKey:@"content"]description];
            commentListCell.commentId= [[comment objectForKey:@"id"]description];
//            commentListCell.image = [[[comment objectForKey:@"head"]description] stringByAppendingFormat:@"/180"];//40,50,120,180代表尺寸，错添或不添都不显示
            commentListCell.timeStamp = [Tools timeMilliFrom:[[comment objectForKey:@"time"] description] format:@"yyyy-MM-dd HH:mm:ss"];
//            commentListCell.timeStamp = [[comment objectForKey:@"timestamp"] description];
            
            commentListCell.userid = [[comment objectForKey:@"authorId"]description];
//            commentListCell.timeStamp = [NSDate ]
            int find = 0;
            for (CommentInfoListCell* cell in _CommentList) {
                if ([cell.commentId isEqualToString:commentListCell.commentId]) {
                    find=1;
                    break;
                }
            }
            if(find==0)
                [_CommentList addObject:commentListCell];
        }
    }

}

@end
