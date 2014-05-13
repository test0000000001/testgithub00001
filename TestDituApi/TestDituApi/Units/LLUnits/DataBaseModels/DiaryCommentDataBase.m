//
//  DiaryCommentDataBase.m
//  VideoShare
//
//  Created by capry on 13-6-18.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "DiaryCommentDataBase.h"

@implementation ReplyedUserInfo
+(id)customClassWithProperties:(id)properties
{
    ReplyedUserInfo* returnObject = [super customClassWithProperties:properties];
    return returnObject;
}

@end

@implementation DiaryCommentDataBase

- (id)init
{
    self = [super init];
    if (self)
    {
        self.isLocalComment = @"n";                 // 默认是网络上有的
//        self.primaryKey = @"diaryCommentKey";
        self.primaryKey = @"commentuuid";
        self.taskId = -1;
        self.changeInfoTaskId = -1;
    }
    return self;
}

+(id)customClassWithProperties:(id)properties
{
    DiaryCommentDataBase* returnObject = [super customClassWithProperties:properties];
    returnObject.replycomment = [ReplyedUserInfo customClassWithProperties:returnObject.replycomment];
    return returnObject;
}

//-(NSString*)diaryCommentKey{
//    return [NSString stringWithFormat:@"%@%@",UN_NIL(self.commentid),UN_NIL(self.commentuuid)];
//}
-(BOOL)isEqual:(id)object{
    if(![object isKindOfClass:[DiaryCommentDataBase class]]){
        return NO;
    }
    DiaryCommentDataBase* commentData = (DiaryCommentDataBase*)object;
    if(self.commentid.length > 0 && [self.commentid isEqualToString:commentData.commentid]){
        return YES;
    }else if(self.commentuuid.length > 0 && [self.commentuuid isEqualToString:commentData.commentuuid]){
        return YES;
    }
    return NO;
}
@end
