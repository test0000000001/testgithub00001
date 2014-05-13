//
//  LLDaoModelActivityList.m
//  VideoShare
//
//  Created by wan liming on 6/23/13.
//  Copyright (c) 2013 cmmobi. All rights reserved.
//

#import "LLDaoModelActivityList.h"
#import "Tools.h"

//日记数据
@implementation LLDaoModelActivityDiaryCell

@end

//中奖日记对应转换
@implementation LLDaoModelActivityAwardCell

+(id)customClassWithProperties:(id)properties
{
    LLDaoModelActivityAwardCell* returnObject = [super customClassWithProperties:properties];
    [Tools arrayToClass:returnObject.diaryAwardArray:[LLDaoModelActivityDiaryCell class]];
    return returnObject;
}
@end


//参加活动对应转换
@implementation LLDaoModelActivityJoinedCell
+(id)customClassWithProperties:(id)properties
{
    LLDaoModelActivityJoinedCell* returnObject = [super customClassWithProperties:properties];
    [Tools arrayToClass:returnObject.diaryJoinedArray:[LLDaoModelActivityDiaryCell class]];
    return returnObject;
}
@end



//活动数据库
@implementation LLDaoModelActivityList
@synthesize userKey;

+(id)customClassWithProperties:(id)properties
{
    LLDaoModelActivityList* returnObject = [super customClassWithProperties:properties];
    [Tools arrayToClass:returnObject.joinedDiaryArray:[LLDaoModelActivityJoinedCell class]];
    [Tools arrayToClass:returnObject.awardedDiaryArray:[LLDaoModelActivityAwardCell class]];
    return returnObject;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.primaryKey = @"userKey";
    }
    return self;
}



-(NSString*)userKey{
    return [NSString stringWithFormat:@"%@_%@",self.diaryid, self.activeid];
}

@end
