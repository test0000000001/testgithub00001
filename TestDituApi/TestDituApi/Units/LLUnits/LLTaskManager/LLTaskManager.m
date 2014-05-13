//
//  LLTaskManager.m
//  VideoShare
//
//  Created by zengchao on 13-6-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLTaskManager.h"
#import "LLDaoBase.h"
#import "LLDaoModelTask.h"
#import "GetNetworkInfoModel.h"

#define TASK_PAGE_SIZE 200

@interface LLTaskManager()<LLTaskBaseDelegate>
@property(nonatomic,strong) NSMutableArray* tasks;
@property(nonatomic,strong) LLTaskBase* aLiveTask;
@property(nonatomic,strong) NSMutableArray* needDeleteTasks;
@end

@implementation LLTaskManager
static id SharedInstance;
//管理器单例
+(LLTaskManager *)sharedLLTaskManager
{
    @synchronized(SharedInstance)
    {
        if (!SharedInstance)
        {
            SharedInstance=[[self alloc]init];
        }
    }
    return SharedInstance;
}

-(id)init
{
    if (self = [super init]) {
        self.tasks = [[NSMutableArray alloc]initWithCapacity:TASK_PAGE_SIZE];
        self.needDeleteTasks = [[NSMutableArray alloc]initWithCapacity:10];
        self.taskIDOfPriorityFlag = -1;
        [self reSetTasksFromDataBase];
    }
    return self;
}



//数据库任务对象放入内存中
-(void)reSetTasksFromDataBase
{
    [self stopTask];
    [_tasks removeAllObjects];
    __block LLDaoModelTask* lLDaoModelTask = [[LLDaoModelTask alloc]init];
    [[LLDAOBase shardLLDAOBase] searchWhereDic:lLDaoModelTask Dic:nil orderBy:@"priority" offset:0 count:TASK_PAGE_SIZE callback:^(NSArray *resultArray)
    {
        for (LLDaoModelTask* cell in resultArray) {
            [_tasks addObject:cell];
        }
    }];
}

//添加一条任务,任务必须继承自LLTaskBase
//taskInfo为Json字串，保存任务执行所需要的信息
-(int)addTask:(Class)taskClass:(NSString*)taskInfo;
{
    int max = [self maxTaskID];
    int maxPriority = [self maxPriority];
    //最大的taskid＋1,成为新记录taskid
    LLDaoModelTask* lLDaoModelTask = [[LLDaoModelTask alloc]init];
    max++;
    maxPriority++;
    lLDaoModelTask.taskID = max;
    lLDaoModelTask.priority = maxPriority;
    lLDaoModelTask.taskInfo = taskInfo;
    lLDaoModelTask.taskName = NSStringFromClass(taskClass);
    
    __block BOOL result2 = NO;
    [[LLDAOBase shardLLDAOBase] updateInsertToDB:lLDaoModelTask callback:^(BOOL b) {
        //NSLog(@"updateInsertToDB LLDaoModelTask:%d",b);
        result2 = b;
    }];
    if (result2) {
        //[self reSetTasksFromDataBase];
        [_tasks addObject:lLDaoModelTask];
        NSLog(@"添加任务成功 taskid = %d ,class = %@,taskInfo=%@",max,NSStringFromClass(taskClass),taskInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"taskListChanged" object:self userInfo:nil];
    }
    
    //延迟执行，因为需要等此函数返回后,拿到taskid,任务本身才能执行
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
    if ([self needStartTask]) { // 网络状况设置下,是否需要启动任务
        //加完任务后，自动取消全部暂停属性
        [self setTaskListAlive:YES];
        if ([_tasks count] > 0) {
            [self startTask];
        }
    }
    //});
    return max;
}

- (BOOL)needStartTask {
    if ([APP_SYSC_TYPE isEqualToString:@"2"]) {//2仅WIFI
        if ([GetNetworkInfoModel getNetworkType] == NETWORK_WIFI) {
            return TRUE;
        }else {
            return FALSE;
        }
    }
    else {
        if([GetNetworkInfoModel getNetworkType] != NETWORK_NOT_AVAILABLE) {
            return TRUE;
        }else {
            return FALSE;
        }
    }
}


-(int)maxTaskID
{
    __block int max = 0;
    [[LLDAOBase shardLLDAOBase] searchWhereDic:[[LLDaoModelTask alloc]init] Dic:nil orderBy:@"taskID" asc:NO offset:0 count:1 callback:^(NSArray *resultArray)
     {
         for (LLDaoModelTask* cell in resultArray) {
             max = cell.taskID;
             break;
         }
     }];
    return max;
}

-(int)minTaskID
{
    __block int min = -1;
    [[LLDAOBase shardLLDAOBase] searchWhereDic:[[LLDaoModelTask alloc]init] Dic:nil orderBy:@"taskID" asc:YES offset:0 count:1 callback:^(NSArray *resultArray)
     {
         for (LLDaoModelTask* cell in resultArray) {
             min = cell.taskID;
             break;
         }
     }];
    return min;
}

-(int)maxPriority
{
    __block int max = -1;
    [[LLDAOBase shardLLDAOBase] searchWhereDic:[[LLDaoModelTask alloc]init] Dic:nil orderBy:@"priority" asc:NO offset:0 count:1 callback:^(NSArray *resultArray)
     {
         for (LLDaoModelTask* cell in resultArray) {
             max = cell.priority;
             break;
         }
     }];
    return max;
}

-(int)minPriority
{
    __block int min = -1;
    [[LLDAOBase shardLLDAOBase] searchWhereDic:[[LLDaoModelTask alloc]init] Dic:nil orderBy:@"priority" asc:YES offset:0 count:1 callback:^(NSArray *resultArray)
     {
         for (LLDaoModelTask* cell in resultArray) {
             min = cell.priority;
             break;
         }
     }];
    return min;
}

//删除一条任务
-(void)deleteTask:(int)taskID
{
    LLDaoModelTask* lLDaoModelTask = [self task:taskID];
    if(lLDaoModelTask){
        lLDaoModelTask.taskID = taskID;
        __block BOOL result = NO;
        if(lLDaoModelTask)
            [[LLDAOBase shardLLDAOBase] deleteToDB:lLDaoModelTask callback:^(BOOL b)
             {
                 NSLog(@"删除一条任务 更新数据库%d taskid=%d taskname=%@",b,lLDaoModelTask.taskID,lLDaoModelTask.taskName);
                 result = b;
             }];
        if (result) {
            [self reSetTasksFromDataBase];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"taskListChanged" object:self userInfo:nil];
    }
    
}

//执行任务,如果状态为暂停,则跳过
-(void)startTask
{
    BOOL alive = NO;
    if (_aLiveTask == nil && self.taskListAlive == YES) {
        for (LLDaoModelTask* cell in _tasks) {
            if ([cell.taskStatus isEqualToString:@"0"]) {
                [self startTask:cell];
                alive = YES;
                break;
            }
        }
        if(!alive){
            [self setTaskListAlive:NO];
        }
    }
}

//执行任务
-(void)startTask:(LLDaoModelTask*)task
{
    self.aLiveTask = [self taskInstanceFromModel:task];
    [_aLiveTask startTask];
}

-(LLTaskBase*)taskInstanceFromModel:(LLDaoModelTask*)taskModel
{
    LLTaskBase* result = nil;
    if (taskModel) {
        if (_aLiveTask && _aLiveTask.taskID == taskModel.taskID) {
            result = _aLiveTask;
        }
        else
        {
            result = [[NSClassFromString(taskModel.taskName) alloc] init];
            result.taskID = taskModel.taskID;
            result.taskInfo = taskModel.taskInfo;
            [result set_Delegate:self];
        }
    }
    return result;
}

//任务模块回调，用于收集任务的执行情况
#pragma mark LLTaskBaseDelegate
//LLTaskBaseDelegate 当任务完成
-(void)taskFinished:(int)taskID:(BOOL)error
{
    if (_aLiveTask && _aLiveTask.taskID == taskID) {
        [self removeAliveTaskToDeleteList];
    }
    if(taskID == _taskIDOfPriorityFlag){
        _taskIDOfPriorityFlag = -1;
    }
    //删除任务
    [self deleteTask:taskID];
    //开始新任务
    [self startTask];
}

//LLTaskBaseDelegate 当任务暂停
-(void)taskPaused:(int)taskID
{
    [self pauseTask:taskID];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"taskCellChanged" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",taskID],@"taskID",nil]];
}

//LLTaskBaseDelegate 当删除任务执行结束
-(void)deletedTaskFinish:(int)taskID
{
    for (LLTaskBase* cell in _needDeleteTasks) {
        if (cell.taskID == taskID) {
            [_needDeleteTasks removeObject:cell];
        }
    }
}

//外部调用,删除一条任务
-(void)setTaskNeedDelete:(int)taskID
{
    [self stopTask:taskID];
    [self deleteTask:taskID];
    [self startTask];
}

//外部调用,使此任务继续
-(void)setTaskContinue:(int)taskID
{
    [self continueTask:taskID];
    [self startTask];
}

//外部调用,使此任务暂停
-(void)setTaskPause:(int)taskID
{
    if (_aLiveTask && _aLiveTask.taskID == taskID) {
        [self removeAliveTaskToDeleteList];
    }
    [self pauseTask:taskID];
    [self startTask];
}

//外部调用,修改此任务信息
-(void)setTaskInfo:(int)taskID:(NSString*)taskInfo:(NSString*)changeReason
{
    LLDaoModelTask* lLDaoModelTask = [self task:taskID];
    if (lLDaoModelTask) {
        lLDaoModelTask.taskInfo = taskInfo;
        
        [[LLDAOBase shardLLDAOBase] updateInsertToDB:lLDaoModelTask callback:^(BOOL result) {
            NSLog(@"任务信息发生变化,更新数据库:%d taskid = %d ,class = %@",result,taskID,lLDaoModelTask.taskName);
            if (result) {
                [self setTask:lLDaoModelTask];
                if (_aLiveTask.taskID == lLDaoModelTask.taskID) {
                    [_aLiveTask taskInfoChanged:taskInfo:changeReason];
                }
            }
        }];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"taskCellChanged" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",taskID],@"taskID",nil]];
}

-(void)pauseTask:(int)taskID
{
    LLDaoModelTask* lLDaoModelTask = [self task:taskID];
    if (lLDaoModelTask) {
        lLDaoModelTask.taskStatus = @"1";
        __block BOOL result = NO;
        [[LLDAOBase shardLLDAOBase] updateInsertToDB:lLDaoModelTask callback:^(BOOL b) {
            NSLog(@"任务暂停 更新数据库%d taskid=%d taskname=%@",b,lLDaoModelTask.taskID,lLDaoModelTask.taskName);
            result = b;
        }];
        if (result) {
            if(_aLiveTask && _aLiveTask.taskID == taskID) {
                [self removeAliveTaskToDeleteList];
            }
            [self reSetTasksFromDataBase];
            [self startTask];
        }
    }
}

-(void)continueTask:(int)taskID
{
    LLDaoModelTask* lLDaoModelTask = [self task:taskID];
    if (lLDaoModelTask) {
        lLDaoModelTask.taskStatus = @"0";
        __block BOOL result = NO;
        [[LLDAOBase shardLLDAOBase] updateInsertToDB:lLDaoModelTask callback:^(BOOL b) {
            NSLog(@"任务继续 更新数据库%d taskid=%d taskname=%@",b,lLDaoModelTask.taskID,lLDaoModelTask.taskName);
            result = b;
        }];
        if (result) {
            [self reSetTasksFromDataBase];
        }
    }
}

-(void)setTask:(LLDaoModelTask*)task
{
    for (int i = 0 ; i<[_tasks count]; i++) {
        LLDaoModelTask* cell = [_tasks objectAtIndex:i];
        if (cell.taskID == task.taskID) {
            [_tasks replaceObjectAtIndex:i withObject:task];
            break;
        }
    }
}

-(LLDaoModelTask*)task:(int)taskID
{
    __block LLDaoModelTask* result = nil;
    for (LLDaoModelTask* cell in _tasks) {
        if (cell.taskID == taskID) {
            result = cell;
            break;
        }
    }
    
    if (!result) {//也许超出一页,则从数据库取
        NSDictionary* dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:taskID] forKey:@"taskID"];
        [[LLDAOBase shardLLDAOBase] searchWhereDic:[[LLDaoModelTask alloc]init] Dic:dic orderBy:nil offset:0 count:1 callback:^(NSArray *resultArray)
         {
             for (LLDaoModelTask* cell in resultArray) {
                 result = cell;
                 break;
             }
         }];
    }
    return result;
}

-(int)count
{
    return [_tasks count];
}

-(void)IndexToID:(int)index:(void (^)(BOOL b,int taskID))block
{
    if (index>=0&&index<[_tasks count]) {
        LLDaoModelTask* lLDaoModelTask = [_tasks objectAtIndex:index];
        block(YES,lLDaoModelTask.taskID);
        return;
    }
    block(NO,0);
}

-(void)IDToIndex:(int)taskID:(void (^)(BOOL b,int index))block
{
    for (int i = 0; i<[_tasks count]; i++) {
        LLDaoModelTask* cell = [_tasks objectAtIndex:i];
        if(cell.taskID == taskID)
        {
            block(YES,i);
        }
    }
    block(NO,0);
}

-(LLTaskBase*)taskAtIndex:(int)index
{
    __block LLTaskBase* result = nil;
    [self IndexToID:index:^(BOOL b,int taskID){
        if (b == YES) {
            LLDaoModelTask* lLDaoModelTask = [self task:taskID];
            if (lLDaoModelTask) {
                result = [self taskInstanceFromModel:lLDaoModelTask];
            }
        }
    }];
    return result;
}


-(void)removeAliveTaskToDeleteList
{
    if (_aLiveTask) {
        [_needDeleteTasks addObject:_aLiveTask];
        self.aLiveTask = nil;
    }
}

-(void)bringTaskToFirst:(int)taskID
{
    if (_aLiveTask) {
        [self stopTask:_aLiveTask.taskID];
    }
    [self reSetAllTaskAlive];
    [self reSetTasksFromDataBase];
    
    int destinationPriority = [self minPriority] - 1;
    LLDaoModelTask* lLDaoModelTask = [self task:taskID];
    __block BOOL success = NO;
    if (lLDaoModelTask) {
        lLDaoModelTask.priority = destinationPriority;
        [[LLDAOBase shardLLDAOBase] updateInsertToDB:lLDaoModelTask callback:^(BOOL result) {
            NSLog(@"任务信息发生变化,更新数据库:%d taskid = %d ,class = %@",result,taskID,lLDaoModelTask.taskName);
            success = result;
        }];
    }
    if (success) {
        [self reSetTasksFromDataBase];
        [self startTask];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"taskListChanged" object:self userInfo:nil];
    }
}

-(int)priority:(int)taskID
{
    int result = 0;
    LLDaoModelTask* lLDaoModelTask = [self task:taskID];
    if (lLDaoModelTask) {
        result = lLDaoModelTask.priority;
    }
    return result;
}

-(void)stopTask:(int)taskID
{
    if(_aLiveTask && _aLiveTask.taskID == taskID) {
        [_aLiveTask taskNeedDelete];
        [self removeAliveTaskToDeleteList];
    }
}

-(BOOL)isTaskAlive:(int)taskID
{
    BOOL result = NO;
    if (_aLiveTask && taskID == _aLiveTask.taskID) {
        result = YES;
    }
    return result;
}

-(BOOL)isTaskPriorityFlag:(int)taskID
{
    BOOL result = NO;
    if (taskID == _taskIDOfPriorityFlag) {
        result = YES;
    }
    return result;
}

-(NSString*)taskInfo:(int)taskID
{
    NSString* result = @"";
    LLDaoModelTask* lLDaoModelTask = [self task:taskID];
    if (lLDaoModelTask) {
        result = lLDaoModelTask.taskInfo;
    }
    return result;
}

-(void)reSetAllTaskAlive
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"taskStatus", nil];
    [[LLDAOBase shardLLDAOBase] updateToDB:[LLDaoModelTask class] dic:dic dic:nil callback:nil];
}

-(void)reSetAllTaskSleep
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"taskStatus", nil];
    [[LLDAOBase shardLLDAOBase] updateToDB:[LLDaoModelTask class] dic:dic dic:nil callback:nil];
}

-(void)stopTask
{
    if (_aLiveTask) {
        [self stopTask:_aLiveTask.taskID];
    }
}

-(BOOL)taskListAlive
{
    __block BOOL result = NO;

    [[LLDAOBase shardLLDAOBase] searchWhere:[[LLDaoModelUser alloc] init]
                                     String:[NSString stringWithFormat:@"userid = \'%@\'",APP_USERID]
                                    orderBy:nil
                                     offset:0 count:1
                                   callback:^(NSArray *resultArray) {
                                       if(resultArray.count > 0){
                                           LLDaoModelUser *myllDaoModelUser = [resultArray lastObject];
                                           result = myllDaoModelUser.taskListAlive;
                                       }
                                   }];
    return result;
}

-(void)setTaskListAlive:(BOOL)b
{
    NSMutableDictionary *columnDic = [NSMutableDictionary dictionary];
    [columnDic setValue:[NSNumber numberWithInt:b] forKey:@"taskListAlive"];
    NSMutableDictionary *whereDic = [NSMutableDictionary dictionary];
    [whereDic setValue:APP_USERID forKey:@"userid"];
    [[LLDAOBase shardLLDAOBase] updateToDB:[LLDaoModelUser class]
                                       dic:columnDic
                                       dic:whereDic
                                  callback:nil];
}

//销毁单例
+(void)attemptDealloc
{
    SharedInstance = nil;
}
@end
