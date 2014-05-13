//
//  LLDaoModelFreeTask.m
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelFreeTask.h"

@implementation LLDaoModelFreeTask
-(id)init
{
    self = [super init];
    if (self)
    {
        self.primaryKey = @"taskID";//主健
        self.taskStatus = @"0";
    }
    return self;
}
@end
