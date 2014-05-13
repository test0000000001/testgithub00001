//
//  LLDaoModelBase.m
//  VideoShare
//
//  Created by zengchao on 13-5-23.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelBase.h"
#import "NSObjectExtraForLLDao.h"
#import <objc/runtime.h>
#import "LLDaoBase.h"

@implementation LLDaoModelBase

-(id)init{
    self = [super init];
    if(self){
        self.rowid = -1;
    }
    return self;
}
-(NSString *)description
{
    NSMutableString* sb = [NSMutableString stringWithCapacity:0];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [sb appendFormat:@"\r %@ : %@ ",propertyName,[self valueForKey:propertyName]];
    }
    free(properties);
    return sb;
}

+(NSArray*)fetchColumeNames
{
    NSDictionary* dic  = [self getPropertysByColumn];
    NSArray* pronames = [dic objectForKey:@"name"];
    return pronames;
}

+(NSMutableArray*)fetchColumeTypes
{
    NSDictionary* dic  = [self getPropertysByColumn];
    NSMutableArray* columeTypes = [NSMutableArray arrayWithCapacity:16];
    NSArray* protypes = [dic objectForKey:@"type"];
    for (int i =0; i<protypes.count; i++) {
        [columeTypes addObject:[LLDAOBase toDBType:[protypes objectAtIndex:i]]];
    }
    return columeTypes;
}

-(void)dealloc
{
    self.primaryKey = nil;
}
@end