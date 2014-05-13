//
//  LLDaoModelBase.h
//  VideoShare
//
//  Created by zengchao on 13-5-23.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LLDaoModelBase : NSObject
@property(copy,nonatomic)NSString* primaryKey;
@property int rowid;
+(NSArray*)fetchColumeNames;
+(NSMutableArray*)fetchColumeTypes;
@end

