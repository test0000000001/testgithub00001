//
//  RIAWebRequestLib.m
//  VideoShare
//
//  Created by xu dongsheng on 13-5-22.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "RIAWebRequestLib.h"
#import "HttpRequest.h"

@implementation RIAWebRequestLib
static RIAWebRequestLib *webRequestLib = nil;

+(RIAWebRequestLib *)riaWebRequestLib{
    @synchronized(webRequestLib)
    {
        if (!webRequestLib)
        {
            webRequestLib=[[self alloc]init];
        }
    }
    return webRequestLib;
}

-(void)fetchDataFromNet:(RequestModel*)requestModel dataModelClass:(Class)dataModelClass mainBlock:(void(^)(BaseData* responseModel))mainBlock{
    [HttpRequest doRIAHttpRequest:requestModel mainBlock:^(NSDictionary* returnDict) {
        id responseDataModel = (id)class_createInstance(dataModelClass,0);
        if ([responseDataModel respondsToSelector:@selector(setResponseStatusCode:)] &&[responseDataModel respondsToSelector:@selector(setResponseModelFromDic:)])
        {
            if (returnDict!=nil && [returnDict isKindOfClass:[NSDictionary class]]) {
                if ([[returnDict objectForKey:@"riaStatus"] intValue]== RIA_RESPONSE_CODE_SUCCESS) {//请求成功
                    [responseDataModel setResponseStatusCode:RIA_RESPONSE_CODE_SUCCESS];
                    //NSLog(@"%@", returnDict);
                    [responseDataModel setResponseModelFromDic:returnDict];

                }else if([[returnDict objectForKey:@"riaStatus"] intValue]== RIA_RESPONSE_CODE_NET_FAILURE){//网络出错
                    [responseDataModel setResponseStatusCode:RIA_RESPONSE_CODE_NET_FAILURE];
                    [responseDataModel setResponseModelFromDic:returnDict];
                }else{//服务器出错
                    [responseDataModel setResponseStatusCode:RIA_RESPONSE_CODE_FAILURE];
                    [responseDataModel setResponseModelFromDic:returnDict];
                }
            }else{
                [responseDataModel setResponseStatusCode:RIA_RESPONSE_CODE_FAILURE];
            }
            mainBlock(responseDataModel);
        }
    }];
}

//单例销毁
-(void)attemptDealloc
{
    webRequestLib = nil;
}
@end
