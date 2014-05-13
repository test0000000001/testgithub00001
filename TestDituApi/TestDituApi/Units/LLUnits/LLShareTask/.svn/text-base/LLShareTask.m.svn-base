//
//  LLShareTask.m
//  VideoShare
//
//  Created by tangyx on 13-6-19.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLShareTask.h"
#import "JSONKit.h"
#import "NSObject+ABJsonConverter.h"
#import "LLShare.h"
#import "LLTaskManager.h"
#import "LLDaoBase.h"
#import "LLDaoModelDiary.h"


@implementation LLShareTaskInfo
@synthesize targetUserIds,targetTCUserIds,targetSINAUserIds,targetRenRenUserIds,lookShortUrl,isShareTc,isShareSiXin,isShareRenRen,content,userid,isShareSina,diaryuuid,diaryid,renRenShareUrl,sinaShareUrl,tcShareUrl,shareimageurl,isReport,latitude,longitude,position,privatemsgtype,renrensnsid,renrenweiboid,sinasnsid,sinaweiboid,siXinShareUrl,tcsnsid,tcweiboid;
-(id)init{
    self = [super init];
    if(self){
        self.isShareRenRen = @"n";
        self.isShareSina = @"n";
        self.isShareSiXin = @"n";
        self.isShareTc = @"n";
    }
    return self;
}

-(NSString*)tcShareUrl{
    return UN_NIL(tcShareUrl);
}
-(NSString*)sinaShareUrl{
    return UN_NIL(sinaShareUrl);
}
-(NSString*)renRenShareUrl{
    return UN_NIL(renRenShareUrl);
}

-(NSString*)targetRenRenUserIds{
    return UN_NIL(targetRenRenUserIds);
}
-(NSString*)targetSINAUserIds{
    return UN_NIL(targetSINAUserIds);
}
-(NSString*)targetTCUserIds{
    return UN_NIL(targetTCUserIds);
}
-(NSString*)targetUserIds{
    return UN_NIL(targetUserIds);
}

+(id)customClassWithProperties:(id)properties
{
    LLShareTaskInfo* returnObject = [super customClassWithProperties:properties];
    return returnObject;
}

@end

@interface LLShareTask ()<LLShareDelegate>
@property(nonatomic,strong)LLShareTaskInfo* shareTaskInfo;
@property(nonatomic,strong)LLShare* llShare;
@end
@implementation LLShareTask
@synthesize shareTaskInfo,llShare;
-(id)init{
    self = [super init];
    if(self){
        self.llShare = [[LLShare alloc]init];
        self.llShare.delegate = self;
    }
    return self;
}
//LLTaskBase
-(void)startTask
{
    self.shareTaskInfo = [LLShareTaskInfo customClassWithProperties:[_taskInfo objectFromJSONString]];

    //烂尾任务，删除
//    if ([LLTaskManager sharedLLTaskManager].LLUploadTaskRelatedTaskIsAlive != _taskID) {
//        [_delegate taskFinished:_taskID:YES];
//    }
    self.llShare.shareTaskInfo = self.shareTaskInfo;

    static LLDaoModelDiary* diary = nil;
    [[LLDAOBase shardLLDAOBase]searchWhereDic:[[LLDaoModelDiary alloc]init] Dic:[NSDictionary dictionaryWithObjectsAndKeys:self.shareTaskInfo.diaryuuid,@"diaryuuid", nil] callback:^(NSArray* result){
        if([result count]>0){
            diary = [result objectAtIndex:0];
        }
    }];
    self.shareTaskInfo.diaryid = diary.diaryid;
    if([self.shareTaskInfo.isShareSiXin isEqualToString:@"y"]){//私信无需图片
//        if(diary == nil || diary.sharetaskid == -1){//日记被删除 结束任务 分享被取消
        if(diary == nil || diary.sharetaskid <= IS_HAVE_TASK_CONDITION){//日记被删除 结束任务 分享被取消
            [_delegate taskFinished:_taskID :YES];
        }else{
            if([diary.upload_status isEqualToString:@"-3"]){
                [self.llShare share];
            }else{
                [_delegate taskPaused:_taskID];
            }
        }
    }else{
//        if(diary == nil || diary.sharetaskid == -1){//日记被删除 结束任务 分享被取消
        if(diary == nil || diary.sharetaskid <= IS_HAVE_TASK_CONDITION){//日记被删除 结束任务 分享被取消
            [_delegate taskFinished:_taskID :YES];
        }else{
            if([diary.diary_status isEqualToString:@"2"]){
                [self.llShare share];
            }else{
                [_delegate taskPaused:_taskID];
            }
        }
        
//        NSString* imageUrl = [diary imageForShow];
//        [self getImageFromUrl:imageUrl block:^(UIImage* image){
//            if(diary == nil || diary.sharetaskid == -1 || image == nil){//日记被删除 结束任务 分享被取消
//                [_delegate taskFinished:_taskID :YES];
//            }else{
//                if([diary.diary_status isEqualToString:@"2"]){
//                    self.llShare.shareImage = image;
//                    [self.llShare share];
//                }else{
//                    [_delegate taskPaused:_taskID];
//                }
//            }
//        }];
    }
}
-(void)getImageFromUrl:(NSString*)imageUrl block:(void(^)(UIImage* image))block{
    UIImage* image = nil;
    if([imageUrl hasPrefix:@"http:"]){
        image = [ImageCacheManager getImageFromLocation:imageUrl];
    }else{
        image = [UIImage imageWithContentsOfFile:imageUrl];
    }
    if([Tools checkImageValid:image]){
        if(image.size.height > 300 || image.size.width > 300){
            image = [Tools imageByScalingAndCroppingForSize:image withTargetSize:CGSizeMake(300, 300)];
        }
    }
    block(image);
}
-(void)taskNeedDelete{
   
}
-(void)shareFinished:(BOOL)success{
    if(success){
        [[LLDAOBase shardLLDAOBase]updateToDB:[LLDaoModelDiary class] dic:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-1],@"sharetaskid", nil] dic:[NSDictionary dictionaryWithObjectsAndKeys:self.shareTaskInfo.diaryuuid,@"diaryuuid", nil] callback:nil];
        [_delegate taskFinished:_taskID :NO];
    }else{    
        NSString* taskInfo = [self.shareTaskInfo outPutJson];
        if (!STR_IS_NIL(taskInfo)) {
            [[LLTaskManager sharedLLTaskManager] setTaskInfo:_taskID :taskInfo :taskInfo ];
        }
        [_delegate taskPaused:_taskID];
    }
}
@end
