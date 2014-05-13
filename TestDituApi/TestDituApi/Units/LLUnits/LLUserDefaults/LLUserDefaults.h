//
//  LLUserDefaults.h
//  VideoShare
//
//  Created by tangyx on 13-6-15.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLUserDefaultsKeyDefines.h"
@interface LLUserDefaults : NSObject
+(void)setValue:(id)value forKey:(NSString*)key;
+(id)getValueWithKey:(NSString*)key;
+(NSMutableArray *) getMutArrayWithKey:(NSString *)key;

@end
