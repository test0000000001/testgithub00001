//
//  DiaryShareUrlData.m
//  VideoShare
//
//  Created by tangyx on 13-7-5.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "DiaryShareUrlData.h"

@implementation PlatformURL

@end

@implementation DiaryShareUrlData
@synthesize platformurls,shareimageurl;
-(void)setResponseModelFromDic:(NSDictionary *)dataDictionary{
    [super setResponseModelFromDic:dataDictionary];
    [self safeSetValuesForKeysWithDictionary:dataDictionary];
}
-(NSArray*)platformurls{
    NSMutableArray* array = [NSMutableArray array];
    for(NSDictionary* dic in platformurls){
        PlatformURL* item = [PlatformURL customClassWithProperties:dic];
        [array addObject:item];
    }
    return array;
}
@end
