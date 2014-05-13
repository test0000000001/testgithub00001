//
//  BaseThirdPartyModel.h
//  VideoShare
//
//  Created by qin on 13-5-22.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    RESPONSE_CODE_SUCCESS = 0,
    RESPONSE_CODE_FAILURE = -1
}RESPONSE_CODE;

@interface BaseThirdPartyModel : NSObject
//请求响应码  0代表成功  -1代表失败
@property  (nonatomic, assign) int responseStatusCode;

@end
