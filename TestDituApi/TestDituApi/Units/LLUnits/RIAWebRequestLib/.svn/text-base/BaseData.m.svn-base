//
//  BaseResponseModel.m
//  VideoShare
//
//  Created by xu dongsheng on 13-5-22.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "BaseData.h"

@implementation BaseData
@synthesize responseStatusCode=_responseStatusCode;

- (id)init
{
    self = [super init];
    if (self) {
        _responseStatusCode = RIA_RESPONSE_CODE_SUCCESS;
    }
    return self;
}

-(void)setResponseModelFromDic:(NSDictionary*)dataDictionary{
    if(!OBJ_IS_NIL(dataDictionary) && [dataDictionary count]> 0){
        self.responseStatusCode = [[dataDictionary objectForKey:@"riaStatus"]intValue];
        self.status = [[dataDictionary objectForKey:@"status"]description];
        if([@"200600" isEqualToString:self.status]){
          self.crm_status = [[dataDictionary objectForKey:@"crm_status"]description];
        }
    }else{
        self.responseStatusCode = RIA_RESPONSE_CODE_FAILURE;
    }
}

@end
