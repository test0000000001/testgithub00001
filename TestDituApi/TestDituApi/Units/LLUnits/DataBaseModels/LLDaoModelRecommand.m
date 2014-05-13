//
//  LLDaoModelRecommand.m
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelRecommand.h"

@implementation LLDaoModelRecommand

-(id)init
{
    self = [super init];
    if (self)
    {
        self.primaryKey = @"userid";//主健
        self.recommendDiaryIds = [NSMutableArray new];
    }
    return self;
}

+(id)customClassWithProperties:(id)properties
{
    LLDaoModelRecommand *returnObject = [super customClassWithProperties:properties];
    return returnObject;
}

@end
