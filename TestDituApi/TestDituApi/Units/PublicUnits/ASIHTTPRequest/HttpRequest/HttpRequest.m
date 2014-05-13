//
//  HttpRequest.m
//  VideoShare
//
//  Created by xu dongsheng on 13-5-17.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "HttpRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JsonParseUtil.h"
#import "UrlEncoder.h"
#import "../../JSON/SBjson.h"
#import "GetNetworkInfoModel.h"
#import "JSONKit.h"

@implementation HttpRequest

+(void)doRIAHttpRequest:(RequestModel*)requestModel mainBlock:(void(^)(NSDictionary* returnDict))mainBlock{
    if(requestModel.requestMethod == REQUEST_METHOD_POST){
        [self doRIAHttpPost:requestModel mainBlock:mainBlock];
    }else if(requestModel.requestMethod == REQUEST_METHOD_GET){
        [self doRIAHttpGet:requestModel mainBlock:mainBlock];
    }
}

+(void)doRIAHttpPost:(RequestModel*)requestModel mainBlock:(void(^)(NSDictionary* returnDict))mainBlock{
    if(!requestModel.isRequestValid)
        return;
    NSDictionary* param=[[NSDictionary alloc]initWithDictionary:requestModel.params];
    NSString *jsonString = [JsonParseUtil convertDicToJsonString:param];
    NSLog(@"\n(ria request)%@\nparams is:\n%@\n\n\n",requestModel.url, jsonString);
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    [requestData setObject:jsonString forKey:@"requestapp"];
//    NSString* jsonStrUrlEncoded = [UrlEncoder encodeToPercentEscapeString:[UrlEncoder encodeToPercentEscapeString:UN_NIL(jsonString)]];
//    [requestData setObject:jsonStrUrlEncoded forKey:@"requestapp"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * response = [HttpRequest postRequest:requestModel.url timeoutSeconds:requestModel.timeoutSeconds setDictionary:requestData];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"\n(ria response)%@\nresult is:\n%@\n\n\n",requestModel.url, response);
            [HttpRequest setRequestFinishBlock:response mainBlock:mainBlock];
        });
    });
}

+(void)doRIAHttpGet:(RequestModel*)requestModel mainBlock:(void(^)(NSDictionary* returnDict))mainBlock{
    if(!requestModel.isRequestValid)
        return;
    NSDictionary* param=[[NSDictionary alloc]initWithDictionary:requestModel.params];
    NSString *jsonString = [JsonParseUtil convertDicToJsonString:param];
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc]initWithCapacity:1];
    NSString* jsonStrUrlEncoded = [UrlEncoder encodeToPercentEscapeString:[UrlEncoder encodeToPercentEscapeString:UN_NIL(jsonString)]];
    [requestData setObject:jsonStrUrlEncoded forKey:@"requestapp"];
    NSLog(@"----------ria origin request info is %@", requestData);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * response = [HttpRequest getRequest:requestModel.url timeoutSeconds:requestModel.timeoutSeconds setDictionary:requestData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [HttpRequest setRequestFinishBlock:response mainBlock:mainBlock];
        });
    });
}

+ (void)doPicPostRequest:(RequestModel*)requestModel setPic:(NSData *)picData setPicName:(NSString *)picName setKey:(NSString *)key mainBlock:(void(^)(NSDictionary* response))mainBlock{
    if(!requestModel.isRequestValid)
        return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * response = [HttpRequest postPicRequest:requestModel.url setDictionary:requestModel.params setPic:picData setPicName:picName setKey:key];
        dispatch_async(dispatch_get_main_queue(), ^{
           [HttpRequest setRequestFinishBlock:response mainBlock:mainBlock];
        });
    });
}

+ (void)doCommonHttpPost:(NSString *)url timeoutSeconds:(NSTimeInterval)timeoutSeconds  setDictionary:(NSDictionary *)params mainBlock:(void(^)(NSDictionary* response))mainBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * response = [HttpRequest postRequest:url timeoutSeconds:timeoutSeconds setDictionary:params];
        dispatch_async(dispatch_get_main_queue(), ^{
            [HttpRequest setRequestFinishBlock:response mainBlock:mainBlock];
        });
    });
}

+ (void)doCommonHttpGet:(NSString *)url timeoutSeconds:(NSTimeInterval)timeoutSeconds  setDictionary:(NSDictionary *)params mainBlock:(void(^)(NSDictionary* response))mainBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * response = [HttpRequest getRequest:url timeoutSeconds:timeoutSeconds setDictionary:params];
        dispatch_async(dispatch_get_main_queue(), ^{
            [HttpRequest setRequestFinishBlock:response mainBlock:mainBlock];
        });
    });
}

+(void)setRequestFinishBlock:(NSString*)response mainBlock:(void(^)(NSDictionary* returnDict))mainBlock{
    NSMutableDictionary *root =[NSMutableDictionary new] ;
    if (response==nil) {
        [root setObject:[[NSNumber alloc] initWithInt:RIA_RESPONSE_CODE_NET_FAILURE] forKey:@"riaStatus"];
    }else{
        @try {
            NSError *parseError = nil;
            root = [JsonParseUtil parseJSONData:response error:&parseError];
            if(parseError){
                [root setObject:[[NSNumber alloc] initWithInt:RIA_RESPONSE_CODE_FAILURE]  forKey:@"riaStatus"];
            }else{
               NSString *statusCode = [[root objectForKey:@"status"]description];
              if([statusCode intValue] == 0){
                 [root setObject:[[NSNumber alloc] initWithInt:RIA_RESPONSE_CODE_SUCCESS]  forKey:@"riaStatus"];
              }else{
                 [root setObject:[[NSNumber alloc] initWithInt:RIA_RESPONSE_CODE_FAILURE]  forKey:@"riaStatus"];
              }
               
            }
        }
        @catch (NSException *exception) {
            [root setObject:[[NSNumber alloc] initWithInt:RIA_RESPONSE_CODE_FAILURE] forKey:@"riaStatus"];
        }
    }
    mainBlock(root);
}

+ (NSString*)postPicRequest:(NSString *)url setDictionary:(NSDictionary *)params  setPic:(NSData *)picData setPicName:(NSString *)picName setKey:(NSString *)key{
    NSString *response = nil;
    NSURL *reqeustUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:reqeustUrl];
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    [request setData:picData withFileName:picName andContentType:@"image/png" forKey:key];
    
    
    NSString *jsonString = [JsonParseUtil convertDicToJsonString:params];
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc]initWithCapacity:1];
    [requestData setObject:jsonString forKey:@"requestapp"];
    
    int paramsCount = [requestData count];
    if (paramsCount > 0) {
        NSArray *keys = [[NSArray alloc] init ];
        keys = [requestData allKeys];
        for (int i = 0; i < paramsCount; i++) {
            NSString *key = [keys objectAtIndex:i];
            NSString *value = [requestData objectForKey:key];
            [request setPostValue:value forKey:key];
        }
    }
    @try {
        //设置5分钟超时
        NSLog(@"\n(ria request)%@\nparams is:\n%@\n\n\n",url, jsonString);
        [request setTimeOutSeconds:300];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error && request.responseStatusCode>=200 && request.responseStatusCode<300 && [request.responseString characterAtIndex:0]=='{') {
            response = [request responseString];
        }
        NSLog(@"\n(ria response)%@\nresult is:\n%@\n\n\n",url, response);
    }
    @catch (NSException *exception) {
        
    }
    return response;
}

+ (NSString *)postRequest:(NSString *)url timeoutSeconds:(NSTimeInterval)timeoutSeconds  setDictionary:(NSDictionary *)params {
    NSString *response = nil;
    NSURL *requsetUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requsetUrl];
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    if (params.count > 0) {
        NSArray *keys = [[NSArray alloc] init ];
        keys = [params allKeys];
        for (int i = 0; i < params.count; i++) {
            NSString *key = [keys objectAtIndex:i];
            NSString *value = [params objectForKey:key];
            [request setPostValue:value forKey:key];
        }
    }
    @try {
        if(timeoutSeconds == 0){
            [request setTimeOutSeconds:60];
        }else{
          [request setTimeOutSeconds:timeoutSeconds];
        }
        [request startSynchronous];
        NSError *error = [request error];
        if (!error && request.responseStatusCode>=200 && request.responseStatusCode<300 ) {
            response = [request responseString];
        }
    }
    @catch (NSException *exception) {
        
    }
    return response;
}

+ (NSString *)getRequest:(NSString *)url timeoutSeconds:(NSTimeInterval)timeoutSeconds setDictionary:(NSDictionary *)params {
    NSString *response = nil;
    NSString* urlWithParams = [url stringByAppendingString:@"?"];
    if (params.count > 0) {
        NSArray *keys = [[NSArray alloc] init ];
        keys = [params allKeys];
        for (int i = 0; i < params.count; i++) {
            NSString *key = [keys objectAtIndex:i];
            NSString *value = [params objectForKey:key];
            NSString* keyValueStr = [[key stringByAppendingString:@"="]stringByAppendingString:[UrlEncoder encodeToPercentEscapeString:value]];
            keyValueStr = [keyValueStr stringByAppendingString:@"&"];
            urlWithParams = [urlWithParams stringByAppendingString:keyValueStr];
        }
        //删除多余的“&”字符
        urlWithParams = [urlWithParams substringToIndex:(urlWithParams.length - 1)];
    }
    NSURL *requsetUrl = [NSURL URLWithString:urlWithParams];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requsetUrl];
    @try {
        if(timeoutSeconds == 0){
            [request setTimeOutSeconds:60];
        }else{
            [request setTimeOutSeconds:timeoutSeconds];
        }
        [request startSynchronous];
        NSError *error = [request error];
        if (!error && request.responseStatusCode>=200 && request.responseStatusCode<300 ) {
            response = [request responseString];
        }
    }
    @catch (NSException *exception) {
        
    }
    return response;
}

//added by dongdw //modified by zengchao,jason放到线程外面做
+(void)postWithAutoLoginUrl:(NSString *)url param:(NSDictionary *)params mainBlock:(void (^)(NSDictionary *returnDict))mainBlock
{
    //debug_NSLog(@"postRequest:\n>>>>>>>>>>>>>>>>>>>>>>>>>\nurl:\n%@\ndictionary:\n%@\n",[url description],[[params description] stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""]);
    NSDictionary* param=[[NSDictionary alloc]initWithDictionary:params];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc]init];
    NSString *jsonString = [jsonWriter stringWithObject:param];
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc]initWithCapacity:1];
    [requestData setObject:jsonString forKey:@"requestapp"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * response = [HttpRequest postAutoLoginRequest:url setDictionary:requestData];
        //NSLog(@"%@ response:\n%@\n<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n",[url description],[response description]);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *root =nil;
            if (response==nil) {
                root=[[NSMutableDictionary alloc]initWithCapacity:1];
                [root setObject:@"100" forKey:@"status"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc] init];
                NSError *error = nil;
                @try {
                    root= [[NSMutableDictionary alloc] initWithDictionary:[parser  objectWithString:response error:&error]];
                    NSLog(@"response  ===== %@",response);
                    if (error!=nil) {
                        [root setObject:@"100" forKey:@"status"];
                    }
                }
                @catch (NSException *exception) {
                    [root setObject:@"100" forKey:@"status"];
                }
                
            }
            mainBlock(root);
            
        });
    });
    
}

+ (NSString *)postAutoLoginRequest:(NSString *)urlS setDictionary:(NSDictionary *)d {
    if ([GetNetworkInfoModel getNetworkType] == NETWORK_NOT_AVAILABLE) {
        return nil;
    }
//    debug_NSLog(@"postRequest:\n>>>>>>>>>>>>>>>>>>>>>>>>>\nurl:\n%@\ndictionary:\n%@\n",urlS,[[d description] stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""]);
    NSString *response = nil;
    NSURL *url = [NSURL URLWithString:urlS];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    if (d.count > 0) {
        NSArray *keys = [[NSArray alloc] init ];
        keys = [d allKeys];
        for (int i = 0; i < d.count; i++) {
            NSString *key = [keys objectAtIndex:i];
            NSString *value = [d objectForKey:key];
            [request setPostValue:value forKey:key];
        }
    }
    //[request setFile:@"/Users/ben/Desktop/ben.jpg" forKey:@"photo"];
    //[request addData:imageData withFileName:@"george.jpg" andContentType:@"image/jpeg" forKey:@"photos"];
    @try {
        [request setTimeOutSeconds:3.5];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error && request.responseStatusCode>=200 && request.responseStatusCode<300 ) {
            response = [request responseString];
        }
    }
    @catch (NSException *exception) {
        
    }
    
    
    NSLog(@"%@ response:\n%@\n<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n",urlS,response);
    return response;
}

@end
