//
//  WeatherDBManager.h
//  VideoShare
//
//  Created by wan liming on 6/29/13.
//  Copyright (c) 2013 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDBManager : NSObject
{
    NSString *_dbPath;  //数据库文件绝对路径
    NSObject *_dbLock;  //对象锁
}

//获得数据库管理实例
+(WeatherDBManager*)getDBManager;

//通过省份名称，查询得到该省份的城市码
- (NSArray*)queryCodeByName:(NSString*)name;

@end
