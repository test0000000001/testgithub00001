//
//  LLShare.m
//  VideoShare
//
//  Created by tangyx on 13-6-20.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLShare.h"
#import "LLShareTask.h"
#import "SendUrlWeiboBackInfoModel.h"
#import "Tools.h"
#import "DiaryShareUrlData.h"
#import "LLSharePublishManager.h"
#import "PrivateMessageModel.h"
#import "GetMessageModel.h"

@interface LLShare(){
    
}

@end

@implementation LLShare
@synthesize shareTaskInfo,delegate;

-(id)init{
    self = [super init];
    if(self){
        if(!lockObject){
            lockObject = [[NSObject alloc]init];
        }
        self.isShareForSiXin = NO;
    }
    return self;
}
static BOOL hasShareTaskRun = NO;
static NSObject* lockObject = nil;
-(void)share{
    if(![self.shareTaskInfo.isShareSiXin isEqualToString:@"y"]){//私信可以随时分享，第三方分享只能一次分享一个
        @synchronized (lockObject) {
            if(hasShareTaskRun){
                [self performSelector:@selector(share) withObject:nil afterDelay:3];
                return;
            }
            hasShareTaskRun = YES;
        }
    }else{
        self.isShareForSiXin = YES;
    }
    
//    请求日记分享链接
    [LLSharePublishManager getDiaryShareUrlData:self.shareTaskInfo.diaryid return:^(DiaryShareUrlData* data){
        shareTaskInfo.siXinShareUrl = @"";
        shareTaskInfo.sinaShareUrl = @"";
        shareTaskInfo.tcShareUrl = @"";
        shareTaskInfo.renRenShareUrl = @"";
        if (data) {
            if(data.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS){
                shareTaskInfo.shareimageurl = data.shareimageurl;
                for(PlatformURL* cell in data.platformurls){
                    //0:looklook社区 1:新浪微博 2:人人网 6:腾讯微博
                    if([cell.snstype isEqualToString:@"0"]){
                        shareTaskInfo.siXinShareUrl = cell.url;
                    }else if([cell.snstype isEqualToString:@"1"]){
                        shareTaskInfo.sinaShareUrl = cell.url;
                    }else if([cell.snstype isEqualToString:@"2"]){
                        shareTaskInfo.renRenShareUrl = cell.url;
                    }else if([cell.snstype isEqualToString:@"6"]){
                        shareTaskInfo.tcShareUrl = cell.url;
                    }
                }
//                shareTaskInfo.shareimageurl = @"http://dx.looklook.cn/pub/looklook/photo_pub/images/cover/201307/25/1451a7b1f690b96f41be8b080ce280a27086.jpg";
                //             开始分享
                [ImageCacheManager setImageToImage:shareTaskInfo.shareimageurl mainBlock:^(UIImage* image,int delay){
                    self.shareImage = image;
                    if(self.shareImage){
                        [self shareToTC];
                    }else{
                        [self.delegate shareFinished:NO];
                        if(!self.isShareForSiXin){
                            hasShareTaskRun = NO;
                        }
                    }
                
                }];          
            }else{
                [self.delegate shareFinished:NO];
                if(!self.isShareForSiXin){
                    hasShareTaskRun = NO;
                }
            }
        }else{
            [self.delegate shareFinished:NO];
            if(!self.isShareForSiXin){
                hasShareTaskRun = NO;
            }
        }
    }];    
}

-(void)shareToTC{
    if([shareTaskInfo.isShareTc isEqualToString:@"y"]){
        
        [[ThirdPartyManager defaultThirdPartyManager:self]sendContentAndPic:[NSString stringWithFormat:@"%@ %@播放地址:%@ %@",self.shareTaskInfo.content,self.shareTaskInfo.position,self.shareTaskInfo.tcShareUrl,self.shareTaskInfo.targetTCUserIds] uploadImage:self.shareImage WeiboType:SNSKIT_SEND_PICWEIBO_TC];
        
//        [[ThirdPartyManager defaultThirdPartyManager:self]sendContentAndUrl:[NSString stringWithFormat:@"%@ %@播放地址:%@ %@",self.shareTaskInfo.content,postion,self.shareTaskInfo.tcShareUrl,self.shareTaskInfo.targetTCUserIds] ShareUrl:shareTaskInfo.shareimageurl WeiboType:SNSKIT_SEND_URLPICWEIBO_TC];
    }else{
        [self shareToSina];
    }
}
-(void)shareToSina{
    if([shareTaskInfo.isShareSina isEqualToString:@"y"]){
        [[ThirdPartyManager defaultThirdPartyManager:self]sendContentAndPic:[NSString stringWithFormat:@"%@ %@播放地址:%@ %@",self.shareTaskInfo.content,self.shareTaskInfo.position,self.shareTaskInfo.sinaShareUrl,self.shareTaskInfo.targetSINAUserIds] uploadImage:self.shareImage WeiboType:SNSKIT_SEND_PICWEIBO_SINA];
//        [[ThirdPartyManager defaultThirdPartyManager:self]sendContentAndUrl:[NSString stringWithFormat:@"%@ %@播放地址:%@ %@",self.shareTaskInfo.content,postion,self.shareTaskInfo.sinaShareUrl,self.shareTaskInfo.targetSINAUserIds] ShareUrl:shareTaskInfo.shareimageurl WeiboType:SNSKIT_SEND_URLWEIBO_SINA];
    }else{
        [self shareToRenRen];
    }
}
-(void)shareToRenRen{
    if([shareTaskInfo.isShareRenRen isEqualToString:@"y"]){
        [[ThirdPartyManager defaultThirdPartyManager:self]sendContentAndPic:[NSString stringWithFormat:@"%@ %@播放地址:%@ %@",self.shareTaskInfo.content,self.shareTaskInfo.position,self.shareTaskInfo.renRenShareUrl,self.shareTaskInfo.targetRenRenUserIds] uploadImage:self.shareImage WeiboType:SNSKIT_SEND_PICWEIBO_RENREN];
//        [[ThirdPartyManager defaultThirdPartyManager:self]sendContentAndUrl:[NSString stringWithFormat:@"%@ %@播放地址:%@ %@",self.shareTaskInfo.content,postion,self.shareTaskInfo.renRenShareUrl,self.shareTaskInfo.targetRenRenUserIds] ShareUrl:shareTaskInfo.shareimageurl WeiboType:SNSKIT_SEND_URLPICWEIBO_RENREN];
    }else{
        [self shareToSiXin];
    }
}
-(void)shareToSiXin{
    if([shareTaskInfo.isShareSiXin isEqualToString:@"y"]){
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setValue:self.shareTaskInfo.userid forKey:@"userid"];
        [paramDic setValue:self.shareTaskInfo.targetUserIds forKey:@"target_userids"];
        [paramDic setValue:[NSString stringWithFormat:@"%@,%@",self.shareTaskInfo.content,self.shareTaskInfo.siXinShareUrl] forKey:@"content"];
        [paramDic setValue:self.shareTaskInfo.privatemsgtype forKey:@"privatemsgtype"];
        [paramDic setValue:self.shareTaskInfo.diaryid forKey:@"diaryid"];
        [paramDic setObject:[Tools identifierString] forKey:@"uuid"];
        RequestModel *requestModel = [[RequestModel alloc] initWithUrl:SEND_MESSAGE params:paramDic];
        [_webRequestLib fetchDataFromNet:requestModel
                          dataModelClass:[BaseData class]
                               mainBlock:^(BaseData *resultData)
         {
             if(resultData.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS){
                 self.shareTaskInfo.isShareSiXin = @"n";
                 [Tools showStatusToStatusBar:@"私信发送成功！"
                                     delegate:self
                                    statutype:NO
                                     viewtpye:[Tools getKeyWindow]];
                 for(NSString* messageid in [self.shareTaskInfo.privateMessageIds componentsSeparatedByString:@","]){
                     if(messageid.length > 0){
                         [PrivateMessageModel changeMessageStatusbyLocalid:messageid isSuccess:YES];
                     }

                 }
             }
             [self shareFinished];
         }
         ];
    }else{
        [self shareFinished];
    }
}

// 本地增加sns 分享轨迹
-(void)addSnsPath
{
    NSString *snscontent = self.shareTaskInfo.content;
    NSString *sharetime = [GetMessageModel getSystemCurrentTime];
    
    NSString *snstype = @"";
    NSString *snsid = @"";
    NSString *weiboid = @"";

    // 腾讯
    if(self.shareTaskInfo.tcweiboid.length>0){
        snstype = @"6";
        snsid = self.shareTaskInfo.tcsnsid;
        weiboid = self.shareTaskInfo.tcweiboid;
    }
    // 新浪
    if(self.shareTaskInfo.sinaweiboid.length>0){
        snstype = @"1";
        snsid = self.shareTaskInfo.sinasnsid;
        weiboid = self.shareTaskInfo.sinaweiboid;
    }
    // 人人
    if(self.shareTaskInfo.renrenweiboid.length>0){
        snstype = @"2";
        snsid = self.shareTaskInfo.renrensnsid;
        weiboid = self.shareTaskInfo.renrenweiboid;
    }

    LLDaoModelDiary *modelDiary = [LLDaoModelDiary diaryFromUuid:shareTaskInfo.diaryuuid];
    if (!modelDiary)
    {
        return;
    }
    
    LLDaoModelDiarySnsCell *llDaoModelDiarySnsCell = [[LLDaoModelDiarySnsCell alloc] init];
    llDaoModelDiarySnsCell.snscontent = snscontent;
    llDaoModelDiarySnsCell.sharetime = sharetime;
    
    LLDaoModelDiarySnsCellShareinfoCell *llDaoModelDiarySnsCellShareinfoCell = [[LLDaoModelDiarySnsCellShareinfoCell alloc] init];
    llDaoModelDiarySnsCellShareinfoCell.snstype = snstype;
    llDaoModelDiarySnsCellShareinfoCell.snsid = snsid;
    llDaoModelDiarySnsCellShareinfoCell.weiboid = weiboid;
    
    if (!llDaoModelDiarySnsCell.shareinfo || llDaoModelDiarySnsCell.shareinfo.count <= 0)
    {
        llDaoModelDiarySnsCell.shareinfo = [NSMutableArray array];
    }
    [llDaoModelDiarySnsCell.shareinfo addObject:llDaoModelDiarySnsCellShareinfoCell];
    
    if(!modelDiary.sns || modelDiary.sns.count <= 0)
    {
        modelDiary.sns = [NSMutableArray array];
    }
    [modelDiary.sns addObject:llDaoModelDiarySnsCell];

    [[LLDAOBase shardLLDAOBase] updateInsertToDB:modelDiary
                                        callback:^(BOOL result)
     {}];
}

-(void)shareFinished{
    if([self.shareTaskInfo.isShareTc isEqualToString:@"n"] && [self.shareTaskInfo.isShareSina isEqualToString:@"n"] && [self.shareTaskInfo.isShareRenRen isEqualToString:@"n"] && [self.shareTaskInfo.isShareSiXin isEqualToString:@"n"]){
        if(!STR_IS_NIL(self.shareTaskInfo.sinaweiboid) || !STR_IS_NIL(self.shareTaskInfo.tcweiboid) || !STR_IS_NIL(self.shareTaskInfo.renrenweiboid)){
            // 更新本地数据库分享轨迹
            [self addSnsPath];
            // 通知服务器分享轨迹
            [self reportTolooklook:^(BOOL isReport){
                if(isReport){
                    [self.delegate shareFinished:YES];
                }else{
                    [self.delegate shareFinished:NO];
                }
            }];
        }else{
            [self.delegate shareFinished:YES];
        }  
    }else{
        [self.delegate shareFinished:NO];
    }
    if(!self.isShareForSiXin){
        hasShareTaskRun = NO;
    }
}
-(void)reportTolooklook:(void(^)(BOOL))block{
    if([self.shareTaskInfo.isReport isEqualToString:@"n"]){
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setValue:self.shareTaskInfo.userid forKey:@"userid"];
        [paramDic setValue:self.shareTaskInfo.position forKey:@"position"];
        [paramDic setValue:self.shareTaskInfo.longitude forKey:@"longitude"];
        [paramDic setValue:self.shareTaskInfo.latitude forKey:@"latitude"];
        [paramDic setValue:self.shareTaskInfo.diaryid forKey:@"diaryid"];
        [paramDic setValue:self.shareTaskInfo.content forKey:@"snscontent"];
        NSMutableArray* array = [NSMutableArray array];
        NSLog(@"content:%@ weiboid:--->%@",self.shareTaskInfo.content,self.shareTaskInfo.tcweiboid);
        if(self.shareTaskInfo.tcweiboid.length>0){
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:THIRDPARTY_SNS_TYPE_TC,@"snstype",self.shareTaskInfo.tcsnsid,@"snsid",self.shareTaskInfo.tcweiboid,@"weiboid", nil];
            [array addObject:dic];
        }
        if(self.shareTaskInfo.sinaweiboid.length>0){
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:THIRDPARTY_SNS_TYPE_SINA,@"snstype",self.shareTaskInfo.sinasnsid,@"snsid",self.shareTaskInfo.sinaweiboid,@"weiboid", nil];
            [array addObject:dic];
        }
        if(self.shareTaskInfo.renrenweiboid.length>0){
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:THIRDPARTY_SNS_TYPE_RENREN,@"snstype",self.shareTaskInfo.renrensnsid,@"snsid",self.shareTaskInfo.renrenweiboid,@"weiboid", nil];
            [array addObject:dic];
        }
        [paramDic setValue:array forKey:@"sns"];
        
        RequestModel *requestModel = [[RequestModel alloc] initWithUrl:REQUEST_SHAREDIARY_URL params:paramDic];
        [_webRequestLib fetchDataFromNet:requestModel
                          dataModelClass:[BaseData class]
                               mainBlock:^(BaseData *resultData)
         {
             if(resultData.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS){
                 if(block != nil){
                     block(YES);
                 }
             }else{
                 if(block != nil){
                     block(NO);
                 }
             }
         }
         ];

    }else{
        if(block != nil){
            block(YES);
        }
    }
}
/**
 成功返回，reseponsetype：微博请求类型（例如：SNSKIT_BIND_USERINFO_SINA或者SNSKIT_BIND_USERINFO_TC）
 操作成功后返回的值responsevalue
 */
- (void)response:(int)reseponsetype responseValue:(NSDictionary *)dic{
//    if(reseponsetype == SNSKIT_SEND_URLPICWEIBO_TC){
    if(reseponsetype == SNSKIT_SEND_PICWEIBO_TC){
        SendUrlWeiboBackInfoModel* weiboBackInfoModel = [[SendUrlWeiboBackInfoModel alloc]init];
        [weiboBackInfoModel setThirdPartyModelFromDic_Tc:dic];
        if(!STR_IS_NIL(weiboBackInfoModel.weiboid)){
            self.shareTaskInfo.isShareTc = @"n";
            self.shareTaskInfo.tcweiboid = weiboBackInfoModel.weiboid;
            self.shareTaskInfo.tcsnsid = [ThirdPartyManager defaultThirdPartyManager:self].tcSnsKit.userID;
            [Tools showStatusToStatusBar:@"分享腾讯微博成功！"
                                delegate:self
                               statutype:NO
                                viewtpye:[Tools getKeyWindow]];
        }else if(!STR_IS_NIL(weiboBackInfoModel.errorMessage) && !weiboBackInfoModel.isErrorWithSendFrequency){
            self.shareTaskInfo.isShareTc = @"n";
            [Tools showStatusToStatusBar:[NSString stringWithFormat:@"分享腾讯失败：%@",weiboBackInfoModel.errorMessage]
                                delegate:self
                               statutype:NO
                                viewtpye:[Tools getKeyWindow]];
        }
        [self shareToSina];
//    }else if(reseponsetype == SNSKIT_SEND_URLWEIBO_SINA){
    }else if(reseponsetype == SNSKIT_SEND_PICWEIBO_SINA){
        SendUrlWeiboBackInfoModel* weiboBackInfoModel = [[SendUrlWeiboBackInfoModel alloc]init];
        [weiboBackInfoModel setThirdPartyModelFromDic_Sina:dic];
        if(!STR_IS_NIL(weiboBackInfoModel.weiboid)){
            self.shareTaskInfo.isShareSina = @"n";
            self.shareTaskInfo.sinasnsid = [ThirdPartyManager defaultThirdPartyManager:self].sinaSnsKit.userID;
            self.shareTaskInfo.sinaweiboid = weiboBackInfoModel.weiboid;
            [Tools showStatusToStatusBar:@"分享新浪微博成功！"
                                delegate:self
                               statutype:NO
                                viewtpye:[Tools getKeyWindow]];

        }else if(!STR_IS_NIL(weiboBackInfoModel.errorMessage) && !weiboBackInfoModel.isErrorWithSendFrequency){
            self.shareTaskInfo.isShareSina = @"n";
            [Tools showStatusToStatusBar:[NSString stringWithFormat:@"分享新浪失败：%@",weiboBackInfoModel.errorMessage]
                                delegate:self
                               statutype:NO
                                viewtpye:[Tools getKeyWindow]];
        }

        [self shareToRenRen];
//    }else if(reseponsetype == SNSKIT_SEND_URLPICWEIBO_RENREN){
    }else if(reseponsetype == SNSKIT_SEND_PICWEIBO_RENREN){
        SendUrlWeiboBackInfoModel* weiboBackInfoModel = [[SendUrlWeiboBackInfoModel alloc]init];
        [weiboBackInfoModel setThirdPartyModelFromDic_RENREN:dic];
        if(!STR_IS_NIL(weiboBackInfoModel.weiboid)){
            self.shareTaskInfo.isShareRenRen = @"n";
            self.shareTaskInfo.renrenweiboid = weiboBackInfoModel.weiboid;
            self.shareTaskInfo.renrensnsid = [ThirdPartyManager defaultThirdPartyManager:self].renRenSnsKit.userID;
            [Tools showStatusToStatusBar:@"分享人人网成功！"
                                delegate:self
                               statutype:NO
                                viewtpye:[Tools getKeyWindow]];
        }else if(!STR_IS_NIL(weiboBackInfoModel.errorMessage) && !weiboBackInfoModel.isErrorWithSendFrequency){
            self.shareTaskInfo.isShareRenRen = @"n";
            [Tools showStatusToStatusBar:[NSString stringWithFormat:@"分享人人网失败：%@",weiboBackInfoModel.errorMessage]
                                delegate:self
                               statutype:NO
                                viewtpye:[Tools getKeyWindow]];
        }
        [self shareToSiXin];
    }
}
/**
 token失效的snsType类型==微博类型
 */
- (void)tokenInvalid:(NSString*)snsType{
    if([snsType isEqualToString:THIRDPARTY_SNS_TYPE_TC]){
        [Tools showStatusToStatusBar:@"腾讯授权过期，分享失败！"
                            delegate:self
                           statutype:NO
                            viewtpye:[Tools getKeyWindow]];
        [self shareToSina];
    }else if([snsType isEqualToString:THIRDPARTY_SNS_TYPE_SINA]){
        [Tools showStatusToStatusBar:@"新浪授权过期，分享失败！"
                            delegate:self
                           statutype:NO
                            viewtpye:[Tools getKeyWindow]];
        [self shareToRenRen];
    }else if([snsType isEqualToString:THIRDPARTY_SNS_TYPE_RENREN]){
        [Tools showStatusToStatusBar:@"人人网授权过期，分享失败！"
                            delegate:self
                           statutype:NO
                            viewtpye:[Tools getKeyWindow]];
        [self shareToSiXin];
    }
}
/**
 分享失败 sharetype：微博请求类型（例如：SNSKIT_BIND_USERINFO_SINA或者SNSKIT_BIND_USERINFO_TC）
 snsType：第三方类型
 */
- (void)shareFail:(NSString*)snsType Sharetype:(int)sharetype{
//    if(sharetype == SNSKIT_SEND_URLPICWEIBO_TC){
//        [self shareToSina];
//    }else if(sharetype == SNSKIT_SEND_URLWEIBO_SINA){
//        [self shareToRenRen];
//    }else if(sharetype == SNSKIT_SEND_URLPICWEIBO_RENREN){
//        [self shareToSiXin];
//    }
    if(sharetype == SNSKIT_SEND_PICWEIBO_TC){
        [self shareToSina];
    }else if(sharetype == SNSKIT_SEND_PICWEIBO_SINA){
        [self shareToRenRen];
    }else if(sharetype == SNSKIT_SEND_PICWEIBO_RENREN){
        [self shareToSiXin];
    }
}
@end
