//
//  BaseThirdPartyModel.m
//  VideoShare
//
//  Created by qin on 13-5-22.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "BaseThirdPartyModel.h"

@implementation BaseThirdPartyModel
@synthesize responseStatusCode = _responseStatusCode;

- (id)init
{
    self = [super init];
    if(self){
        _responseStatusCode = 0;
    }
    return self;
}
@end
