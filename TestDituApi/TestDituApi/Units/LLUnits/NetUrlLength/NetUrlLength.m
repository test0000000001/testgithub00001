//
//  NetUrlLength.m
//  VideoShare
//
//  Created by qin on 13-8-3.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "NetUrlLength.h"
#import "ASIHTTPRequest.h"

@implementation NetUrlLength
-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)fetchNetUrlLength:(NSString*)url:(void (^)(unsigned long long length))block
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"HEAD"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    NSMutableDictionary* userinfo = [[NSMutableDictionary alloc]initWithObjectsAndKeys:block,@"finishOperation",nil];
    [request setUserInfo:userinfo];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    void (^finishOperation)(unsigned long long) = [[request userInfo]objectForKey:@"finishOperation"];
    if (finishOperation) {
        finishOperation([request contentLength]);
    }
}
@end
