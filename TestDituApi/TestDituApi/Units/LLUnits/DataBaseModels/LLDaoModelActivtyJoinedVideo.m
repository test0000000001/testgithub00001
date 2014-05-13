//
//  LLDaoModelActivtyJoinedVideo.m
//  VideoShare
//
//  Created by wan liming on 7/15/13.
//  Copyright (c) 2013 cmmobi. All rights reserved.
//

#import "LLDaoModelActivtyJoinedVideo.h"

@implementation LLDaoModelActivtyJoinedVideo
@synthesize userKey;

-(id)init{
    self = [super init];
    if(self){
        self.primaryKey =@"userKey";
    }
    return self;
}
-(NSString*)userKey{
    return [NSString stringWithFormat:@"%@_%@",self.activeid, self.diaryid];
}

@end
