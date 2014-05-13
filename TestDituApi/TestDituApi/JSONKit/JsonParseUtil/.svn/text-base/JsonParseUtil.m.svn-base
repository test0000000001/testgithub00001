//
//  JsonParseUtil.m
//  VideoShare
//
//  Created by xu dongsheng on 13-5-22.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "JsonParseUtil.h"
#import "JSONKit.h"

@implementation JsonParseUtil

+ (id)parseJSONData:(NSString*)response error:(NSError **)error
{
    NSError *parseError = nil;
    id result = [response mutableObjectFromJSONStringWithParseOptions:JKParseOptionStrict error:&parseError];
	if (parseError && (error != nil))
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  parseError, @"error",
                                  @"Data parse error", NSLocalizedDescriptionKey, nil];
        *error = [self errorWithCode:ErrorCodeDataParseError
                            userInfo:userInfo];
	}
	
	return result;
}

+ (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:kLooklookResponseErrorDomain code:code userInfo:userInfo];
}

+(NSString*)convertDicToJsonString:(NSDictionary*)dic{
    NSString *jsonString = [dic JSONString];
    return jsonString;
}

@end
