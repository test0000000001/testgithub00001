//
//  WeatherData.m
//  VideoShare
//
//  Created by Shu Peng on 13-6-25.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData

- (void)setResponseModelFromDic:(NSDictionary *)dataDictionary
{
    self.description = [[dataDictionary objectForKey:@"description"] description];
    self.weatherurl = [[dataDictionary objectForKey:@"weatherurl"] description];
    self.date = [[dataDictionary objectForKey:@"date"] description];
}
@end
