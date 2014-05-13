//
//  LLDaoModelFriends.m
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelFriends.h"

@implementation LLDaoModelFriends
-(id)init
{
    self = [super init];
    if (self)
    {
        self.primaryKey = @"userid";//主健
    }
    return self;
}
@end
