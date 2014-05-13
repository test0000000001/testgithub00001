//
//  WeatherListData.m
//  VideoShare
//
//  Created by wan liming on 6/29/13.
//  Copyright (c) 2013 cmmobi. All rights reserved.
//

#import "WeatherListData.h"
#import "WeatherData.h"
@implementation WeatherListData

- (void)setResponseModelFromDic:(NSDictionary *)dataDictionary
{
    [super setResponseModelFromDic:dataDictionary];
    [super safeSetValuesForKeysWithDictionary:dataDictionary];
    NSMutableArray *weatherListArray = [NSMutableArray array];
    
    for (int i = 0; i < [self.weather count]; i++)
    {
        NSDictionary *coverDic = [self.weather objectAtIndex:i];
        WeatherData *weatherDataBase = [[WeatherData alloc] init];
        [weatherDataBase setResponseModelFromDic:coverDic];
        [weatherListArray addObject:weatherDataBase];
    }
    self.weather = weatherListArray;
}
@end
