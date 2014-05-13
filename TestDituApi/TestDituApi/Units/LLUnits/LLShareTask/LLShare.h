//
//  LLShare.h
//  VideoShare
//
//  Created by tangyx on 13-6-20.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThirdPartyManager.h"
#import "BaseModelWithRIARequestLib.h"

@class LLShareTaskInfo;

@protocol LLShareDelegate <NSObject>
-(void)shareFinished:(BOOL)success;
@end

@interface LLShare : BaseModelWithRIARequestLib<SNSKitResponseDelegate>
@property(nonatomic,weak)id<LLShareDelegate> delegate;
@property(nonatomic,strong)LLShareTaskInfo* shareTaskInfo;
@property(nonatomic,strong)UIImage* shareImage;
@property(nonatomic,assign)BOOL isShareForSiXin;
-(void)share;
@end
