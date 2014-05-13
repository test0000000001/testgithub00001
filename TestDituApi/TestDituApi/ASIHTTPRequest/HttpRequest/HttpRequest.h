//
//  HttpRequest.h
//  VideoShare
//
//  Created by xu dongsheng on 13-5-17.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestModel.h"

//请求响应码定义
typedef enum
{
    RIA_RESPONSE_CODE_SUCCESS = 0,      // 0代表成功
    RIA_RESPONSE_CODE_NET_FAILURE= -1,  // -1代表网络请求失败
    RIA_RESPONSE_CODE_FAILURE = -2      // -2代表服务器端返回异常
} RIA_RESPONSE_CODE;

@interface HttpRequest : NSObject

/**
 * 功能：执行RIA普通文本信息的http请求（支持Get和post请求，根据requestModel的请求类型决定请求方式）
 * 参数：requestModel 请求数据模型
 *       mainBlock 请求完成后服务器返回数据回调
 * 返回值：空
 
 * 创建者：xudongsheng
 */
+(void)doRIAHttpRequest:(RequestModel*)requestModel mainBlock:(void(^)(NSDictionary* returnDict))mainBlock;

/**
 * 功能：RIA请求专用 post请求服务器(发送普通文本信息，忽略requestModel指定的请求方式)
 * 参数：requestModel 请求数据模型
 *       mainBlock 请求完成后服务器返回数据回调
 * 返回值：空
 */
+(void)doRIAHttpPost:(RequestModel*)requestModel mainBlock:(void(^)(NSDictionary* returnDict))mainBlock;

/**
 * 功能：RIA请求专用 get请求服务器(发送普通文本信息，忽略requestModel指定请求方式)
 * 参数：requestModel 请求数据模型，
 *       mainBlock 请求完成后服务器返回数据回调
 * 返回值：空
 */
+(void)doRIAHttpGet:(RequestModel*)requestModel mainBlock:(void(^)(NSDictionary* returnDict))mainBlock;

/**
 * 功能：post请求上传图片
 * 参数：requestModel 请求数据模型
        picData  图片数据NSData
 *      picName  图片名称
 *      key      图片key
        mainBlock 请求完成后服务器返回数据回调
 * 返回值：空
 
 * 创建者：xudongsheng
 */
+ (void)doPicPostRequest:(RequestModel*)requestModel setPic:(NSData *)picData setPicName:(NSString *)picName setKey:(NSString *)key mainBlock:(void(^)(NSDictionary* response))mainBlock;

/**
 * 功能：普通post请求服务器(发送普通文本信息)
 * 参数：url 请求url
        timeoutSeconds 请求超时时间 若不指定 默认为60
        params 请求参数字典
 *      mainBlock 请求完成后服务器返回数据回调
 * 返回值：空
 */
+ (void)doCommonHttpPost:(NSString *)url timeoutSeconds:(NSTimeInterval)timeoutSeconds  setDictionary:(NSDictionary *)params mainBlock:(void(^)(NSDictionary* response))mainBlock;

/**
 * 功能：普通get请求服务器(发送普通文本信息)
 * 参数：url 请求url
        timeoutSeconds 请求超时时间 若不指定 默认为60
        params 请求参数字典
 *      mainBlock 请求完成后服务器返回数据回调
 * 返回值：空
 */
+ (void)doCommonHttpGet:(NSString *)url timeoutSeconds:(NSTimeInterval)timeoutSeconds  setDictionary:(NSDictionary *)params mainBlock:(void(^)(NSDictionary* response))mainBlock;

/**
 * 功能：翻转地址，在较短时间内获取不到地址后及时返回
 */
+(void)postWithAutoLoginUrl:(NSString *)url param:(NSDictionary *)params mainBlock:(void (^)(NSDictionary *returnDict))mainBlock;

+(NSString *)postAutoLoginRequest:(NSString *)urlS setDictionary:(NSDictionary *)d;
@end
