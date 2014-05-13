//
//  LLDaoModelContactsFansList.m
//  VideoShare
//
//  Created by tangyx on 13-6-17.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLDaoModelContacts.h"

@implementation LLDaoModelContacts

@synthesize nickname,attentioncount,diarycount,fanscount,headimageurl,key,primaryKey,rowid,sex,signature,userid,contactstype,contactskey;

-(id)init{
    self = [super init];
    if(self){
        self.primaryKey = @"contactskey";
    }
    return self;
}
-(NSString*)contactskey{
    return [NSString stringWithFormat:@"%@_%@",userid,contactstype];
}
-(BOOL)isEqual:(id)object{
    if(![object isKindOfClass:[self class]]){
        return NO;
    }
    LLDaoModelContacts* obj = (LLDaoModelContacts*)object;
    if([self.userid isEqualToString:obj.userid]){
        return YES;
    }
    return NO;
}
-(void)updateKey{
    key = [SortAndSplitUnits getFristCharString:self.nickname];
}
@end
