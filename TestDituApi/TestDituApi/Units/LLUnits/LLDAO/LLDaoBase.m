//
//
//  Created by y h on 12-10-9.
//  Copyright (c) 2012年 SKY. All rights reserved.
//

#import "LLDAOBase.h"
#import "Global.h"

#import "LLDaoModelVideo.h"
#import "LLDaoModelSound.h"
#import "LLDaoModelImageCatch.h"
#import "LLDaoModelFrontCover.h"
#import "LLDaoModelShootImage.h"
#import "LLDaoModelUser.h"
#import "LLDaoModelDiary.h"
#import "LLDaoModelRecommand.h"
#import "LLDaoModelShareDiary.h"
#import "LLDaoModelFriends.h"
#import "LLDaoModelPrivateMessage.h"
#import "LocalResourceModel.h"
#import "NSObject+ABJsonConverter.h"
#include <objc/runtime.h>
#import "JSONKit.h"
#import "LLDaoModelFollowList.h"
#import "LLDaoModelFansList.h"
#import "LLDaoModelContacts.h"
#import "LLDaoModelTask.h"
#import "LLDaoModelSinaFriends.h"
#import "LLDaoModelTencentFriends.h"
#import "LLDaoModelRenRenFriends.h"
#import "LLDaoModelFreeTask.h"
#import "LLDaoModelActivityList.h"
#import "MessageUserListModelBase.h"
#import "LLDaoModelPrivateMessage.h"
#import "DiaryCommentDataBase.h"
#import "DiaryPraiseModelBase.h"
#import "LLDaoModelActivtyJoinedVideo.h"
#import "LLDaoModelActivtyWinner.h"
#import "LLDaoModelFriendDiaryIds.h"

@interface LLDAOBase()
{
    
}
@end

@implementation LLDAOBase
@synthesize bindingQueue;
static id ShardInstance;
+(LLDAOBase *)shardLLDAOBase
{
    @synchronized (self) {
        if(ShardInstance == nil){
            NSString* dbPath = [LocalResourceModel getLlDataBaseFile];
            if(dbPath.length == 0){
                return nil;
            }
            ShardInstance=[[self alloc]init];
            [ShardInstance create:dbPath];
        }
    }
    return ShardInstance;
}

-(void)create:(NSString*)dbPath
{
    [self CreateDataBase:dbPath];
    [self createTable:[[LLDaoModelVideo alloc]init]];
    [self createTable:[[LLDaoModelSound alloc]init]];
    [self createTable:[[LLDaoModelImageCatch alloc]init]];
    [self createTable:[[LLDaoModelFrontCover alloc]init]];
    [self createTable:[[LLDaoModelShootImage alloc]init]];
    [self createTable:[[LLDaoModelUser alloc]init]];
    [self createTable:[[LLDaoModelDiary alloc]init]];
    [self createTable:[[LLDaoModelRecommand alloc]init]];
    [self createTable:[[LLDaoModelShareDiary alloc]init]];      //分享日记列表
    [self createTable:[[LLDaoModelFriends alloc]init]];
    [self createTable:[[LLDaoModelFollowList alloc]init]];      //关注列表数据库
    [self createTable:[[LLDaoModelFansList alloc]init]];        //粉丝列表数据库
    [self createTable:[[LLDaoModelSinaFriends alloc]init]];     //新浪微博好友数据库
    [self createTable:[[LLDaoModelTencentFriends alloc]init]];  //腾讯微博好友数据库
    [self createTable:[[LLDaoModelRenRenFriends alloc] init]];  //人人网好友数据库
    [self createTable:[[LLDaoModelTask alloc]init]];
    [self createTable:[[LLDaoModelContacts alloc]init]];
    [self createTable:[[LLDaoModelFreeTask alloc]init]];
    [self createTable:[[LLDaoModelActivityList alloc]init]];        //活动列表数据库生成
    [self createTable:[[DiaryCommentDataBase alloc]init]];
    [self createTable:[[DiaryPraiseModelBase alloc]init]];
    [self createTable:[[MessageUserListModelBase alloc]init]];
    [self createTable:[[LLDaoModelPrivateMessage alloc]init]];
    [self createTable:[[LLDaoModelActivtyJoinedVideo alloc]init]];  //参加活动日记列表
    [self createTable:[[LLDaoModelActivtyWinner alloc]init]];       //获奖日记列表
    [self createTable:[[LLDaoModelFriendDiaryIds alloc] init]]; //存放朋友圈日记id
}

-(void)CreateDataBase:(NSString*)dbPath
{
    self.bindingQueue=[[FMDatabaseQueue alloc]initWithPath:dbPath];
}
-(void)setTableChangedBroadCast:(Class)class changedMessage:(NSString*)message userInfo:(NSDictionary*)userInfo{
    [[NSNotificationCenter defaultCenter]postNotificationName:NSStringFromClass(class) object:message userInfo:userInfo];
}

-(void)addTableChangedBroadCast:(Class)tableClass observer:(id)observer selector:(SEL)selector{
    [[NSNotificationCenter defaultCenter]addObserver:observer selector:selector name:NSStringFromClass(tableClass) object:nil];
}
-(void)removeObserver:(id)observer name:(Class)tableClass{
    [[NSNotificationCenter defaultCenter]removeObserver:observer name:NSStringFromClass(tableClass) object:nil];
}
-(void)dealloc
{
    self.bindingQueue = nil;
}

-(void)createTable:(LLDaoModelBase*)llDaoModelBase
{
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSString* tableName = NSStringFromClass([llDaoModelBase class]);
         if(![db tableExists:tableName]){
             NSString* createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",tableName,[self getParameterString:llDaoModelBase]];
             [db executeUpdate:createTable];
         }else{
             NSArray* columeNames = [llDaoModelBase.class fetchColumeNames];
             NSMutableArray* columeTypes = [llDaoModelBase.class fetchColumeTypes];
             NSArray* tableColumns = [db columnsInTableWithName:tableName];
             NSMutableArray* insertArray = [NSMutableArray array];
             NSMutableArray* deleteArray = [NSMutableArray array];
             for(NSString* name in columeNames){
                 if(![tableColumns containsObject:name]){
                     [insertArray addObject:name];
                 }
             }
             for (NSString* name in tableColumns) {
                 if(![columeNames containsObject:name]){
                     [deleteArray addObject:name];
                 }
             }
             if([deleteArray count] == 0){//如果不存在需要删除的字段，则进行增加字段操作
                 for(NSString* insertName in insertArray){
                     int columeTypeIndex = [columeNames indexOfObject:insertName];
                     if (columeTypeIndex >=0 && columeTypeIndex < [columeTypes count]) {
                         ;
                         [db insertColumn:insertName type:[columeTypes objectAtIndex:columeTypeIndex] toTableWithName:tableName];
                     }
                     
                 }
             }else{//需要删除旧字段
                 NSString* tempTable = [NSString stringWithFormat:@"%@_tempTable",tableName];
                 NSString* rename_sql =[NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@",tableName,tempTable];
                 [db executeUpdate:rename_sql];//原来的表改名为临时表
                 NSString* createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",tableName,[self getParameterString:llDaoModelBase]];
                 [db executeUpdate:createTable];//创建新表
                 [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ SELECT * FROM %@",tableName,tempTable]];//临时表数据复制到新表
                 [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@",tempTable]];//删除临时表
             }
         }
     }];
}
-(void)getTotalRowsIn:(Class)modelClass callBack:(void(^)(long))block{
    __block long result = 0;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select count(*) from %@ ",NSStringFromClass(modelClass)];
         FMResultSet* set =[db executeQuery:query];
         [set next];
         result =  [set intForColumnIndex:0];
         [set close];
     }];
    if(block != nil){
        block(result);
    }
}
-(void)getTotalRowsIn:(Class)modelClass dic:(NSDictionary*)where callBack:(void(^)(long))block{
    __block long result = 0;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select count(*) from %@ ",NSStringFromClass(modelClass)];
         NSMutableArray* values = [NSMutableArray arrayWithCapacity:0];
         if(where !=nil&& where.count>0)
         {
             NSString* wherekey = [self dictionaryToSqlWhere:where andValues:values];
             [query appendFormat:@" where %@",wherekey];
         }
         FMResultSet* set =[db executeQuery:query withArgumentsInArray:values];
         [set next];
         result =  [set intForColumnIndex:0];
         [set close];
         
     }];
    if(block != nil){
        block(result);
    }

}
-(void)getTotalRowsIn:(Class)modelClass where:(NSString*)where callBack:(void(^)(long))block{
    __block long result = 0;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select count(*) from %@ ",NSStringFromClass(modelClass)];
         if(where !=nil && where.length>0)
         {
             [query appendFormat:@" where %@",where];
         }
         FMResultSet* set =[db executeQuery:query];
         [set next];
         result =  [set intForColumnIndex:0];
         [set close];
         
     }];
    if(block != nil){
        block(result);
    }
    
}
-(NSString *)getParameterString:(LLDaoModelBase*)llDaoModelBase
{
    NSArray* columeNames = [llDaoModelBase.class fetchColumeNames];
    NSMutableArray* columeTypes = [llDaoModelBase.class fetchColumeTypes];
    NSMutableString* pars = [NSMutableString string];
    for (int i=0; i<columeNames.count; i++) {
        [pars appendFormat:@"%@ %@",[columeNames objectAtIndex:i],[columeTypes objectAtIndex:i]];
        //设置主键
        if (!STR_IS_NIL(llDaoModelBase.primaryKey) && [llDaoModelBase.primaryKey isEqualToString:[columeNames objectAtIndex:i]]) {
            [pars appendFormat:@" %@",@"PRIMARY KEY"];
        }
        if(i+1 !=columeNames.count)
        {
            [pars appendString:@","];
        }
    }
    return pars;
}
-(void)searchAll:(LLDaoModelBase*)llDaoModelBase callback:(void(^)(NSArray*))callback{
    __block NSArray* resultArray = nil;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select rowid,* from %@ ",NSStringFromClass(llDaoModelBase.class)];
         FMResultSet* set =[db executeQuery:query];
         [self executeResult:llDaoModelBase set:set block:^(NSArray* array){
             resultArray = array;
         }];;
     }];
    if(callback != nil){
        callback(resultArray);
    }
}
-(void)searchAll:(LLDaoModelBase*)llDaoModelBase where:(NSString*)where callback:(void(^)(NSArray*))callback{
    __block NSArray* resultArray = nil;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select * from %@ ",NSStringFromClass(llDaoModelBase.class)];
         NSMutableArray* values = [NSMutableArray arrayWithCapacity:0];
         if(where !=nil && where.length > 0)
         {
             [query appendFormat:@" where %@",where];
         }
         FMResultSet* set =[db executeQuery:query withArgumentsInArray:values];
         [self executeResult:llDaoModelBase set:set block:^(NSArray* array){
             resultArray = array;
         }];
     }];
    if(callback!= nil){
        callback(resultArray);
    }
}
-(void)searchAll:(LLDaoModelBase*)llDaoModelBase dic:(NSDictionary*)where callback:(void(^)(NSArray*))callback{
    __block NSArray* resultArray = nil;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select * from %@ ",NSStringFromClass(llDaoModelBase.class)];
         NSMutableArray* values = [NSMutableArray arrayWithCapacity:0];
         if(where !=nil&& where.count>0)
         {
             NSString* wherekey = [self dictionaryToSqlWhere:where andValues:values];
             [query appendFormat:@" where %@",wherekey];
         }
         FMResultSet* set =[db executeQuery:query withArgumentsInArray:values];
         [self executeResult:llDaoModelBase set:set block:^(NSArray* array){
             resultArray = array;
         }];
     }];
    if(callback!= nil){
        callback(resultArray);
    }
}
-(void)searchAllWithArray:(LLDaoModelBase *)llDaoModelBase withColumnName:(NSString *)columnName where:(NSArray *)where callback:(void(^)(NSArray*))callback{
    __block NSArray* resultArray = nil;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select * from %@ ",NSStringFromClass(llDaoModelBase.class)];
         if(where !=nil&& where.count>0 && columnName.length > 0)
         {
             NSMutableString* whereStr = [NSMutableString string];
             for(NSString* string in where){
                 if(whereStr.length > 0){
                     [whereStr appendString:@","];
                 }
                 [whereStr appendFormat:@"'%@'",string];
             }
             [query appendFormat:@"where %@ in (%@)",columnName,whereStr];
         }
         FMResultSet* set =[db executeQuery:query];
         [self executeResult:llDaoModelBase set:set block:^(NSArray* array){
             resultArray = array;
         }];
     }];
    if(callback!= nil){
        callback(resultArray);
    }
}
-(void)searchWhere:(LLDaoModelBase*)llDaoModelBase where:(NSString*)where callback:(void(^)(NSArray*))block{
    [self searchWhere:llDaoModelBase String:where orderBy:nil offset:0 count:15 callback:block];
}
-(void)searchWhere:(LLDaoModelBase*)llDaoModelBase String:(NSString *)where orderBy:(NSString *)orderBy offset:(int)offset count:(int)count callback:(void (^)(NSArray *))block
{
    [self searchWhere:llDaoModelBase String:where orderBy:orderBy asc:YES offset:offset count:count callback:block];
}

-(void)searchWhere:(LLDaoModelBase*)llDaoModelBase String:(NSString *)where orderBy:(NSString *)orderBy asc:(BOOL)asc offset:(int)offset count:(int)count callback:(void (^)(NSArray *))block{
    __block NSArray* resultArray = nil;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select rowid,* from %@ ",NSStringFromClass(llDaoModelBase.class)];
         if(where != nil && ![where isEmptyWithTrim])
         {
             [query appendFormat:@" where %@",where];
         }
         [self sqlString:query AddOder:orderBy asc:asc offset:offset count:count];
         FMResultSet* set =[db executeQuery:query];
         [self executeResult:llDaoModelBase set:set block:^(NSArray* array){
             resultArray = array;
         }];
     }];
    if(block != nil){
        block(resultArray);
    }
}
-(void)searchWhereDic:(LLDaoModelBase*)llDaoModelBase Dic:(NSDictionary*)where callback:(void(^)(NSArray*))block{
    [self searchWhereDic:llDaoModelBase Dic:where orderBy:nil offset:0 count:15 callback:block];
}
-(void)searchWhereDic:(LLDaoModelBase*)llDaoModelBase Dic:(NSDictionary*)where orderBy:(NSString *)orderby offset:(int)offset count:(int)count callback:(void (^)(NSArray *))block
{
    [self searchWhereDic:llDaoModelBase Dic:where orderBy:orderby asc:YES offset:offset count:count callback:block];
}
-(void)searchWhereDic:(LLDaoModelBase*)llDaoModelBase Dic:(NSDictionary*)where orderBy:(NSString *)orderby asc:(BOOL)asc offset:(int)offset count:(int)count callback:(void (^)(NSArray *))block{
    __block NSArray* resultArray = nil;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSMutableString* query = [NSMutableString stringWithFormat:@"select rowid,* from %@ ",NSStringFromClass(llDaoModelBase.class)];
         
         NSMutableArray* values = [NSMutableArray arrayWithCapacity:0];
         if(where !=nil&& where.count>0)
         {
             NSString* wherekey = [self dictionaryToSqlWhere:where andValues:values];
             [query appendFormat:@" where %@",wherekey];
         }
         [self sqlString:query AddOder:orderby asc:asc offset:offset count:count];
         FMResultSet* set =[db executeQuery:query withArgumentsInArray:values];
         [self executeResult:llDaoModelBase set:set block:^(NSArray* array){
             resultArray = array;
         }];
     }];
    if(block != nil){
        block(resultArray);
    }

}
-(void)sqlString:(NSMutableString*)sql AddOder:(NSString*)orderby offset:(int)offset count:(int)count
{
    [self sqlString:sql AddOder:orderby asc:YES offset:offset count:count];
}
-(void)sqlString:(NSMutableString*)sql AddOder:(NSString*)orderby asc:(BOOL)asc offset:(int)offset count:(int)count{
    if(orderby != nil && ![orderby isEmptyWithTrim])
    {
        [sql appendFormat:@" order by %@ %@ ",orderby,asc?@"asc":@"desc"];
    }
    if(count != -1){
        [sql appendFormat:@" limit %d offset %d ",count,offset];
    }
    
}
- (void)executeResult:(LLDaoModelBase*)llDaoModelBase set:(FMResultSet *)set block:(void (^)(NSArray *))block
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    
    NSArray* columeNames = [llDaoModelBase.class fetchColumeNames];
    NSDictionary* propertys = [llDaoModelBase.class getPropertysByLine];
    
    while ([set next]) {
        LLDaoModelBase* bindingModel = [[llDaoModelBase.class alloc]init];
        bindingModel.rowid = [set intForColumnIndex:0];
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithCapacity:10];
        for (int i=0; i<columeNames.count; i++) {
            NSString* columeName = [columeNames objectAtIndex:i];
            NSString* columeType = [propertys objectForKey:columeName];
            if([@"intfloatdoublelongcharshort" rangeOfString:columeType].location != NSNotFound)
            {
                [dic setValue:[NSNumber numberWithDouble:[set doubleForColumn:columeName]] forKey:columeName];
            }
            else if([columeType isEqualToString:@"NSString"])
            {
                [dic setValue:[set stringForColumn:columeName] forKey:columeName];
            }
            else if([columeType isEqualToString:@"UIImage"])
            {
                NSString* filename = [set stringForColumn:columeName];
                if([SandboxFile IsFileExists:[SandboxFile GetPathForDocuments:filename inDir:@"dbImages"]])
                {
                    UIImage* img = [UIImage imageWithContentsOfFile:[SandboxFile GetPathForDocuments:filename inDir:@"dbImages"]];
                    [dic setValue:img forKey:columeName];
                }
            }
            else if([columeType isEqualToString:@"NSDate"])
            {
                NSString* datestr = [set stringForColumn:columeName];
                [dic setValue:[LLDAOBase dateWithString:datestr] forKey:columeName];
            }
            else if([columeType isEqualToString:@"NSData"])
            {
                NSString* filename = [set stringForColumn:columeName];
                if([SandboxFile IsFileExists:[SandboxFile GetPathForDocuments:filename inDir:@"dbData"]])
                {
                    NSData* data = [NSData dataWithContentsOfFile:[SandboxFile GetPathForDocuments:filename inDir:@"dbData"]];
                    [dic setValue:data forKey:columeName];
                }
            }
            else
            {
                NSString* string = [set stringForColumn:columeName];
                id obj = [string mutableObjectFromJSONString];
                if (obj) {
                    [dic setValue:obj forKey:columeName];
                }
            }
        }
        [bindingModel safeSetValuesForKeysWithDictionary:dic];
        bindingModel = [bindingModel.class customClassWithProperties:bindingModel];
        [array addObject:bindingModel];
    }
    [set close];
    if(block != nil){
        block(array);
    }
}
-(void)insert:(LLDaoModelBase *)model toDB:(FMDatabase*)db  callback:(void (^)(BOOL))block{
    NSArray* columeNames = [model.class fetchColumeNames];
    NSDate* date = [NSDate date];
    NSMutableString* insertKey = [NSMutableString stringWithCapacity:0];
    NSMutableString* insertValuesString = [NSMutableString stringWithCapacity:0];
    NSMutableArray* insertValues = [NSMutableArray arrayWithCapacity:columeNames.count];
    NSDictionary* dic = [model outPutDic];
    for (int i=0; i<columeNames.count; i++) {        
        NSString* proname = [columeNames objectAtIndex:i];
        [insertKey appendFormat:@"%@,", proname];
        [insertValuesString appendString:@"?,"];
        //id value =[self safetyGetModel:model valueKey:proname];
        id value = [dic objectForKey:proname];
        if ([value isKindOfClass:[NSNull class]] || value == nil)
        {
            value = @"";
        }
        else if([value isKindOfClass:[UIImage class]])
        {
            NSString* filename = [NSString stringWithFormat:@"img%f",[date timeIntervalSince1970]];
            [UIImageJPEGRepresentation(value, 1) writeToFile:[SandboxFile GetPathForDocuments:filename inDir:@"dbImages"] atomically:YES];
            value = filename;
        }
        else if([value isKindOfClass:[NSData class]])
        {
            NSString* filename = [NSString stringWithFormat:@"data%f",[date timeIntervalSince1970]];
            [value writeToFile:[SandboxFile GetPathForDocuments:filename inDir:@"dbdata"] atomically:YES];
            value = filename;
        }
        else if([value isKindOfClass:[NSDate class]])
        {
            value = [LLDAOBase stringWithDate:value];
        }
        else if ([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSDictionary class]])
        {
            value = [value JSONString];
        }
        else if(![value isKindOfClass:[NSNumber class]] && ![value isKindOfClass:[NSString class]])
        {
            value = [value outPutJson];
        }
        if (!value) {
            value = @"";
        }
        [insertValues addObject:value];
    }
    [insertKey deleteCharactersInRange:NSMakeRange(insertKey.length - 1, 1)];
    [insertValuesString deleteCharactersInRange:NSMakeRange(insertValuesString.length - 1, 1)];
    NSString* insertSQL = [NSString stringWithFormat:@"insert into %@(%@) values(%@)",NSStringFromClass(model.class),insertKey,insertValuesString];
    BOOL result = [db executeUpdate:insertSQL withArgumentsInArray:insertValues];
    model.rowid = db.lastInsertRowId;
    if(block != nil){
        block(result);
    }
}
-(void)insertToDB:(LLDaoModelBase*)model callback:(void (^)(BOOL))block{
    if(model == nil && block != nil){
        block(NO);
        return;
    }
    __block BOOL result = NO;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         [self insert:model toDB:db callback:^(BOOL b){
             result = b;
         }];
    }];
    if(block != nil)
    {
        block(result);
    }
    if(result == NO)
    {
        NSLog(@"database insert fail %@",NSStringFromClass(model.class));
    }else{
        [self setTableChangedBroadCast:model.class changedMessage:LLDAOBASE_OperationType_Insert userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:model],LLDAOBASE_BroadCast_KEY_Array,nil]];
    }
}
-(void)updateInsertToDB:(LLDaoModelBase *)model callback:(void (^)(BOOL))block{
    if(model == nil && block != nil){
        block(NO);
        return;
    }
    __block BOOL isExsit = NO;
    [self isExistsModel:model callback:^(BOOL exsit){
        isExsit = exsit;
    }];
    if(isExsit){
        [self updateToDB:model callback:block];
    }else{
        [self insertToDB:model callback:block];
    }
}
-(void)insertToDBFromArray:(NSArray *)models callback:(void (^)(BOOL))block{
    if([models count] == 0){
        if(block != nil){
            block(NO);
        }
        return;
    }
    __block BOOL result = NO;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         [db beginTransaction];
         for(id object in models){
             result = YES;
             if(![object isKindOfClass:[LLDaoModelBase class]]){
                 result = NO;
                 break;
             }
             [self insert:object toDB:db callback:^(BOOL b){
                 if(!b){
                     result = NO;
                 }
             }];
             if(!result){
                 break;
             }
         }
         if(result){
             [db commit];
         }else{
             [db rollback];
         }
     }];
    if(block != nil){
        block(result);
    }
    if(result){
        [self setTableChangedBroadCast:((LLDaoModelBase*)[models objectAtIndex:0]).class changedMessage:LLDAOBASE_OperationType_InsertArray userInfo:[NSDictionary dictionaryWithObjectsAndKeys:models,LLDAOBASE_BroadCast_KEY_Array, nil]];
    }
}
-(void)updateToDBFromArray:(NSArray *)models callback:(void (^)(BOOL))block{
    if([models count] == 0){
        if(block != nil){
            block(NO);
        }
        return;
    }
    __block BOOL result = NO;
    [bindingQueue inDatabase:^(FMDatabase* db){
        [db beginTransaction];
        for(id object in models){
            result = YES;
            if(![object isKindOfClass:[LLDaoModelBase class]]){
                result = NO;
                break;
            }
            [self update:object toDB:db callback:^(BOOL b){
                if(!b){
                    result = NO;
                }
            }];
            if(!result){
                break;
            }
        }
        if(result){
            [db commit];
        }else{
            [db rollback];
        }

    }];
    if(block != nil){
        block(result);
    }
    if(result){
        [self setTableChangedBroadCast:((LLDaoModelBase*)[models objectAtIndex:0]).class changedMessage:LLDAOBASE_OperationType_UpdateArray userInfo:[NSDictionary dictionaryWithObjectsAndKeys:models,LLDAOBASE_BroadCast_KEY_Array, nil]];
    }
}
-(void)updateToDB:(Class)modelClass dic:(NSDictionary *)columnValues where:(NSString*)where callback:(void (^)(BOOL))block{
    __block BOOL returnResult = NO;
    [bindingQueue inDatabase:^(FMDatabase* db){
        NSMutableString* whereStr = [NSMutableString string];
        if(where.length > 0){
            [whereStr appendFormat:@" where %@ ",where];
        }
        NSString* rowCountSql = [NSString stringWithFormat:@"select count(rowid) from %@ %@",NSStringFromClass(modelClass),whereStr];
        FMResultSet* resultSet = [db executeQuery:rowCountSql];
        [resultSet next];
        int result =  [resultSet intForColumnIndex:0];
        [resultSet close];
        BOOL exists = (result != 0);
        if(exists){
            NSMutableString* updateKey = [[NSMutableString alloc]init];
            //            NSMutableArray* values = [NSMutableArray array];
            for(NSString* key in [columnValues allKeys]){
                if(updateKey.length == 0){
                    [updateKey appendString:@" "];
                }else{
                    [updateKey appendString:@", "];
                }
                [updateKey appendFormat:@"%@=\'%@\'", key,[self getValueForm:columnValues with:key]];
            }
            NSString* updateSQL = [NSString stringWithFormat:@"update %@ set %@ %@",NSStringFromClass(modelClass),updateKey,whereStr];
            returnResult = [db executeUpdate:updateSQL];
        }else{
            
        }
    }];
    if(block != nil){
        block(returnResult);
    }
    if(returnResult){
        __block NSArray* infoArray = [NSArray array];
        [self searchAll:[[modelClass alloc]init] where:where callback:^(NSArray* array){
            if(array){
                infoArray = array;
            }
        }];
        [self setTableChangedBroadCast:modelClass changedMessage:LLDAOBASE_OperationType_UpdateArray userInfo:[NSDictionary dictionaryWithObjectsAndKeys:infoArray,LLDAOBASE_BroadCast_KEY_Array,nil]];
    }

}
-(void)updateToDB:(Class)modelClass dic:(NSDictionary*)columnValues dic:(NSDictionary*)where callback:(void(^)(BOOL))block{
    __block BOOL returnResult = NO;
    [bindingQueue inDatabase:^(FMDatabase* db){
        NSMutableString* whereStr = [NSMutableString stringWithString:@""];
        for(NSString* key in [where allKeys]){
            if(whereStr.length == 0){
                [whereStr appendFormat:@"where %@=\'%@\'",key,[self getValueForm:where with:key]];
            }else{
                [whereStr appendFormat:@" and %@=\'%@\'",key,[self getValueForm:where with:key]];
            }
        }
        NSString* rowCountSql = [NSString stringWithFormat:@"select count(rowid) from %@ %@",NSStringFromClass(modelClass),whereStr];
        FMResultSet* resultSet = [db executeQuery:rowCountSql];
        [resultSet next];
        int result =  [resultSet intForColumnIndex:0];
        [resultSet close];
        BOOL exists = (result != 0);
        if(exists){
            NSMutableString* updateKey = [[NSMutableString alloc]init];
//            NSMutableArray* values = [NSMutableArray array];
            for(NSString* key in [columnValues allKeys]){
                if(updateKey.length == 0){
                    [updateKey appendString:@" "];
                }else{
                    [updateKey appendString:@", "];
                }
                [updateKey appendFormat:@"%@=\'%@\'", key,[self getValueForm:columnValues with:key]];
            }
            NSString* updateSQL = [NSString stringWithFormat:@"update %@ set %@ %@",NSStringFromClass(modelClass),updateKey,whereStr];
            returnResult = [db executeUpdate:updateSQL];
        }
    }];
    if(block != nil){
        block(returnResult);
    }
    if(returnResult){
        __block NSArray* infoArray = [NSArray array];
        [self searchAll:[[modelClass alloc]init] dic:where callback:^(NSArray* array){
            if(array){
                infoArray = array;
            }
        }];
        [self setTableChangedBroadCast:modelClass changedMessage:LLDAOBASE_OperationType_UpdateArray userInfo:[NSDictionary dictionaryWithObjectsAndKeys:infoArray,LLDAOBASE_BroadCast_KEY_Array,nil]];
    }
}
-(void)updateInsertToDBFromArray:(NSArray *)models callback:(void (^)(BOOL))block{
    if([models count] == 0){
        if(block != nil){
            block(NO);
        }
        return;
    }
    __block BOOL result = NO;
    [bindingQueue inDatabase:^(FMDatabase* db){
        [db beginTransaction];
        for(id object in models){
            result = YES;
            if(![object isKindOfClass:[LLDaoModelBase class]]){
                result = NO;
                break;
            }
            LLDaoModelBase* base = (LLDaoModelBase*)object;
            NSString* rowCountSql;
            if(base.primaryKey.length > 0){
                rowCountSql = [NSString stringWithFormat:@"select count(*) from %@ where %@",NSStringFromClass(base.class),[NSString stringWithFormat:@"%@ = \'%@\'",base.primaryKey,[self safetyGetModel:base valueKey:base.primaryKey]]];
            }else{
                rowCountSql = [NSString stringWithFormat:@"select count(rowid) from %@ where '1' = '2' ",NSStringFromClass(base.class)];
            }
            
            FMResultSet* resultSet = [db executeQuery:rowCountSql];
            [resultSet next];
            int num =  [resultSet intForColumnIndex:0];
            [resultSet close];
            if(num != 0){
                [self update:object toDB:db callback:^(BOOL b){
                    if(!b){
                        result = NO;
                    }
                }];
            }else{
                [self insert:object toDB:db callback:^(BOOL b){
                    if(!b){
                        result = NO;
                    }
                }];
            }
            
            if(!result){
                break;
            }
        }
        if(result){
            [db commit];
        }else{
            [db rollback];
        }
    }];
    if(block != nil){
        block(result);
    }
    if(result){
        [self setTableChangedBroadCast:((LLDaoModelBase*)[models objectAtIndex:0]).class changedMessage:LLDAOBASE_OperationType_UpdateInsertArray userInfo:[NSDictionary dictionaryWithObjectsAndKeys:models,LLDAOBASE_BroadCast_KEY_Array, nil]];
    }
}
-(void)deleteToDBFromArray:(NSArray *)models callback:(void(^)(BOOL))block{
    if([models count] == 0){
        if(block != nil){
            block(NO);
        }
        return;
    }
    __block BOOL result = NO;
    [bindingQueue inDatabase:^(FMDatabase* db){
        [db beginTransaction];
        for(id object in models){
            result = YES;
            if(![object isKindOfClass:[LLDaoModelBase class]]){
                result = NO;
            }
            [self delete:object toDB:db callback:^(BOOL b){
                if(!b){
                    result = NO;
                }
            }];
            if(!result){
                break;
            }
        }
        if(result){
            [db commit];
        }else{
            [db rollback];
        }
    }];
    if(block != nil){
        block(result);
    }
    if(result){
        [self setTableChangedBroadCast:((LLDaoModelBase*)[models objectAtIndex:0]).class changedMessage:LLDAOBASE_OperationType_DeleteArray userInfo:[NSDictionary dictionaryWithObjectsAndKeys:models,LLDAOBASE_BroadCast_KEY_Array, nil]];
    }
}
-(id)getValueForm:(NSDictionary*)dic with:(NSString*)key{
    NSDate* date = [NSDate date];
    
    //id value =[self safetyGetModel:model valueKey:proname];
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSNull class]] || value == nil)
    {
        value = @"";
    }
    else if([value isKindOfClass:[UIImage class]])
    {
        NSString* filename = [NSString stringWithFormat:@"img%f",[date timeIntervalSince1970]];
        [UIImageJPEGRepresentation(value, 1) writeToFile:[SandboxFile GetPathForDocuments:filename inDir:@"dbImages"] atomically:YES];
        value = filename;
    }
    else if([value isKindOfClass:[NSData class]])
    {
        NSString* filename = [NSString stringWithFormat:@"data%f",[date timeIntervalSince1970]];
        [value writeToFile:[SandboxFile GetPathForDocuments:filename inDir:@"dbdata"] atomically:YES];
        value = filename;
    }
    else if([value isKindOfClass:[NSDate class]])
    {
        value = [LLDAOBase stringWithDate:value];
    }
    else if ([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSDictionary class]])
    {
        value=[[dic objectForKey:key]JSONString];
        //value = [value JSONString];
    }
    else if(![value isKindOfClass:[NSNumber class]] && ![value isKindOfClass:[NSString class]])
    {
        value = [value outPutJson];
    }
    if (!value) {
        value = @"";
    }
    return value;
}
-(void)update:(LLDaoModelBase*)model toDB:(FMDatabase*)db callback:(void (^)(BOOL))block{
    NSArray* columeNames = [model.class fetchColumeNames];
    
    NSDate* date = [NSDate date];
    NSMutableString* updateKey = [NSMutableString stringWithCapacity:0];
    NSMutableArray* updateValues = [NSMutableArray arrayWithCapacity:columeNames.count];
    NSDictionary* dic = [model outPutDic];
    for (int i=0; i<columeNames.count; i++) {
        
        NSString* proname = [columeNames objectAtIndex:i];
        [updateKey appendFormat:@" %@=?,", proname];
        
        //id value =[self safetyGetModel:model valueKey:proname];
        id value = [dic objectForKey:proname];
        if ([value isKindOfClass:[NSNull class]] || value == nil)
        {
            value = @"";
        }
        else if([value isKindOfClass:[UIImage class]])
        {
            NSString* filename = [NSString stringWithFormat:@"img%f",[date timeIntervalSince1970]];
            [UIImageJPEGRepresentation(value, 1) writeToFile:[SandboxFile GetPathForDocuments:filename inDir:@"dbImages"] atomically:YES];
            value = filename;
        }
        else if([value isKindOfClass:[NSData class]])
        {
            NSString* filename = [NSString stringWithFormat:@"data%f",[date timeIntervalSince1970]];
            [value writeToFile:[SandboxFile GetPathForDocuments:filename inDir:@"dbdata"] atomically:YES];
            value = filename;
        }
        else if([value isKindOfClass:[NSDate class]])
        {
            value = [LLDAOBase stringWithDate:value];
        }
        else if ([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSDictionary class]])
        {
            value=[[dic objectForKey:proname]JSONString];
            //value = [value JSONString];
        }
        else if(![value isKindOfClass:[NSNumber class]] && ![value isKindOfClass:[NSString class]])
        {
            value = [value outPutJson];
        }
        if (!value) {
            value = @"";
        }
        [updateValues addObject:value];
    }
    [updateKey deleteCharactersInRange:NSMakeRange(updateKey.length - 1, 1)];
    NSString* updateSQL;

    if(model.rowid >= 0 && model.primaryKey.length == 0)
    {
        updateSQL = [NSString stringWithFormat:@"update %@ set %@ where rowid=%d",NSStringFromClass(model.class),updateKey,model.rowid];
    }
    else
    {
        //如果不通过 rowid 来 更新数据  那 primarykey 一定要有值
        updateSQL = [NSString stringWithFormat:@"update %@ set %@ where %@=?",NSStringFromClass(model.class),updateKey,model.primaryKey];
        [updateValues addObject:[self safetyGetModel:model valueKey:model.primaryKey]];
    }
    //NSLog(@"update:%@,%@",updateSQL,updateValues);
    BOOL result = [db executeUpdate:updateSQL withArgumentsInArray:updateValues];
    block(result);
}
-(void)updateToDB:(LLDaoModelBase*)model callback:(void (^)(BOOL))block
{
    if(model == nil){
        if(block != nil){
            block(NO);
        }
        return;
    }
    __block BOOL result = NO;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         [self update:model toDB:db callback:^(BOOL b){
             result = b;
         }];
     }];
    
    if(block != nil)
    {
        block(result);
    }
    if(result){
        [self setTableChangedBroadCast:model.class changedMessage:LLDAOBASE_OperationType_Update userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:model],LLDAOBASE_BroadCast_KEY_Array,nil]];
    }
}
-(void)delete:(LLDaoModelBase *)model toDB:(FMDatabase*)db callback:(void (^)(BOOL))block{
    NSString* delete;
    BOOL result = NO;
    if(model.rowid >= 0 && model.primaryKey.length == 0)
    {
        delete = [NSString stringWithFormat:@"DELETE FROM %@ where rowid=%d",NSStringFromClass(model.class),model.rowid];
        result = [db executeUpdate:delete];
    }
    else
    {
        delete = [NSString stringWithFormat:@"DELETE FROM %@ where %@=?",NSStringFromClass(model.class),model.primaryKey];
        result = [db executeUpdate:delete,[self safetyGetModel:model valueKey:model.primaryKey]];
        
    }
    if(block != nil){
        block(result);
    }
}
-(void)deleteToDB:(LLDaoModelBase*)model callback:(void (^)(BOOL))block{
    if(model == nil){
        if(block != nil){
            block(NO);
        }
        return;
    }
    __block BOOL result = NO;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         [self delete:model toDB:db callback:^(BOOL b){
             result = b;
         }];
    }];
    if(block != nil)
    {
        block(result);
    }
    if(result){
        [self setTableChangedBroadCast:model.class changedMessage:LLDAOBASE_OperationType_Delete userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:model],LLDAOBASE_BroadCast_KEY_Array,nil]];
    }
}
-(void)deleteToDBWithWhere:(LLDaoModelBase*)llDaoModelBase where:(NSString *)where callback:(void (^)(BOOL))block
{
    __block BOOL result = NO;
    __block NSArray* deletArray = [NSArray array];
    [self searchAll:llDaoModelBase where:where callback:^(NSArray* array){
        if(array){
            deletArray = array;
        }
    }];
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSString* delete = [NSString stringWithFormat:@"DELETE FROM %@ where %@",NSStringFromClass(llDaoModelBase.class),where];
         result = [db executeUpdate:delete]; 
     }];
    if(block != nil)
    {
        block(result);
    }
    if(result){
        [self setTableChangedBroadCast:llDaoModelBase.class changedMessage:LLDAOBASE_OperationType_DeleteArray userInfo:[NSDictionary dictionaryWithObjectsAndKeys:deletArray,LLDAOBASE_BroadCast_KEY_Array, nil]];
    }
}
-(NSString*)dictionaryToSqlWhere:(NSDictionary*)dic andValues:(NSMutableArray*)values
{
    NSMutableString* wherekey = [NSMutableString stringWithCapacity:0];
    if(dic != nil && dic.count >0 )
    {
        NSArray* keys = dic.allKeys;
        for (int i=0; i< keys.count;i++) {
            
            NSString* key = [keys objectAtIndex:i];
            id va = [dic objectForKey:key];
            if([va isKindOfClass:[NSArray class]])
            {
                NSArray* vlist = va;
                for (int j=0; j<vlist.count; j++) {
                    id subvalue = [vlist objectAtIndex:j];
                    if(wherekey.length > 0)
                    {
                        if(j >0)
                        {
                            [wherekey appendFormat:@" or %@ = ? ",key];
                        }
                        else{
                            [wherekey appendFormat:@" and %@ = ? ",key];
                        }
                    }
                    else
                    {
                        [wherekey appendFormat:@" %@ = ? ",key];
                    }
                    [values addObject:subvalue];
                }
            }
            else
            {
                if(wherekey.length > 0)
                {
                    [wherekey appendFormat:@" and %@ = ? ",key];
                }
                else
                {
                    [wherekey appendFormat:@" %@ = ? ",key];
                }
                [values addObject:va];
            }
            
        }
    }
    return wherekey;
}
-(void)deleteToDBWithWhereDic:(LLDaoModelBase*)llDaoModelBase where:(NSDictionary *)where callback:(void (^)(BOOL))block
{
    __block BOOL result = NO;
    __block NSArray* deletArray = [NSArray array];
    [self searchAll:llDaoModelBase dic:where callback:^(NSArray* array){
        if(array){
            deletArray = array;
        }  
    }];

    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSMutableArray* values = [NSMutableArray arrayWithCapacity:6];
         NSString* wherekey = [self dictionaryToSqlWhere:where andValues:values];
         NSString* delete = [NSString stringWithFormat:@"DELETE FROM %@ where %@",NSStringFromClass(llDaoModelBase.class),wherekey];
         result = [db executeUpdate:delete withArgumentsInArray:values];    
     }];
    if(block != nil)
    {
        block(result);
    }
    if(result){
        [self setTableChangedBroadCast:llDaoModelBase.class changedMessage:LLDAOBASE_OperationType_DeleteArray userInfo:[NSDictionary dictionaryWithObjectsAndKeys:deletArray,LLDAOBASE_BroadCast_KEY_Array, nil]];
    }
}
-(void)clearTableData:(LLDaoModelBase*)model
{
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         NSString* delete = [NSString stringWithFormat:@"DELETE FROM %@",NSStringFromClass(model.class)];
         [db executeUpdate:delete];
     }];
}
-(void)isExistsModel:(LLDaoModelBase*)model callback:(void(^)(BOOL))block{
    //如果有rowid 就肯定存在
    [self isExistsWithWhere:model where:[NSString stringWithFormat:@"%@ = \'%@\'",model.primaryKey,[self safetyGetModel:model valueKey:model.primaryKey]] callback:block];
}

-(void)isExistsWithWhere:(LLDaoModelBase*)model where:(NSString *)where callback:(void (^)(BOOL))block
{
    __block BOOL exists = NO;
    [bindingQueue inDatabase:^(FMDatabase* db)
     {
         //rowid 就不判断了
         NSString* rowCountSql = [NSString stringWithFormat:@"select count(*) from %@ where %@",NSStringFromClass(model.class),where];
         FMResultSet* resultSet = [db executeQuery:rowCountSql];
         [resultSet next];
         int result =  [resultSet intForColumnIndex:0];
         [resultSet close];
         exists = (result != 0);    
     }];
    if(block != nil)
    {
        block(exists);
    }
}
-(id)safetyGetModel:(LLDaoModelBase*) model valueKey:(NSString*)valueKey
{
    if(STR_IS_NIL(valueKey)){
        return @"";
    }
    id value = [model valueForKey:valueKey];
    if(value == nil)
    {
        return @"";
    }
    return value;
}
const static NSString* normaltypestring = @"floatdoublelongcharshort";
const static NSString* blobtypestring = @"NSDataUIImage";
+(NSString *)toDBType:(NSString *)type
{
    if([type isEqualToString:@"int"])
    {
        return LLSQLInt;
    }
    if ([normaltypestring rangeOfString:type].location != NSNotFound) {
        return LLSQLDouble;
    }
    if ([blobtypestring rangeOfString:type].location != NSNotFound) {
        return LLSQLBlob;
    }
    return LLSQLText;
}
#pragma mark-
+(NSDateFormatter*)getDateFormat
{
    static  NSDateFormatter* formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    return formatter;
}
//把Date 转换成String
+(NSString*)stringWithDate:(NSDate*)date
{
    NSDateFormatter* formatter = [self getDateFormat];
    NSString* datestr = [formatter stringFromDate:date];
    return datestr;
}
+(NSDate *)dateWithString:(NSString *)str
{
    NSDateFormatter* formatter = [self getDateFormat];
    NSDate* date = [formatter dateFromString:str];
    return date;
}

/**
 * 功能：单例回收
 * 参数：无
 * 返回值：无
 
 * 创建者：kevin wan
 * 创建日期：<#日期#>
 */
+(void)attemptDealloc
{
    ShardInstance = nil;
}

@end

//-(void)updateInsertToDB:(Class)modelClass dic:(NSDictionary*)columnValues dic:(NSDictionary*)where callback:(void(^)(BOOL))block{
//    [bindingQueue inDatabase:^(FMDatabase* db){
//        NSMutableString* whereStr = [NSMutableString string];
//        for(NSString* key in [where allKeys]){
//            if(whereStr.length == 0){
//                [whereStr appendFormat:@"where %@='%@'",key,[self getValueForm:where with:key]];
//            }else{
//                [whereStr appendFormat:@" and %@='%@'",key,[self getValueForm:where with:key]];
//            }
//        }
//        NSString* rowCountSql = [NSString stringWithFormat:@"select count(rowid) from %@ %@",NSStringFromClass(modelClass),whereStr];
//        FMResultSet* resultSet = [db executeQuery:rowCountSql];
//        [resultSet next];
//        int result =  [resultSet intForColumnIndex:0];
//        [resultSet close];
//        BOOL exists = (result != 0);
//        if(exists){
//            NSMutableString* updateKey = [[NSMutableString alloc]init];
//            NSMutableArray* values = [NSMutableArray array];
//            for(NSString* key in [columnValues allKeys]){
//                if(updateKey.length == 0){
//                    [updateKey appendString:@" "];
//                }else{
//                    [updateKey appendString:@", "];
//                }
//                [updateKey appendFormat:@"%@=%@", key,[self getValueForm:columnValues with:key]];
//            }
//            NSMutableString* whereStr = [NSMutableString string];
//            for(NSString* key in [where allKeys]){
//                if(whereStr.length == 0){
//                    [whereStr appendFormat:@"where %@=%@",key,[self getValueForm:where with:key]];
//                }else{
//                    [whereStr appendFormat:@" and %@=%@",key,[self getValueForm:where with:key]];
//                }
//                [values addObject:[where objectForKey:key]];
//            }
//            NSString* updateSQL = [NSString stringWithFormat:@"update %@ set %@ %@",NSStringFromClass(modelClass),updateKey,whereStr];
//            BOOL execute = [db executeUpdate:updateSQL];
//            if(block != nil){
//                block(execute);
//            }
//        }else{
//            NSMutableString* insertKey = [NSMutableString stringWithCapacity:0];
//            NSMutableString* insertValuesString = [NSMutableString stringWithCapacity:0];
//            for (NSString* key in [columnValues allKeys]) {
//                if(insertKey.length == 0){
//                    [insertKey appendFormat:@"%@", key];
//                    [insertValuesString appendFormat:@"%@",[self getValueForm:columnValues with:key]];
//                }else{
//                    [insertKey appendFormat:@",%@", key];
//                    [insertValuesString appendFormat:@",%@",[self getValueForm:columnValues with:key]];
//                }
//            }
//            NSString* insertSQL = [NSString stringWithFormat:@"insert into %@(%@) values(%@)",NSStringFromClass(modelClass),insertKey,insertValuesString];
//            BOOL execute = [db executeUpdate:insertSQL];
//            if(!execute){
//                NSLog(@"updateInsertToDB error:%@",insertSQL);
//            }
//            if(block != nil){
//                 block(execute);
//            }
//        }
//    }];
//}


