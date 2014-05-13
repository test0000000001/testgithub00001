//
//  APPLoadModel.h
//  VideoShare
//
//  Created by zengchao on 13-5-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPLoadModel : NSObject
-(void)doLoadWithCompleteBlock:(void (^)(NSString* result))block;
@end
