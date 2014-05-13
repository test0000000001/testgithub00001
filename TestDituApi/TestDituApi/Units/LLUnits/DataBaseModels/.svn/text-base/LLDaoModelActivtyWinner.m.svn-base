//
//  LLDaoModelActivtyWinner.m
//  VideoShare
//
//  Created by wan liming on 7/16/13.
//  Copyright (c) 2013 cmmobi. All rights reserved.
//

#import "LLDaoModelActivtyWinner.h"

@implementation LLDaoModelActivtyWinner
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
