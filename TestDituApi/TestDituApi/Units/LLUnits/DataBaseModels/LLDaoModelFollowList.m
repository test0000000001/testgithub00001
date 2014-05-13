//
//  LLDaoModelFollowList.m
//  VideoShare
//
//  Created by wan liming on 6/13/13.
//  Copyright (c) 2013 zengchao. All rights reserved.
//

#import "LLDaoModelFollowList.h"
#import "Tools.h"
#import "LLDaoBase.h"
#import "NSObject+ABJsonConverter.h"


@implementation LLDaoModelFollowList
@synthesize userKey;
-(id)init{
    self = [super init];
    if(self){
        self.primaryKey =@"userKey";
    }
    return self;
}
-(NSString*)userKey{
    return [NSString stringWithFormat:@"%@_%@",self.view_userid, self.userid];
}
@end
