//
//  NetUrlStatusAndType.m
//  VideoShare
//
//  Created by qin on 13-8-3.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "NetUrlStatusAndType.h"
#import "ASIHTTPRequest.h"

@implementation NetUrlStatusAndType
-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)fetchNetUrlStatusAndType:(NSString*)url:(void (^)(int status,NSString* type,unsigned long long length))block
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request redirectToURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"HEAD"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    NSMutableDictionary* userinfo = [[NSMutableDictionary alloc]initWithObjectsAndKeys:block,@"finishOperation",nil];
    [request setUserInfo:userinfo];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    void (^finishOperation)(int ,NSString* ,unsigned long long) = [[request userInfo]objectForKey:@"finishOperation"];
    if (finishOperation) {
        finishOperation(request.responseStatusCode,[request.responseHeaders valueForKey:@"Content-Type"],request.contentLength);
    }
}
@end
