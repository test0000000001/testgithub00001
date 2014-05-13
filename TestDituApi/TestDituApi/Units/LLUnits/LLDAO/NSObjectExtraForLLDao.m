//
//  NSObjectExtraForLLDao.m
//  VideoShare
//
//  Created by zengchao on 13-5-23.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "NSObjectExtraForLLDao.h"
#import <objc/runtime.h>

@implementation NSObject(LLGetPropertys)
/*
Printing description of propertys:
{
    name =     (
                Bid,
                StoreName,
                Longitude,
                Latitude,
                testint
                );
    type =     (
                NSString,
                NSString,
                NSString,
                NSString,
                int
                );
}
*/
+(NSDictionary *)getPropertysByColumn
{
    NSMutableArray* pronames = [NSMutableArray array];
    NSMutableArray* protypes = [NSMutableArray array];
    NSDictionary* props = [NSDictionary dictionaryWithObjectsAndKeys:pronames,@"name",protypes,@"type",nil];
    [self getSelfPropertys:pronames protypes:protypes isGetSuper:NO];
    return props;
}

+(NSDictionary *)getPropertysByLine
{
    NSDictionary* dic  = [self getPropertysByColumn];
    NSArray* pronames = [dic objectForKey:@"name"];
    NSArray* protypes = [dic objectForKey:@"type"];
    NSMutableDictionary* propertys = [NSMutableDictionary dictionaryWithObjects:protypes forKeys:pronames];
    return propertys;
}

+ (void)getSelfPropertys:(NSMutableArray *)pronames protypes:(NSMutableArray *)protypes isGetSuper:(BOOL)isGetSuper
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if([propertyName isEqualToString:@"primaryKey"]||[propertyName isEqualToString:@"rowid"])
        {
            continue;
        }
        [pronames addObject:propertyName];
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         c char
         i int
         l long
         s short
         d double
         f float
         @ id //指针 对象
         ...  BOOL 获取到的表示 方式是 char
         .... ^i 表示  int*  一般都不会用到
         */
        
        if ([propertyType hasPrefix:@"T@"]) {
            [protypes addObject:[propertyType substringWithRange:NSMakeRange(3, [propertyType rangeOfString:@","].location-4)]];
        }
        else if ([propertyType hasPrefix:@"Ti"])
        {
            [protypes addObject:@"int"];
        }
        else if ([propertyType hasPrefix:@"Tf"])
        {
            [protypes addObject:@"float"];
        }
        else if([propertyType hasPrefix:@"Td"]) {
            [protypes addObject:@"double"];
        }
        else if([propertyType hasPrefix:@"Tl"])
        {
            [protypes addObject:@"long"];
        }
        else if ([propertyType hasPrefix:@"Tc"]) {
            [protypes addObject:@"char"];
        }
        else if([propertyType hasPrefix:@"Ts"])
        {
            [protypes addObject:@"short"];
        }
        
    }
    free(properties);
    if(isGetSuper && [self superclass] != [NSObject class])
    {
        [[self superclass] getSelfPropertys:pronames protypes:protypes isGetSuper:isGetSuper];
    }
}
@end
