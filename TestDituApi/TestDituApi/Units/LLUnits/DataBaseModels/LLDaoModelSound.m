//
//  LLDaoModelSound.m
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelSound.h"

@implementation LLDaoModelSound
@synthesize path=_path;
-(id)init
{
    self = [super init];
    if (self)
    {
        self.primaryKey = @"path";//主健
    }
    return self;
}
@end
