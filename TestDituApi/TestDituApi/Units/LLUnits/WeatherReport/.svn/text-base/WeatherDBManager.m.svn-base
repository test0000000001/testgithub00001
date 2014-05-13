//
//  WeatherDBManager.m
//  VideoShare
//
//  Created by wan liming on 6/29/13.
//  Copyright (c) 2013 cmmobi. All rights reserved.
//

#import "WeatherDBManager.h"
#import <sqlite3.h>


//数据库名称
#define DBName "chinaarea.sqlite"

//数据库版本号
#define DBVersion 1

@implementation WeatherDBManager
static WeatherDBManager* dbManager = nil;

//获取实例，单例设计模式
+(WeatherDBManager*)getDBManager
{
    @synchronized(self) {
        if(dbManager == nil){
            dbManager = [[WeatherDBManager alloc] init];
        }
    }
    return dbManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _dbLock = [[NSObject alloc] init];
        
        NSString *descPath = [[NSBundle mainBundle] pathForResource:@"chinaarea" ofType:@"sqlite"];
        _dbPath = descPath;
    }
    return self;
}


//查询得到省份对应的城市码
- (NSArray*)queryCodeByName:(NSString*)name
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSString* selectSql = [NSString stringWithFormat:@"select * from SHARE_AREA_CODE where NAME = \"%@\" AND ZIPCODE is not null group by NAME order by id ASC;",name];
    @synchronized(_dbLock) {
        sqlite3* db;
        sqlite3_stmt* stmt;
        sqlite3_open(_dbPath.UTF8String, &db);
        if(sqlite3_prepare_v2(db, selectSql.UTF8String, -1, &stmt, NULL) == SQLITE_OK){
            while(sqlite3_step(stmt)==SQLITE_ROW){
                [array addObject:[NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 6) encoding:NSUTF8StringEncoding]];
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(db);
    }
    return array;
}
@end
