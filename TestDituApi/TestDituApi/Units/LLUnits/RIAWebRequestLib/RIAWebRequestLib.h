
//
//  RIAWebRequestLib.h 封装RIA网络交互接口,此文件不支持Arc
//  VideoShare
//
//  Created by xu dongsheng on 13-5-22.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
/*******************************使用说明***************************************/
/* (1)生成一个RequestModel的实例,携带请求url，参数信息，跟请求方式信息，
   初始化一个RquestModel 实例有两种形式:
   形式一:
     [[RequestModel alloc]initWithUrl:VIDEO_RECOMMEND_URL params:[[NSDictionary alloc]initWithObjectsAndKeys:@"aa",aa,nil]]; 
     这种形式初始化的RequestModel默认请求方式为Post请求
   形式二：
      [[RequestModel alloc]initWithUrl:VIDEO_RECOMMEND_URL params:[[NSDictionary alloc]initWithObjectsAndKeys:@"aa",aa,nil] requestMethod:REQUEST_METHOD_GET]; 
       自己制定请求方式(get或post)
    (2)定义一个请求数据模型，对服务器返回数据的封装，并使其继承BaseData,并重写
 -(void)setResponseModelFromDic:(NSDictionary*)dataDictionary{
 [super setResponseModelFromDic:dataDictionary];
 }
    可参照Ar模块定义的ArData
    (3)通过RIAWebRequestLib 实例调用fetchDataFromNet方法
      邢若
      [_webRequestLib fetchDataFromNet:requestModel dataModelClass:[ArData class] mainBlock:^(BaseData *responseModel) {
        ArData* arResponseModel = (ArData*)responseModel;
        [self sendEvent:arResponseModel];
       }];
      详细使用请参照Ar模块相关类，AroundViewController，ArData，及ArModel类使用。
 */

#import <Foundation/Foundation.h>
#import "RequestModel.h"
#import "BaseData.h"
#import "LLServiceUrlDefines.h"

@interface RIAWebRequestLib : NSObject

+(RIAWebRequestLib *)riaWebRequestLib;
/**
 * 功能：请求RIA服务器
 * 参数：requestModel 请求数据模型,包括请求url，请求参数，请求方式（get，post）
        dataModelClass 服务器返回数据模型类
 *      mainBlock 请求完成后返回上层的数据回调， 参数responseModel 为上层可直接使用的数据模型实例
 * 返回值：空
 
 * 创建者：xudongsheng
 */
-(void)fetchDataFromNet:(RequestModel*)requestModel dataModelClass:(Class)dataModelClass mainBlock:(void(^)(BaseData* responseModel))mainBlock;


//单例销毁
-(void)attemptDealloc;
@end
