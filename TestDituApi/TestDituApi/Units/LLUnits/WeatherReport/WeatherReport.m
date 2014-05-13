//
//  WeatherReport.m
//  VideoShare
//
//  Created by Shu Peng on 13-6-14.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "WeatherReport.h"
#import "RIAWebRequestLib.h"
#import "LLGlobalService.h"
#import "WeatherDBManager.h"
#import "WeatherListData.h"
#import "LLUserDefaultsKeyDefines.h"
#import "Tools.h"
#import "LLUserDefaults.h"

// 1. 只缓存当天的天气
// 2. 取不到天气，且定位未开，天气显示一个效果图，点击后提示打开定位。
// 3. 如果取不到天气，并且定位开了，整个天气图标不显示。

@implementation WeatherReport

- (void)getWeatherWithSuccessBlock:(WeatherSuccessBlock)successBlock withFailedBlock:(WeatherFailedBlock)failedBlock
{
    // 获取gps
    [[[LLGlobalService sharedLLGlobalService] locManager] start:^(BOOL isSuccess, double latitude, double longitude, double horizontalAccuracy) {
        if (isSuccess) {
            
            // 获取反查后的城市
            [[LLGlobalService sharedLLGlobalService].locManager geocoding:[[NSString alloc] initWithFormat:@"%f,%f",latitude, longitude] block:^(BOOL isSuccess, NSString *position, NSMutableArray *businessArray){
                
            if (isSuccess)
            {                
                [self setDefaultCity:position];
                NSLog(@"this position is %@",position);
                position = [self splitFromPositon:position];
                
                NSString* code = [self getCityCode:position];

                NSDictionary *param = @{@"userid": APP_USERID, @"addresscode": code};
                self.proviceCode = code;
                RequestModel *weatherRequestModel = [[RequestModel alloc] initWithUrl:REQUEST_WEATHER_URL params:param];
                
                [[RIAWebRequestLib riaWebRequestLib] fetchDataFromNet:weatherRequestModel dataModelClass:[WeatherListData class] mainBlock:^(BaseData *responseModel) {
                    if (responseModel.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS) {
                        WeatherListData *weatherData = (WeatherListData *)responseModel;
                        if (successBlock) {
                            [self storeToUserDeault:weatherData positionCode:self.proviceCode];
                           // NSDictionary* dic = [self getTodayWeather];
                            NSDictionary* dic = [self getCurrentWeather:[self getCurrentDate] positionCode:self.proviceCode];
                            successBlock(dic);
                        }
                    }
                    else{
                        if (responseModel.responseStatusCode == RIA_RESPONSE_CODE_NET_FAILURE)
                        {
                            //[[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"网络不给力!"];
                        }
                        if (failedBlock) {
                            NSString* defaultCity = [self getDefaultCity];
                            defaultCity = [self splitFromPositon:defaultCity];
                            NSString* code = [self getCityCode:defaultCity];
                            self.proviceCode = code;
                            NSDictionary* dic = [self getCurrentWeather:[self getCurrentDate] positionCode:self.proviceCode];
                            failedBlock(dic);
                        }
                    }
                }];
             }
             else
             {
                 NSString* defaultCity = [self getDefaultCity];
                 defaultCity = [self splitFromPositon:defaultCity];
                 NSString* code = [self getCityCode:defaultCity];                 
                 self.proviceCode = code;                 
                 NSDictionary* dic = [self getCurrentWeather:[self getCurrentDate] positionCode:self.proviceCode];
                 failedBlock(dic);
             }       
            }];
        }
        else
        {
            NSString* defaultCity = [self getDefaultCity];
            defaultCity = [self splitFromPositon:defaultCity];
            NSString* code = [self getCityCode:defaultCity];
            self.proviceCode = code;
            NSDictionary* dic = [self getCurrentWeather:[self getCurrentDate] positionCode:self.proviceCode];
            failedBlock(dic);
        }
    }];
}

//根据当前的position得出城市编码
+(NSString*)getCityCodeByGpsPosition:(NSString *)position
{
    WeatherReport* report = [[WeatherReport alloc]init];
    NSString* cityName = [report splitFromPositon:position];
    
    NSString* code = [report getCityCode:cityName];
    report = nil;
    return code;
}




//根据解析的地址分割，只有省显示省， 省市显示市， 省市区显示区
-(NSString*)splitFromPositon:(NSString*)position
{
    NSArray *array = [position componentsSeparatedByString:@"省"];
    NSString* returnString;
    if ([array count]> 1)
    {
       NSString* provString = [array objectAtIndex:1];
       NSArray *array2 = [provString componentsSeparatedByString:@"市"];
       if ([array2 count]> 1)
       {
           returnString = [[array2 objectAtIndex:0] stringByAppendingString:@"市"];
       }
       else
       {
           returnString = provString;
       }
    }
    else
    {
        NSArray *arraypP = [position componentsSeparatedByString:@"市"];
        if ([arraypP count]> 1)
        {
            NSString* provString = [arraypP objectAtIndex:1];
            NSArray *array2 = [provString componentsSeparatedByString:@"市"];
            if ([array2 count]> 1)
            {
                returnString = [[array2 objectAtIndex:0] stringByAppendingString:@"市"];
            }
            else
            {
                returnString = provString;
            }
        }
        else
        {
            returnString = position;
        }
    }
    return returnString;
}



/**
 * 功能：根据 当前的城市名字获取城市码
 * 参数：城市名
 * 返回值：<#返回值#>
 
 * 创建者：kevin wan
 * 创建日期：<#日期#>
 */
-(NSString*)getCityCode:(NSString*)cityName
{
    WeatherDBManager* dbManager = [WeatherDBManager getDBManager];
    NSArray* array = [dbManager queryCodeByName:cityName];
    NSString* code;
    if (array.count > 0)
    {
        code = [array objectAtIndex:0];
    }
    else
    {
        code = @"";
    }
    return code;
}


/*
* 功能：存储从网络获取到的数据到userdefault
* 参数：网络数据和城市code
* 返回值：无

* 创建者：kevin wan
* 创建日期：<#日期#>
*/
-(void)storeToUserDeault:(WeatherListData*)weatherData positionCode:(NSString*)positionCode
{
    if (weatherData.weather.count == 0)
    {
        return;
    }
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for (int i=0; i<weatherData.weather.count; i++)
    {
        WeatherData* data = [weatherData.weather objectAtIndex:i];
        NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                             data.description, @"description",
                             data.weatherurl, @"weatherurl",
                             data.date, @"date",
                             [self getDefaultCity], @"provice",
                             nil];
        
        [array addObject:dic];
    }
    NSArray* writeArray = array;
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:writeArray forKey:WEATHER_INFO(positionCode)];
    [userDef synchronize];
}


/**
 * 功能：获取本地天气
 * 参数：当前的日期，当前城市的code
 * 返回值：无
 
 * 创建者：kevin wan
 * 创建日期：<#日期#>
 */
-(NSDictionary*)getCurrentWeather:(NSString*)date positionCode:(NSString*)positionCode
{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSArray* array = [userDef arrayForKey:WEATHER_INFO(positionCode)];
//    for (int i=0; i<[array count]; i++)
    //只比对当天的天气
    if([array count]>0)
    {
        NSDictionary* dic = [array objectAtIndex:0];
        if ([[[dic valueForKey:@"date"] description] isEqualToString:date])
        {
            return dic;
        }
    }
    return nil;
}


//设置默认城市
-(void)setDefaultCity:(NSString*)provice
{
    [LLUserDefaults setValue:provice forKey:WEATHER_CITY_DEFAULT];
}


//获取默认城市 WEATHER_CITY_DEFAULT
-(NSString*)getDefaultCity
{
    return [LLUserDefaults getValueWithKey:WEATHER_CITY_DEFAULT];
}




/**
 * 功能：根据当前的日期和位置编码获取本地天气
 * 参数：当前的日期，当前城市的code
 * 返回值：无
 
 * 创建者：kevin wan
 * 创建日期：<#日期#>
 */
-(NSDictionary*)getNextNextWeather
{
    if (self.proviceCode == nil)
    {
        return nil;
    }
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSArray* array = [userDef arrayForKey:WEATHER_INFO(self.proviceCode)];
    NSDictionary* dic = nil;
    if (array.count > 2)
    {
        dic = [[NSMutableDictionary alloc]initWithDictionary:[array objectAtIndex:2]];
        [dic setValue:[self getDefaultCity] forKey:@"provice"];
    }
    
    return dic;
}


/**
 * 功能：获取本地天气
 * 参数：当前的日期，当前城市的code
 * 返回值：无
 
 * 创建者：kevin wan
 * 创建日期：<#日期#>
 */
-(NSDictionary*)getTodayWeather
{
    if (self.proviceCode == nil)
    {
        return nil;
    }
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSArray* array = [userDef arrayForKey:WEATHER_INFO(self.proviceCode)];
    NSMutableDictionary* dic = nil;
    if (array.count > 1)
    {
        dic = [[NSMutableDictionary alloc]initWithDictionary:[array objectAtIndex:0]];
        
        [dic setValue:[self getDefaultCity] forKey:@"provice"];
    }
    return dic;
}


/**
 * 功能：获取本地天气
 * 参数：当前的日期，当前城市的code
 * 返回值：无
 
 * 创建者：kevin wan
 * 创建日期：<#日期#>
 */
-(NSDictionary*)getNextWeather
{
    if (self.proviceCode == nil)
    {
        return nil;
    }
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSArray* array = [userDef arrayForKey:WEATHER_INFO(self.proviceCode)];
    NSDictionary* dic = nil;
    if (array.count > 0)
    {
        dic = [[NSMutableDictionary alloc]initWithDictionary:[array objectAtIndex:1]];
        [dic setValue:[self getDefaultCity] forKey:@"provice"];
    }
    
    return dic;
}

//获取当天的日期 2013-08-11
-(NSString*)getCurrentDate
{
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dataString = [formatter stringFromDate:[NSDate date]];
    NSLog(@"Current date is %@",[dataString description]);
    return dataString;
}


/**
 * 功能：根据 当前的城市名字获取城市码
 * 参数：城市名
 * 返回值：<#返回值#>
 
 * 创建者：kevin wan
 * 创建日期：<#日期#>
 */
+(NSString*)getCityCodeByCity:(NSString*)cityName
{
    WeatherDBManager* dbManager = [WeatherDBManager getDBManager];
    NSArray* array = [dbManager queryCodeByName:cityName];
    NSString* code;
    if (array.count > 0)
    {
        code = [array objectAtIndex:0];
    }
    else
    {
        code = @"";
    }
    return code;
}
@end
