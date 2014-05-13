//
//  WeatherReport.h
//  VideoShare
//
//  Created by Shu Peng on 13-6-14.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"
#import "WeatherListData.h"

typedef void (^WeatherSuccessBlock)(NSDictionary* dic);
typedef void (^WeatherFailedBlock)(NSDictionary* dic);
@interface WeatherReport : NSObject

@property (nonatomic, strong)NSString* proviceCode;  //解析地区编码

- (void)getWeatherWithSuccessBlock:(WeatherSuccessBlock)successBlock withFailedBlock:(WeatherFailedBlock)failedBlock;
-(NSDictionary*)getNextWeather; //必须先请求网络
-(NSDictionary*)getTodayWeather;
-(NSDictionary*)getNextNextWeather;

+(NSString*)getCityCodeByGpsPosition:(NSString *)position;
+(NSString*)getCityCodeByCity:(NSString*)cityName;
@end
