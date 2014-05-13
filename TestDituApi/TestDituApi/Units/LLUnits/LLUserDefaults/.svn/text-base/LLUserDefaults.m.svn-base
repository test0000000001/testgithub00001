//
//  LLUserDefaults.m
//  VideoShare
//
//  Created by tangyx on 13-6-15.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLUserDefaults.h"

@implementation LLUserDefaults
+(void)setValue:(id)value forKey:(NSString*)key{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    if ([value isKindOfClass:[NSArray class]])
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
        value = data;
    }
    [userDef setValue:value forKey:[NSString stringWithFormat:@"%@%@",APP_USERID,key]];
    [userDef synchronize];
}
+(id)getValueWithKey:(NSString*)key{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    id value = [userDef valueForKey:[NSString stringWithFormat:@"%@%@",APP_USERID,key]];
    if(value == nil && [value isKindOfClass:[NSString class]]){
        value = @"";
    }
    return value;
}
+(NSMutableArray *) getMutArrayWithKey:(NSString *)key
{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSData *value = [userDef valueForKey:[NSString stringWithFormat:@"%@%@",APP_USERID,key]];
    NSMutableArray *valueArray = [NSKeyedUnarchiver unarchiveObjectWithData:value];
    if (valueArray.count <= 0)
    {
        valueArray = [NSMutableArray array];
    }
    return valueArray;
}
@end
