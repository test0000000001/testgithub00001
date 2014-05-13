//
//  LLPublish.m
//  VideoShare
//
//  Created by tangyx on 13-6-20.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLPublish.h"

@implementation LLPublish
//@synthesize delegate;
/**
 * 功能：发布日记
 * 参数：（nsstring *)diaryId
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-03
 */
// to-do 未上传完毕则加入发布队列并且更改数据库中该日记的状态    lLDaoModelDiary.diary_status = @"-1";    // 加入发布队列正在发布中
// 判断上传完毕与否要在日记数据表中加字段
//[parameterDic setObject:APP_USERID  forKey:@"userid"];
//[parameterDic setObject:diaryID     forKey:@"diaryid"];
//[parameterDic setObject:@"1"        forKey:@"publish_type"];
//[parameterDic setObject:diaryType   forKey:@"diary_type"];
//[parameterDic setObject:positonType forKey:@"position_type"];
//[parameterDic setObject:audioType   forKey:@"audio_type"];

-(void) publishDiary:(NSString *)diaryID userid:(NSString *)userid publishType:(NSString *)publishType diaryType:(NSString *)diaryType positionType:(NSString *)positionType audioType:(NSString *)audioType  block:(void(^)(RIA_RESPONSE_CODE result)) block
{
        
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setValue:userid  forKey:@"userid"];
    [parameterDic setValue:diaryID forKey:@"diaryid"];
    [parameterDic setValue:publishType forKey:@"publish_type"];
    [parameterDic setValue:diaryType forKey:@"diary_type"];
    [parameterDic setValue:positionType forKey:@"position_type"];
    [parameterDic setValue:audioType forKey:@"audio_type"];
    RequestModel *requestModel = [[RequestModel alloc] initWithUrl:PUBLISH_OR_CANCEL params:parameterDic];
    
    [_webRequestLib fetchDataFromNet:requestModel
                      dataModelClass:[BaseData class] mainBlock:^(BaseData *responseData)
     {
         BaseData* baseData = (BaseData*)responseData;
         if(block != nil){
             block(baseData.responseStatusCode);
         }
     }
     ];
}

/**
 * 功能：取消发布
 * 参数：（nsstring *)diaryId
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-03
 */
-(void) cancelPublishDiary:(NSString *)diaryID userid:(NSString *)userid publishType:(NSString *)publishType diaryType:(NSString *)diaryType positionType:(NSString *)positionType audioType:(NSString *)audioType  block:(void(^)(RIA_RESPONSE_CODE result)) block
{
    [self publishDiary:diaryID userid:userid publishType:publishType diaryType:diaryType positionType:positionType audioType:audioType block:block];
}

@end
