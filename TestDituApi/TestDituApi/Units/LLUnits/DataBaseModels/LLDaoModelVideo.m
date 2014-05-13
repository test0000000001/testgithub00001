//
//  LLDaoModelVideo.m
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelVideo.h"

@implementation LLDaoModelVideo
@synthesize path=_path;
@synthesize videoid=_videoid;
@synthesize sourceid=_sourceid;
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
