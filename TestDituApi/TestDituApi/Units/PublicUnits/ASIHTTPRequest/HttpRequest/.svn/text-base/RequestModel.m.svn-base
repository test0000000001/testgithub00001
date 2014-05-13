//
//  RequestModel.m
//  VideoShare
//
//  Created by xu dongsheng on 13-5-17.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel

@synthesize url=_url;
@synthesize params=_params;
@synthesize timeoutSeconds=_timeoutSeconds;
@synthesize requestMethod=_requestMethod;

-(id)initWithUrl:(NSString*)url params:(NSDictionary*)params{
      //默认post请求
    return [self initWithUrl:url params:params requestMethod:REQUEST_METHOD_POST];
 }

-(NSMutableDictionary*)concatCommonParamsWithOrigin:(NSDictionary*)originParams{
    NSMutableDictionary* allParams = [NSMutableDictionary dictionaryWithDictionary:originParams];
    [allParams setObject:APP_MAC forKey:@"mac"];
    [allParams setObject:APP_UDID forKey:@"imei"];
    return allParams;
}

-(id)initWithUrl:(NSString*)url params:(NSMutableDictionary*)params requestMethod:(REQUEST_METHOD)requestMethod
{
    self = [super init];
    if (self) {
        _url = url;
        NSMutableDictionary* allParams = [self concatCommonParamsWithOrigin:params];
        _params = allParams;
        _timeoutSeconds = 0;
        _requestMethod=requestMethod;
    }
    return self;
}

-(BOOL)isRequestValid{
    if(![@"" isEqualToString:UN_NIL(self.url)]){
        return YES;
    }
    return NO;
}
@end
