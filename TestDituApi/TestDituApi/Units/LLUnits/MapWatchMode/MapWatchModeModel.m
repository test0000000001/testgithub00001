//
//  MapWatchModeModel.m
//  VideoShare
//
//  Created by xu dongsheng on 13-6-9.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "MapWatchModeModel.h"
#import "LLDaoModelDiary.h"
#import "MainPageLeftModel.h"

@implementation MapWatchModeModel

-(void)getDiaryArrayByUserid:(NSString*)userid mainBlock:(void(^)(NSMutableArray* diaryArray))mainBlock {
    
    // 从本地数据库中获取
//    LLDAOBase *llDaoBase = [LLDAOBase shardLLDAOBase];
//    static LLDaoModelDiary *llDaomodelDiary = nil;
//    LLDaoModelDiary *llDaomodelDiaryClass = [[LLDaoModelDiary alloc] init];
//    
//    [llDaoBase searchWhere:llDaomodelDiaryClass
//                    String:[NSString stringWithFormat:@"userid = \'%@\'",userid]
//                   orderBy:nil
//                    offset:0
//                     count:1
//                  callback:^(NSArray *resultArray)
//     {
//         mainBlock(resultArray);
//     }
//     ];
    
//    MainPageLeftModel *mainPageModel = [[MainPageLeftModel alloc] init];
//    [mainPageModel getListDiary:APP_USERID diary_time:@"" request_type:@"1" diarywidth:@"145" diaryheight:@"" cloudType:@"2" block:^(DiaryBasicData *resultData) {
//        mainBlock(resultData.diaryInfoArray);
//    }];
    
    NSMutableArray* diaryArray = [NSMutableArray new];
    DiaryData * diary1 = [[DiaryData alloc]init];
    //北京
    diary1.d_latitude = @"39.687835";
    diary1.d_longitude = @"116.403874";
    diary1.d_position = @"北京";
    [diaryArray addObject:diary1];
    
    DiaryData * diary2 = [[DiaryData alloc]init];
    
    //沈阳
    diary2.d_latitude = @"41.79358";
    diary2.d_longitude = @"123.266066";
    diary2.d_position = @"沈阳";
    [diaryArray addObject:diary2];
    
    //西安
    DiaryData * diary3 = [[DiaryData alloc]init];
    diary3.d_latitude = @"34.259889";
    diary3.d_longitude = @"108.934571";
    diary3.d_position = @"西安";
    [diaryArray addObject:diary3];
    
    
    //上海
    DiaryData * diary4 = [[DiaryData alloc]init];
    diary4.d_latitude = @"31.18906";
    diary4.d_longitude = @"121.560866";
    diary4.d_position = @"上海";
    [diaryArray addObject:diary4];
    
    
    //绍兴
    DiaryData * diary5 = [[DiaryData alloc]init];
    diary5.d_latitude = @"29.96332";
    diary5.d_longitude = @"120.585809";
    diary5.d_position = @"绍兴";
    [diaryArray addObject:diary5];
    
    //呼和浩特
    DiaryData * diary6 = [[DiaryData alloc]init];
    diary6.d_latitude = @"41.197931";
    diary6.d_longitude = @"111.87124";
    diary6.d_position = @"呼和浩特";
    [diaryArray addObject:diary6];

    mainBlock(diaryArray);

}


@end
