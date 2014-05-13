//
//  SNSKitRequest.m
//  SNSKit
//
//  Created by wenjie-mac on 12-12-4.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "SNSKitRequest.h"
#import "SNSKit.h"
#import "JSONKit.h"
#import "../JSON/SBjson.h"
//新浪 = 腾讯的 HTTP响应时间 Boundary
#define kSinaWeiboRequestTimeOutInterval   180.0
#define kSinaWeiboRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"

#define kWBRequestTimeOutInterval   180.0
#define kWBRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"

#define kRENRENUserAgent  @"Renren iOS SDK v3.0"
#define kRENRENWBRequestTimeOutInterval   60.0
#define kRENRENWeiboRequestTimeOutInterval  @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3"


@interface SNSKit (SNSKitRequest)
- (void)requestDidFinish:(SNSKitRequest *)request;
- (void)requestDidFailWithInvalidToken:(NSError *)error;
@end

@interface SNSKitRequest (Private)

- (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString;
- (NSMutableData *)postBodyHasRawData:(BOOL*)hasRawData;
@end

@implementation SNSKitRequest
@synthesize url;
@synthesize httpMethod;
@synthesize params;
@synthesize delegate;
@synthesize snskit;

+ (SNSKitRequest *)requestWithURL:(NSString *)url
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                         delegate:(id<SNSKitRequestDelegate>)delegate
{
    SNSKitRequest *request = [[SNSKitRequest alloc] init];
    
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.delegate = delegate;
    
    return request;
}

//腾讯拼接URL
+ (NSString *)serializeURLforTC:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod{
    if (![httpMethod isEqualToString:@"GET"]){
        return baseURL;
    }
    NSURL *parsedURL = [NSURL URLWithString:baseURL];
	NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString *query = [SNSKitRequest stringFromDictionary:params];
	
	return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

+ (NSString *)stringFromDictionary:(NSDictionary *)dict{
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator]){
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]])){
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [dict objectForKey:key]]];
		}
        else{
            NSString* escaped_value = (NSString *)CFBridgingRelease
            (CFURLCreateStringByAddingPercentEscapes(
                                                     NULL, /* allocator */
                                                     (__bridge_retained CFStringRef)[dict objectForKey:key],
                                                     NULL, /* charactersToLeaveUnescaped */
                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                     kCFStringEncodingUTF8));
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key,escaped_value]];
        }
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

//新浪拼接URL
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    NSURL* parsedURL = [NSURL URLWithString:baseURL];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[params objectForKey:key] isKindOfClass:[NSData class]]))
        {
            if ([httpMethod isEqualToString:@"GET"])
            {
                NSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        id value = [params objectForKey:key];
        if([value isKindOfClass:[NSNumber class]]){
            value = [NSString stringWithFormat:@"%lld",[value longLongValue]];
        }
        NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL, /* allocator */
                                                                                      (__bridge_retained CFStringRef)(value),
                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8));
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

+ (NSString*)generateURLForRENREN:(NSString*)baseURL params:(NSDictionary*)params httpMethod:(NSString *)httpMethod{
    if (![httpMethod isEqualToString:@"GET"]){
        return baseURL;
    }
    if (params) {
        NSMutableArray* pairs = [NSMutableArray array];
        for (NSString* key in params.keyEnumerator) {
            if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
                ||([[params objectForKey:key] isKindOfClass:[NSData class]]))
            {
                if ([httpMethod isEqualToString:@"GET"])
                {
                    NSLog(@"can not use GET to upload a file");
                }
                continue;
            }
            NSString* value = [params objectForKey:key];
            NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL, /* allocator */
                                                                                          (CFStringRef)value,
                                                                                          NULL, /* charactersToLeaveUnescaped */
                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                          kCFStringEncodingUTF8));
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        }
        
        NSString* query = [pairs componentsJoinedByString:@"&"];
        NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
//        return [NSURL URLWithString:url];
        return url;
    } else {
        return baseURL;//return [NSURL URLWithString:baseURL];
    }
}

+ (NSString *)serializeURL:(NSString *)baseUrl params:(NSDictionary *)params{
    return [self serializeURL:baseUrl params:params httpMethod:@"GET"];
}


+(NSString *)getSecretKeyByToken:(NSString *)token
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   token, @"oauth_token",
								   nil];
	NSString *getKeyUrl = [self serializeURL:kRENRENRRSessionKeyURL params:params];
    id result = [self getRequestSessionKeyWithParams:getKeyUrl];
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSString* secretkey=[[result objectForKey:@"renren_token"] objectForKey:@"session_secret"];
		return secretkey;
	}
	return nil;
}


+(NSString *)getSessionKeyByToken:(NSString *)token
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   token, @"oauth_token",
								   nil];
	NSString *getKeyUrl = [self serializeURL:kRENRENRRSessionKeyURL params:params];
    id result = [self getRequestSessionKeyWithParams:getKeyUrl];
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSString* sessionkey=[[result objectForKey:@"renren_token"] objectForKey:@"session_key"];
		return sessionkey;
	}
	return nil;
}

+ (id)getRequestSessionKeyWithParams:(NSString *)url{
    NSURL* sessionKeyURL = [NSURL URLWithString:url];
	NSData *data=[NSData dataWithContentsOfURL:sessionKeyURL];
	NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    
	SBJsonParser *jsonParser = [SBJsonParser new];
	id result = [jsonParser objectWithString:responseString];
	return result;
}

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

- (void)connect
{
    NSString* urlString;
    if (snskit.getSNSType == SINA) {
        urlString = [[self class] serializeURL:url params:params httpMethod:httpMethod];
    }
    if (snskit.getSNSType == TC) {
        urlString = [[self class] serializeURLforTC:url params:params httpMethod:httpMethod];
    }
    
    if(snskit.getSNSType == RENREN){
        urlString = [[self class] generateURLForRENREN:url params:params httpMethod:httpMethod];
    }
    NSLog(@"urlString=%@",urlString);
    int timeOutInterval = kSinaWeiboRequestTimeOutInterval;
    if(snskit.getSNSType == RENREN){
        timeOutInterval = kRENRENWBRequestTimeOutInterval;
    }
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                        timeoutInterval:timeOutInterval];
    
    [request setHTTPMethod:self.httpMethod];
    if(snskit.getSNSType == RENREN){
        UIDevice *device = [UIDevice currentDevice];
        NSString *ua = [NSString stringWithFormat:@"%@ (%@; %@ %@)",kRENRENUserAgent,device.model,device.systemName,device.systemVersion];
        [request setValue:ua forHTTPHeaderField:@"User-Agent"];
    }
    if ([self.httpMethod isEqualToString: @"POST"])
    {
        
        BOOL hasRawData = NO;//是否上传图片 或 文件
        
        
        
        if(snskit.getSNSType == RENREN){
            //                NSMutableData *body = [NSMutableData data];
            //                NSString *dataString = [SNSKitRequest stringFromDictionary:params];
            //                [self appendUTF8Body:body dataString:dataString];
            //                [request setHTTPBody:body];
            [request setHTTPBody:[self generatePostBody]];
            if([self isKindOfUIImage]){
                hasRawData = YES;
            }
        }else{
            [request setHTTPBody:[self postBodyHasRawData:&hasRawData]];
        }
        
        if (hasRawData)
        {
            NSString *boundary = kSinaWeiboRequestStringBoundary;
            if(snskit.getSNSType == RENREN){
                boundary = kRENRENWeiboRequestTimeOutInterval;
            }
            NSString* contentType = [NSString
                                     stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        }
        
        else if(snskit.getSNSType == TC)
        {
            NSMutableData *body = [NSMutableData data];
            NSString *dataString = [SNSKitRequest stringFromDictionary:params];
            [self appendUTF8Body:body dataString:dataString];
            [request setHTTPBody:body];
        }
    }
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)disconnect
{
	responseData = nil;
    
    [connection cancel];
    connection = nil;
}

/**
 *人人网参数转换为NSMutableData
 */
- (NSMutableData *)generatePostBody {
	NSMutableData *body = [NSMutableData data];
	NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kRENRENWeiboRequestTimeOutInterval];
	NSMutableArray *pairs = [NSMutableArray array];
    if ([self isKindOfUIImage]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kRENRENWeiboRequestTimeOutInterval] dataUsingEncoding:NSUTF8StringEncoding]];
        for(NSString *key in [params keyEnumerator]){
            if ([key isEqualToString:@"upload"]) {
                continue;
            }
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name = \"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[params valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
        }
        NSData *_dataParam=[params valueForKey:@"upload"];
        NSData *imageData = UIImagePNGRepresentation((UIImage*)_dataParam);
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\";filename=no.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type:image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kRENRENWeiboRequestTimeOutInterval] dataUsingEncoding:NSUTF8StringEncoding]];
    }else {
        for (NSString* key  in [params keyEnumerator]) {
            NSString* value = [params objectForKey:key];
            NSString* value_str = [self encodeString:value urlEncode:NSUTF8StringEncoding];
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value_str]];
        }
        NSString* params = [pairs componentsJoinedByString:@"&"];
        [body appendData:[params dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return body;
}
/**
 *是否上传图片分享
 */
-(BOOL)isKindOfUIImage{
    NSString *iskind=nil;
    for (NSString *key in [params keyEnumerator]) {
        if ([key isEqualToString:@"upload"]) {
            iskind=key;
            break;
        }
	}
	return iskind!=nil;
}

/**
 * 对字符串进行URL编码转换。
 */
- (NSString*)encodeString:(NSString*)string urlEncode:(NSStringEncoding)encoding {
    NSMutableString *escaped = [NSMutableString string];
    [escaped setString:[string stringByAddingPercentEscapesUsingEncoding:encoding]];
    
    [escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    
    return escaped;
}
#pragma mark - SinaWeiboRequest Private Methods

- (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString
{
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}


- (NSMutableData *)postBodyHasRawData:(BOOL*)hasRawData
{
    NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", kSinaWeiboRequestStringBoundary];
    NSString *bodySuffixString = [NSString stringWithFormat:@"\r\n--%@--\r\n", kSinaWeiboRequestStringBoundary];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    NSMutableData *body = [NSMutableData data];
    [self appendUTF8Body:body dataString:bodyPrefixString];
    
    for (id key in [params keyEnumerator])
    {
        if (([[params valueForKey:key] isKindOfClass:[UIImage class]]) || ([[params valueForKey:key] isKindOfClass:[NSData class]]))
        {
            [dataDictionary setObject:[params valueForKey:key] forKey:key];
            continue;
        }
        
        [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, [params valueForKey:key]]];
        [self appendUTF8Body:body dataString:bodyPrefixString];
    }
    
    if ([dataDictionary count] > 0)
    {
        *hasRawData = YES;
        for (id key in dataDictionary)
        {
            NSObject *dataParam = [dataDictionary valueForKey:key];
            
            if ([dataParam isKindOfClass:[UIImage class]])
            {
                NSData* imageData = UIImagePNGRepresentation((UIImage *)dataParam);
                [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file\"\r\n", key]];
                [self appendUTF8Body:body dataString:@"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
                [body appendData:imageData];
            }
            else if ([dataParam isKindOfClass:[NSData class]])
            {
                [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file\"\r\n", key]];
                [self appendUTF8Body:body dataString:@"Content-Type: content/unknown\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
                [body appendData:(NSData*)dataParam];
            }
            [self appendUTF8Body:body dataString:bodySuffixString];
        }
    }
    
    return body;
}


- (void)handleResponseData:(NSData *)data
{
    if ([delegate respondsToSelector:@selector(request:didReceiveRawData:)])
    {
        [delegate request:self didReceiveRawData:data];
    }
	
	NSError *error = nil;
	id result = [self parseJSONData:data error:&error];
	
	if (error)
	{
		[self failedWithError:error];
	}
	else
	{
        NSInteger error_code = 0;
        if ([result isKindOfClass:[NSDictionary class]]) {
            error_code = [[result objectForKey:@"error_code"] intValue];
        }
        if (error_code != 0)
        {
            NSString *error_description = [result objectForKey:@"error"];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      result, @"error",
                                      error_description, NSLocalizedDescriptionKey, nil];
            NSError *error = [NSError errorWithDomain:kSinaWeiboSDKErrorDomain
                                                 code:[[result objectForKey:@"error_code"] intValue]
                                             userInfo:userInfo];
            
            if (error_code == 21314     //Token已经被使用
                || error_code == 21315  //Token已经过期
                || error_code == 21316  //Token不合法
                || error_code == 21317  //Token不合法
                || error_code == 21327  //token过期
                || error_code == 21332) //access_token 无效
            {
                [snskit requestDidFailWithInvalidToken:error];
            }
            else
            {
                [self failedWithError:error];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)])
            {
                [delegate request:self didFinishLoadingWithResult:(result == nil ? data : result)];
            }
        }
	}
}

- (id)parseJSONData:(NSData *)data error:(NSError **)error
{
    NSError *parseError = nil;
	id result =[data objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&parseError];
	
	if (parseError && (error != nil))
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  parseError, @"error",
                                  @"Data parse error", NSLocalizedDescriptionKey, nil];
        *error = [self errorWithCode:kSinaWeiboSDKErrorCodeParseError
                            userInfo:userInfo];
	}
	
	return result;
}

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:kSinaWeiboSDKErrorDomain code:code userInfo:userInfo];
}

- (void)failedWithError:(NSError *)error
{
	if ([delegate respondsToSelector:@selector(request:didFailWithError:)])
	{
		[delegate request:self didFailWithError:error];
	}
}
#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData = [[NSMutableData alloc] init];
	
	if ([delegate respondsToSelector:@selector(request:didReceiveResponse:)])
    {
		[delegate request:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
	[self handleResponseData:responseData];
    
	responseData = nil;
    
    [connection cancel];
	connection = nil;
    
    [snskit requestDidFinish:self];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
	[self failedWithError:error];
	
	responseData = nil;
    
    [connection cancel];
	connection = nil;
    
    [snskit requestDidFinish:self];
}
@end
