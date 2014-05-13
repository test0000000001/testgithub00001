//
//  TokenInvalid.m
//  VideoShare
//
//  Created by qin on 13-7-29.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "TokenInvalid.h"
#import "ThirdPartyBindSettingModel.h"

@interface TokenInvalid(){
    ThirdPartyBindSettingModel *_bindModel;
}
@property (nonatomic, strong) ThirdPartyBindSettingModel *bindModel;

@end

@implementation TokenInvalid

-(id)init
{
    if(self = [super init]){
        self.bindModel = [[ThirdPartyBindSettingModel alloc] init];;
    }
    return self;
}

-(void)tokenInvalidBind:(NSString*)snstype{
    self.bindModel.isTokenInvalidBind = YES;
    [self.bindModel thirdPartyBidn:snstype];
}

@end
