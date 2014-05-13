//
//  NSStringExtraForLLDao.m
//  VideoShare
//
//  Created by zengchao on 13-5-23.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "NSStringExtraForLLDao.h"

@implementation NSString(LLisEmpty)
-(BOOL)isEmptyWithTrim
{
    return [[self stringWithTrim] isEqualToString:@""];
}
-(NSString *)stringWithTrim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end