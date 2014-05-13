//
//  NetStatusCheckModel.h
//  VideoShare
//
//  Created by zengchao on 13-1-31.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetStatusCheckModel : NSObject
+(NetStatusCheckModel *)sharedNetStatusCheckModel;
-(void)attemptDealloc;
@end
