//
//  NetTaskCheckModel.h
//  VideoShare
//
//  Created by zengchao on 13-1-31.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetTaskCheckModel : NSObject
+(NetTaskCheckModel *)sharedNetTaskCheckModel;
-(void)attemptDealloc;

// 自动执行一边监测
- (void)networkTruenRound;
@end
