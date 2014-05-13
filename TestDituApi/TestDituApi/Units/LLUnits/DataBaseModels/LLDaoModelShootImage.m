//
//  LLDaoModelShootImage.m
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelShootImage.h"

@implementation LLDaoModelShootImage
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
