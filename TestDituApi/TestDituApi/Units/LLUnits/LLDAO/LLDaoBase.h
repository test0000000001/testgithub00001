//
//
//
//  Created by y h on 12-10-8.
//  Copyright (c) 2012年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "SandboxFile.h"
#import "LLDaoModelBase.h"
#import "NSStringExtraForLLDao.h"
#import "NSObjectExtraForLLDao.h"

#define LLSQLText @"text"
#define LLSQLInt @"integer"
#define LLSQLDouble @"float"
#define LLSQLBlob @"blob"
#define LLSQLNull @"null"
#define LLSQLIntPrimaryKey @"integer primary key"

 
#define LLDAOBASE_OperationType_Insert @"LLDAOBASE_OperationType_Insert"
#define LLDAOBASE_OperationType_InsertArray @"LLDAOBASE_OperationType_InsertArray"
#define LLDAOBASE_OperationType_Update @"LLDAOBASE_OperationType_Update"
#define LLDAOBASE_OperationType_UpdateArray @"LLDAOBASE_OperationType_UpdateArray"
#define LLDAOBASE_OperationType_Delete @"LLDAOBASE_OperationType_Delete"
#define LLDAOBASE_OperationType_DeleteArray @"LLDAOBASE_OperationType_DeleteArray"
#define LLDAOBASE_OperationType_UpdateInsertArray @"LLDAOBASE_OperationType_UpdateInsertArray"

#define LLDAOBASE_BroadCast_KEY_Array @"LLDAOBASE_BroadCast_KEY_Array"
//流程 1 初始化一个表明对象  2 用lldaobase获取单例  3.调用lldaobase里面的方法


@interface LLDAOBase : NSObject
+(LLDAOBase *)shardLLDAOBase;

-(void)create:(NSString*)dbPath;
//-(id)initWithDBQueue:(FMDatabaseQueue *)queue;
@property(retain,nonatomic)FMDatabaseQueue* bindingQueue;

//创建数据库
-(void)createTable:(LLDaoModelBase*)llDaoModelBase;

//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//搜索数据库表中所有数据
-(void)searchAll:(LLDaoModelBase*)llDaoModelBase callback:(void(^)(NSArray*))callback;

//搜索数据库表中所有满足条件的数据
-(void)searchAll:(LLDaoModelBase*)llDaoModelBase dic:(NSDictionary*)where callback:(void(^)(NSArray*))callback;

//搜索数据库表中所有满足条件的数据
-(void)searchAll:(LLDaoModelBase*)llDaoModelBase where:(NSString*)where callback:(void(^)(NSArray*))callback;

//按某个字段 批量搜索内容
// columnName 字段名
// where 条件
-(void)searchAllWithArray:(LLDaoModelBase*)llDaoModelBase withColumnName:(NSString*) columnName where:(NSArray*)where callback:(void(^)(NSArray*))callback;

//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//最多返回15条数据   where搜索条件条件 要自己写  比如 where =  @"rowid = 2"
//[[LLDAOBase shardLLDAOBase]searchWhere:llDaoModelBase where:@"userid='aaaa'" callback:nil];
-(void)searchWhere:(LLDaoModelBase*)llDaoModelBase where:(NSString*)where callback:(void(^)(NSArray*))block;
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//基本sql语句
//offset 数据起始位置
//count数据条数  传入-1代表查询出所有，此时offset值设置无效
//orderBy:按什么字段排序
//[[LLDAOBase shardLLDAOBase]searchWhere:llDaoModelBase where:@"sex='1'" orderBy:@"age" offset:10 count:15 callback:];//取出性别为1 的第10-24条数据，并按年龄排序（默认升序排序）
-(void)searchWhere:(LLDaoModelBase*)llDaoModelBase String:(NSString*)where orderBy:(NSString*)columeName offset:(int)offset count:(int)count callback:(void(^)(NSArray*))block;
//asc（排序方式 YES 升序 NO降序）
-(void)searchWhere:(LLDaoModelBase*)llDaoModelBase String:(NSString *)where orderBy:(NSString *)orderBy asc:(BOOL)asc offset:(int)offset count:(int)count callback:(void (^)(NSArray *))block;

//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//查询的条件以 key-value 模式传入
-(void)searchWhereDic:(LLDaoModelBase*)llDaoModelBase Dic:(NSDictionary*)where orderBy:(NSString *)orderby offset:(int)offset count:(int)count callback:(void (^)(NSArray *))block;
//asc YES 升序 NO降序
-(void)searchWhereDic:(LLDaoModelBase*)llDaoModelBase Dic:(NSDictionary*)where orderBy:(NSString *)orderby asc:(BOOL)asc offset:(int)offset count:(int)count callback:(void (^)(NSArray *))block;
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//默认返回 15条数据
//where = [NSDictionaray d
-(void)searchWhereDic:(LLDaoModelBase*)llDaoModelBase Dic:(NSDictionary*)where callback:(void(^)(NSArray*))block;
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//把 model 插入到 数据库
-(void)updateInsertToDB:(LLDaoModelBase*)model callback:(void(^)(BOOL))block;//简化版增改，有就改无则增
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//更新或插入部分字段 columnValues需要更新的字段名和对应值， 
//columnValues需要修改的字段名和对应值 [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"sex",@"100",@"age", nil]
//where传入查询条件[NSDictionary dictionaryWithObjectsAndKeys:@"aaa",@"userid",nil]
//-(void)updateInsertToDB:(Class)modelClass dic:(NSDictionary*)columnValues dic:(NSDictionary*)where callback:(void(^)(BOOL))block;
//更新数据库中部分字段的值
-(void)updateToDB:(Class)modelClass dic:(NSDictionary*)columnValues dic:(NSDictionary*)where callback:(void(^)(BOOL))block;
//where 查询条件
-(void)updateToDB:(Class)modelClass dic:(NSDictionary *)columnValues where:(NSString*)where callback:(void (^)(BOOL))block;
//插入数据
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
-(void)insertToDB:(LLDaoModelBase*)model callback:(void(^)(BOOL))block;
//更新数据
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
-(void)updateToDB:(LLDaoModelBase*)model callback:(void(^)(BOOL))block;
//删除数据
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
-(void)deleteToDB:(LLDaoModelBase*)model callback:(void(^)(BOOL))block;
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//批量插入 models里面的对象必需是LLDaoModeBase类型
-(void)insertToDBFromArray:(NSArray *)models callback:(void (^)(BOOL))block;
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//批量更新 models里面的对象必需是LLDaoModeBase类型
-(void)updateToDBFromArray:(NSArray *)models callback:(void (^)(BOOL))block;
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//合并插入和插入方法 如果数据存在则执行更新，数据不存在则添加
-(void)updateInsertToDBFromArray:(NSArray *)models callback:(void (^)(BOOL))block;
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//批量删除 models里面的对象必需是LLDaoModeBase类型
-(void)deleteToDBFromArray:(NSArray *)models callback:(void(^)(BOOL))block;
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//根据where 条件删除数据
-(void)deleteToDBWithWhere:(LLDaoModelBase*)llDaoModelBase where:(NSString*)where callback:(void (^)(BOOL))block;
-(void)deleteToDBWithWhereDic:(LLDaoModelBase*)llDaoModelBase where:(NSDictionary*)where callback:(void (^)(BOOL))block;
//当 NSDictionary 的value 是NSArray 类型时  使用 or 当中间值

//清空表数据
-(void)clearTableData:(LLDaoModelBase*)model;
//注意：数据库操作的返回结果Block里面不能在进行数据库操作，否则会死锁
//查询是否数据已存在
-(void)isExistsModel:(LLDaoModelBase*)model callback:(void(^)(BOOL))block;
-(void)isExistsWithWhere:(LLDaoModelBase*)model where:(NSString*)where callback:(void (^)(BOOL))block;
+(NSString*)toDBType:(NSString*)type; //把Object-c 类型 转换为sqlite 类型
//获取modelClass对应的表中已存在的数据总数
-(void)getTotalRowsIn:(Class)modelClass callBack:(void(^)(long))block;
-(void)getTotalRowsIn:(Class)modelClass dic:(NSDictionary*)where callBack:(void(^)(long))block;
-(void)getTotalRowsIn:(Class)modelClass where:(NSString*)where callBack:(void(^)(long))block;
//移除对象对某个数据库表的监听
//销毁监听对象的时候
//   [[LLDAOBase shardLLDAOBase]removeObserver:self name:[LLDaoModelDiary class]];
-(void)removeObserver:(id)observer name:(Class)tableClass;

//监听某个数据库表的数据变化，
//tableClass 数据库表对应的class
// observer接收广播的对象
// selector 接收方法，请用类似方法-(void)tableDataChanged:(NSNotification*)notify
//NSNOtificatiion对象 name存放通知名称
//object通知信息（insert插入一条数据  delete 删除一条数据 update更新一条数据 insert-array插入一组数据，update-array更新了一组数据，updateInsert-array更新插入了一组数据 delete-array删除了一组数据）
//userInfo（存放一些信息字典，例如主键和对应值）


//使用示例
//添加数据库表监控
//    [[LLDAOBase shardLLDAOBase]addTableChangedBroadCast:[LLDaoModelDiary class] observer:self selector:@selector(llDaoModelDiaryDataChanged:)];


//-(void)llDaoModelDiaryDataChanged:(NSNotification*)notification{
//    NSString* opertionType = notification.object;
//    if([opertionType isEqualToString:LLDAOBASE_OperationType_DeleteArray]){
//        NSArray* deleteArray = [notification.userInfo objectForKey:LLDAOBASE_BroadCast_KEY_Array];
//    }
//}
-(void)addTableChangedBroadCast:(Class)tableClass observer:(id)observer selector:(SEL)selector;


+(void)attemptDealloc;  //单例销毁
@end


