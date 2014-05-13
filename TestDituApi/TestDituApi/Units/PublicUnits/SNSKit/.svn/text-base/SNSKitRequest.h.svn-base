//
//  SNSKitRequest.h
//  SNSKit
//
//  Created by wenjie-mac on 12-12-4.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNSKitRequest;
@class SNSKit;

/**
 * @description 第三方应用访问微博API时实现此此协议，当sdk完成api的访问后通过传入的此类对象完成接口访问结果的回调，应用在协议实现的相应方法中接收访问结果并做对应处理。
 */
@protocol SNSKitRequestDelegate <NSObject>
@optional
- (void)request:(SNSKitRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(SNSKitRequest *)request didReceiveRawData:(NSData *)data;
- (void)request:(SNSKitRequest *)request didFailWithError:(NSError *)error;
- (void)request:(SNSKitRequest *)request didFinishLoadingWithResult:(id)result;
@end

@interface SNSKitRequest : NSObject
{
    SNSKit                          *snskit;//weak reference
    NSString                        *url;
    NSString                        *httpMethod;
    NSDictionary                    *params;
    
//    id<SNSKitRequestDelegate>    delegate;
    
    NSURLConnection                 *connection;
    NSMutableData                   *responseData;
}
@property (nonatomic, strong) SNSKit *snskit;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *httpMethod;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) id<SNSKitRequestDelegate> delegate;

+ (SNSKitRequest *)requestWithURL:(NSString *)url
                          httpMethod:(NSString *)httpMethod
                              params:(NSDictionary *)params
                            delegate:(id<SNSKitRequestDelegate>)delegate;

//sina生成请求链接 URL编码
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

//腾讯拼接URL
+ (NSString *)serializeURLforTC:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;
//腾讯 NSDictionary 转 string URL编码
+ (NSString *)stringFromDictionary:(NSDictionary *)dict;

//从URL 解析param value
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;

/*
 * 人人网使用传入的baseURL地址和参数集合构造含参数的请求URL的工具方法。
 */
+ (NSString*)generateURLForRENREN:(NSString*)baseURL params:(NSDictionary*)params httpMethod:(NSString *)httpMethod;

+ (NSString*)serializeURL:(NSString *)baseUrl params:(NSDictionary *)params;

/**
 * 用accesstoken 获取调用api 时用到的参数session_secret
 */
+(NSString *)getSecretKeyByToken:(NSString *)token;

/**
 * 用accesstoken 获取调用api 时用到的参数session_key
 */
+(NSString *)getSessionKeyByToken:(NSString *)token;

+ (id)getRequestSessionKeyWithParams:(NSString *)url;

- (void)connect;
- (void)disconnect;
@end
