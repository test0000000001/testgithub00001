//
//  NSObject+ABJsonConverter.m
//  ABObjectToJson
//
//  Created by Can on 4/12/12.
//  Copyright (c) 2012 Can Abacigil
//

#import "NSObject+ABJsonConverter.h"
#import <objc/runtime.h>
#import "JSONKit.h"

@implementation NSObject (NSObject_ABJsonConverter)

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {

        if ([[NSString stringWithCString:(const char *)attribute encoding:NSUTF8StringEncoding] isEqualToString:@"Ti"]) {
            return [@"Int" cStringUsingEncoding:NSUTF8StringEncoding];
        }
        else if ([[NSString stringWithCString:(const char *)attribute encoding:NSUTF8StringEncoding] isEqualToString:@"Td"]) {
            return [@"Double" cStringUsingEncoding:NSUTF8StringEncoding];
        }
        else if ([[NSString stringWithCString:(const char *)attribute encoding:NSUTF8StringEncoding] isEqualToString:@"Tf"]) {
            return [@"Float" cStringUsingEncoding:NSUTF8StringEncoding];
        }
        else if ([[NSString stringWithCString:(const char *)attribute encoding:NSUTF8StringEncoding] isEqualToString:@"Tl"]) {
            return [@"Long" cStringUsingEncoding:NSUTF8StringEncoding];
        }
        else if ([[NSString stringWithCString:(const char *)attribute encoding:NSUTF8StringEncoding] isEqualToString:@"Ts"]) {
           return [@"Short" cStringUsingEncoding:NSUTF8StringEncoding];
        }
        else if ([[NSString stringWithCString:(const char *)attribute encoding:NSUTF8StringEncoding] isEqualToString:@"T@"]) {
           return [@"id" cStringUsingEncoding:NSUTF8StringEncoding];
        }
        else if ([[NSString stringWithCString:(const char *)attribute encoding:NSUTF8StringEncoding] isEqualToString:@"T^i"]) {
            return [@"Int" cStringUsingEncoding:NSUTF8StringEncoding];
        }
        else if (attribute[0] == 'T') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

-(NSMutableArray *)outPutArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *selfArray = (NSArray *)self;
    for (int itemIndex = 0; itemIndex < selfArray.count; itemIndex++) {
        id value = [selfArray objectAtIndex:itemIndex];

        unsigned int outCount;
        class_copyPropertyList([value class], &outCount);
        
        if(outCount > 0)
        {
              [array addObject:[value outPutDic]];
        }
        else {
            [array addObject:[selfArray objectAtIndex:itemIndex]];
        }
 
    }

    return array;

}

-(NSMutableDictionary *)outPutDic
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    unsigned int propertyCount, i;
    objc_property_t *propertList = class_copyPropertyList([self class], &propertyCount);
    
    for(i = 0; i < propertyCount; i++) {
        objc_property_t property = propertList[i];
        const char *propName = property_getName(property);
        
        if(propName) {
            const char *propType = getPropertyType(property);
            
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            NSString *propertyType = [NSString stringWithCString:propType encoding:NSUTF8StringEncoding];
            
            if([self valueForKey:propertyName] == nil)
            {
                if([NSClassFromString(propertyType) isSubclassOfClass:NSClassFromString(@"NSString")])
                {
                    [dict setObject:@"" forKey:propertyName];
                }else{
                    [dict setObject:[NSNull null] forKey:propertyName];
                } 
            }
            else {
                if([NSClassFromString(propertyType) isSubclassOfClass:NSClassFromString(@"NSString")])
                {
                    
                    [dict setObject:[self valueForKey:propertyName] forKey:propertyName];
                }
                else if ([NSClassFromString(propertyType) isSubclassOfClass:NSClassFromString(@"NSNumber")]) {
                    [dict setObject:[self valueForKey:propertyName] forKey:propertyName];
                }
                else if ([NSClassFromString(propertyType) isSubclassOfClass:NSClassFromString(@"NSArray")]) {
                    NSArray *value = [self valueForKey:propertyName];
                    NSArray *arrayOfValue = [value outPutArray];
                    [dict setObject:arrayOfValue forKey:propertyName];
                }
                else if ([NSClassFromString(propertyType) isSubclassOfClass:NSClassFromString(@"NSDictionary")]) {
                    NSDictionary *value = [self valueForKey:propertyName];
                    NSDictionary *dictOfValue = [value outPutDic];
                    [dict setObject:dictOfValue forKey:propertyName];
                }
                else if([propertyType isEqualToString:@"Int"])
                {
                    [dict setObject:[NSNumber numberWithInt:[[self valueForKey:propertyName] intValue]] forKey:propertyName];
                }
                else if([propertyType isEqualToString:@"Double"])
                {
                    [dict setObject:[NSNumber numberWithDouble:[[self valueForKey:propertyName] doubleValue]] forKey:propertyName];
                }
                else if([propertyType isEqualToString:@"Float"])
                {
                    [dict setObject:[NSNumber numberWithFloat:[[self valueForKey:propertyName] floatValue]] forKey:propertyName];
                }
                else if([propertyType isEqualToString:@"Long"])
                {
                    [dict setObject:[NSNumber numberWithLong:[[self valueForKey:propertyName] longValue]] forKey:propertyName];
                }
                else if([propertyType isEqualToString:@"Short"])
                {
                    [dict setObject:[NSNumber numberWithShort:[[self valueForKey:propertyName] shortValue]] forKey:propertyName];
                }
                else if([propertyType isEqualToString:@"id"])
                {
                    //can't convert.
                }
                else if([propertyType isEqualToString:@""])
                {
                    //can't convert.
                }
                else {
                    id value = [self valueForKey:propertyName];
                    NSDictionary *dictOfValue = [value outPutDic];
                    [dict setObject:dictOfValue forKey:propertyName];
                }

            }
             
        }
        
    }
    free(propertList);
    
    
    return dict;
}

-(NSString *)outPutJson
{
    return [[self outPutDic] JSONString];
}

+(id)customClassWithProperties:(id)properties {
    id returnObject = nil;
    if ([properties isKindOfClass:[NSDictionary class]]) {
        returnObject = [[[self class] alloc] init];
        [returnObject safeSetValuesForKeysWithDictionary:properties];
    }
    else if ([properties isKindOfClass:[self class]])
    {
        returnObject = properties; //[self customClassWithProperties:[properties outPutDic]];
    }
    return returnObject;
}

-(void)safeSetValuesForKeysWithDictionary:(NSDictionary*)dic
{
    NSMutableDictionary* dicTmp = [[NSMutableDictionary alloc] initWithDictionary: [self outPutDic]];
    for (id key in [dicTmp allKeys]) {
        id value = [dic objectForKey:key];
        if (value) {
            [dicTmp setObject:value forKey:key];
        }
    }
    [self setValuesForKeysWithDictionary:dicTmp];
}

@end
