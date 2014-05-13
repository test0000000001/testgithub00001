//
//  MessageData.m
//  VideoShare
//
//  Created by tangyx on 13-6-26.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "MessageData.h"
#import "MessageUserListModelBase.h"
@implementation MessageData
@synthesize hasnextpage,last_timemilli,users,server_time,attentionnum,fansnum;
-(void)setResponseModelFromDic:(NSDictionary *)dataDictionary{
    [super setResponseModelFromDic:dataDictionary];
    [self safeSetValuesForKeysWithDictionary:dataDictionary];
    [self set_diares];
}
-(NSArray*)users{
    NSMutableArray* array = [NSMutableArray array];
    for(NSDictionary* dic in users){
        [array addObject:[MessageUserListModelBase customClassWithProperties:dic]];
    }
    return array;
}

-(void) set_diares
{
    for (int i = 0; i < self.diaries.count; i++)
    {
        NSMutableDictionary *rsDic = [self.diaries objectAtIndex:i];
        DiaryData *diaryData = [[DiaryData alloc] init];
        [diaryData setResponseModelFromDic:rsDic];
        [self.diaries replaceObjectAtIndex:i withObject:diaryData];
    }
}
@end
