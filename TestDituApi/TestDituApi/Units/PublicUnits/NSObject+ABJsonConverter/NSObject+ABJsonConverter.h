//
//  NSObject+ABJsonConverter.h
//  ABObjectToJson
//
//  Created by Can on 4/12/12.
//  Copyright (c) 2012 Can Abacigil
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_ABJsonConverter)
{
   
}
-(NSMutableDictionary *)outPutDic;
-(NSString *)outPutJson;
+(id)customClassWithProperties:(id)properties;
-(void)safeSetValuesForKeysWithDictionary:(NSDictionary*)dic;
@end
