//
//  DiaryPraiseModelBase.m
//  VideoShare
//
//  Created by capry on 13-6-18.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "DiaryPraiseModelBase.h"

@implementation DiaryPraiseModelBase

- (id) init
{
    if (self = [super init])
    {
        self.primaryKey = @"key";
    }
    return self;
}
-(BOOL)isEqual:(id)object{
    if([object isKindOfClass:[DiaryPraiseModelBase class]]){
        DiaryPraiseModelBase* base = (DiaryPraiseModelBase*)object;
        if([self.diaryid isEqualToString:base.diaryid] && [self.userid isEqualToString:base.userid]){
            return YES;
        }
    }
    return NO;
}
- (NSString *) key
{
    return [NSString stringWithFormat:@"%@_%@",self.diaryid,self.userid];
}
@end
