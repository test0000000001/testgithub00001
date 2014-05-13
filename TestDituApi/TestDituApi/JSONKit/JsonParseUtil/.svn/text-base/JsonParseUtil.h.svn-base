//
//  JsonParseUtil.h
//  VideoShare
//
//  Created by xu dongsheng on 13-5-22.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	ErrorCodeDataParseError       = 200,
} ErrorCode;

#define kLooklookResponseErrorDomain   @"LooklookResponseErrorDomain"

@interface JsonParseUtil : NSObject
//解析json字符串
+ (id)parseJSONData:(NSString*)response error:(NSError **)error;

//将字典数据转换为json字符串
+(NSString*)convertDicToJsonString:(NSDictionary*)dic;

@end
