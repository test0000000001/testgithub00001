
//
//  BaseResponseModel.h 服务器返回数据模型基类，所有服务器返回数据模型都来继承我
//  VideoShare
//
//  Created by xu dongsheng on 13-5-22.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"

@interface BaseData : NSObject
@property (nonatomic, assign) RIA_RESPONSE_CODE responseStatusCode;
@property (nonatomic, strong) NSString *status; //服务器返回状态码
@property (nonatomic, strong) NSString *crm_status; //当status=200600，crm_status有效，crm状态请看（点击我）
//根据字典生成Model
-(void)setResponseModelFromDic:(NSDictionary*)dataDictionary;

@end
