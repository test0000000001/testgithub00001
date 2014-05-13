//
//  RequestModel.h
//  VideoShare
//
//  Created by xu dongsheng on 13-5-17.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

typedef enum
{
    REQUEST_METHOD_GET, //get请求方式
    REQUEST_METHOD_POST, //post方式
} REQUEST_METHOD;

@interface RequestModel : NSObject

@property(strong, nonatomic) NSString* url;//请求url
@property(strong, nonatomic) NSDictionary* params; //请求参数信息
@property(assign, nonatomic) NSTimeInterval timeoutSeconds; //超时时间，不设置为默认值60s
@property(assign, nonatomic) REQUEST_METHOD requestMethod; //请求方式

-(id)initWithUrl:(NSString*)url params:(NSDictionary*)params;
-(id)initWithUrl:(NSString*)url params:(NSDictionary*)params requestMethod:(REQUEST_METHOD)requestMethod;
//请求合法性校验
-(BOOL)isRequestValid;
@end
