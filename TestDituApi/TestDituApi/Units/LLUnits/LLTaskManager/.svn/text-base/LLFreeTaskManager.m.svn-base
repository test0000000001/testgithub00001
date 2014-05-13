//
//  LLFreeTaskManager.m
//  VideoShare
//
//  Created by zengchao on 13-6-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLFreeTaskManager.h"
#import "LLDaoBase.h"
#import "LLDaoModelFreeTask.h"
#define TASK_PAGE_SIZE 15

@interface LLFreeTaskManager()<LLTaskBaseDelegate>
@property(nonatomic,strong) NSMutableArray* tasks;
@property(nonatomic,strong) NSMutableArray* aLiveTaskList;
@property(nonatomic,strong) NSMutableArray* needDeleteTasks;
@property(nonatomic,assign) int excutingTaskList;
@property(nonatomic,strong) NSMutableArray* tmpExcutingTasks;
@end

@implementation LLFreeTaskManager
static id SharedInstance;
//管理器单例
+(LLFreeTaskManager *)sharedLLFreeTaskManager
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
        self.aLiveTaskList = [[NSMutableArray alloc]initWithCapacity:10];
        [self reSetAllTaskAlive];
        [self reSetTasksFromDataBase];
    }
    return self;
}

//数据库任务对象放入内存中
-(void)reSetTasksFromDataBase
{
    [_tasks removeAllObjects];
    __block LLDaoModelFreeTask* lLDaoModelFreeTask = [[LLDaoModelFreeTask alloc]init];
    [[LLDAOBase shardLLDAOBase] searchWhereDic:lLDaoModelFreeTask Dic:nil orderBy:@"taskID" offset:0 count:TASK_PAGE_SIZE callback:^(NSArray *resultArray)
    {
        for (LLDaoModelFreeTask* cell in resultArray) {
            [_tasks addObject:cell];
        }
    }];
}

//添加一条任务,任务必须继承自LLTaskBase
//taskInfo为Json字串，保存任务执行所需要的信息
-(int)addTask:(Class)taskClass:(NSString*)taskInfo;
{
    int max = [self maxTaskID];
    //最大的taskid＋1,成为新记录taskid
    LLDaoModelFreeTask* lLDaoModelFreeTask = [[LLDaoModelFreeTask alloc]init];
    max++;
    lLDaoModelFreeTask.taskID = max;
    lLDaoModelFreeTask.taskInfo = taskInfo;
    lLDaoModelFreeTask.taskName = NSStringFromClass(taskClass);
    
    __block BOOL result2 = NO;
    [[LLDAOBase shardLLDAOBase] updateInsertToDB:lLDaoModelFreeTask callback:^(BOOL b) {
        //NSLog(@"updateInsertToDB lLDaoModelFreeTask:%d",b);
        result2 = b;
    }];
    if (result2) {
        [self reSetTasksFromDataBase];
        NSLog(@"添加任务成功 taskid = %d ,class = %@,taskInfo=%@",max,NSStringFromClass(taskClass),taskInfo);
    }
    
    //延迟执行，因为需要等此函数返回后,拿到taskid,任务本身才能执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self addTaskToLiveList:lLDaoModelFreeTask];
        [self taskInstanceFromModel :lLDaoModelFreeTask:^(BOOL isExsit,LLTaskBase* resultTask)
         {
             if (resultTask) {
                 [resultTask startTask];
                 NSLog(@"即时执行非队列任务 %@,taskid = %d", NSStringFromClass(resultTask.class),resultTask.taskID);
             }
         }];
    });
    return max;
}

-(int)maxTaskID
{
    __block int max = 0;
    [[LLDAOBase shardLLDAOBase] searchWhereDic:[[LLDaoModelFreeTask alloc]init] Dic:nil orderBy:@"taskID" asc:NO offset:0 count:1 callback:^(NSArray *resultArray)
     {
         for (LLDaoModelFreeTask* cell in resultArray) {
             max = cell.taskID;
             break;
         }
     }];
    return max;
}

-(int)minTaskID
{
    __block int min = -1;
    [[LLDAOBase shardLLDAOBase] searchWhereDic:[[LLDaoModelFreeTask alloc]init] Dic:nil orderBy:@"taskID" asc:YES offset:0 count:1 callback:^(NSArray *resultArray)
     {
         for (LLDaoModelFreeTask* cell in resultArray) {
             min = cell.taskID;
             break;
         }
     }];
    return min;
}

//删除一条任务
-(void)deleteTask:(int)taskID
{
    LLDaoModelFreeTask* lLDaoModelFreeTask = [[LLDaoModelFreeTask alloc]init];
    lLDaoModelFreeTask.taskID = taskID;
    __block BOOL result = NO;
    if (lLDaoModelFreeTask) {
        [[LLDAOBase shardLLDAOBase] deleteToDB:lLDaoModelFreeTask callback:^(BOOL b)
         {
             NSLog(@"删除一条任务 更新数据库%d taskid=%d taskname=%@",b,lLDaoModelFreeTask.taskID,lLDaoModelFreeTask.taskName);
             result = b;
         }];
    }
    if (result) {
        [self reSetTasksFromDataBase];
    }

}

//执行任务,如果状态为暂停,则跳过
-(void)startTask
{
    for ( int i = 0 ; i < _tasks.count ; i++) {
        LLDaoModelFreeTask* cell = [_tasks objectAtIndex:i];
        if ([cell.taskStatus isEqualToString:@"0"]) {
            [self addTaskToLiveList:cell];
        }
    }
    
    if (_excutingTaskList == 0)
    {
        if (!_tmpExcutingTasks) {
            self.tmpExcutingTasks = [[NSMutableArray alloc]initWithCapacity:0];
        }
        [_tmpExcutingTasks removeAllObjects];
        [_tmpExcutingTasks addObjectsFromArray:_aLiveTaskList];
        [self recursionDelayStartTask:0];
    }
}

//递归实现延迟调用任务，防止多任务并发
-(void)recursionDelayStartTask:(int)indexOfTaskList
{
    self.excutingTaskList = 1;
    if (indexOfTaskList < _tmpExcutingTasks.count)
    {
        LLTaskBase* taskInstance = [_tmpExcutingTasks objectAtIndex:indexOfTaskList];
        [taskInstance startTask];
        NSLog(@"执行非队列任务 %@,taskid = %d", NSStringFromClass(taskInstance.class),taskInstance.taskID);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                [self recursionDelayStartTask:indexOfTaskList+1];
            });
    }
    else
    {
        self.excutingTaskList = 0;
    }
}

//某个时候调用此,重新尝试所有任务
-(void)setAllTaskLive
{
    
}

//执行任务
-(void)addTaskToLiveList:(LLDaoModelFreeTask*)task
{
    [self taskInstanceFromModel :task:^(BOOL isExsit,LLTaskBase* resultTask)
     {
         if (isExsit == NO) {
             [_aLiveTaskList addObject:resultTask];
         }
     }];
}

-(void)taskInstanceFromModel:(LLDaoModelFreeTask*)taskModel:(void (^)(BOOL isExsit,LLTaskBase* resultTask))block
{
    LLTaskBase* result = nil;
    if (taskModel) {
        
        
        for (LLTaskBase* cell in _aLiveTaskList) {
            if (cell.taskID == taskModel.taskID) {
                result = cell;
                break;
            }
        }
        
        if (result) {
            block(YES,result);
        }
        else
        {
            result = [[NSClassFromString(taskModel.taskName) alloc] init];
            result.taskID = taskModel.taskID;
            result.taskInfo = taskModel.taskInfo;
            [result set_Delegate:self];
            block(NO,result);
        }
    }
}

//任务模块回调，用于收集任务的执行情况
#pragma mark LLTaskBaseDelegate
//LLTaskBaseDelegate 当任务完成
-(void)taskFinished:(int)taskID:(BOOL)error
{
    [self removeAliveTaskToDeleteList:taskID];
    //删除任务
    [self deleteTask:taskID];
    //开始新任务
    [self startTask];
}

//LLTaskBaseDelegate 当任务暂停
-(void)taskPaused:(int)taskID
{
    [self pauseTask:taskID];
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
    [self removeAliveTaskToDeleteList:taskID];
    [self pauseTask:taskID];
    [self startTask];
}

//外部调用,修改此任务信息
-(void)setTaskInfo:(int)taskID:(NSString*)taskInfo:(NSString*)changeReason
{
    LLDaoModelFreeTask* lLDaoModelFreeTask = [self task:taskID];
    if (lLDaoModelFreeTask) {
        lLDaoModelFreeTask.taskInfo = taskInfo;
        
        [[LLDAOBase shardLLDAOBase] updateInsertToDB:lLDaoModelFreeTask callback:^(BOOL result) {
            NSLog(@"任务信息发生变化,更新数据库:%d taskid = %d ,class = %@",result,taskID,lLDaoModelFreeTask.taskName);
            if (result) {
                [self setTask:lLDaoModelFreeTask];
                LLTaskBase* task = [self aLiveTask:taskID];
                if (task) {
                    [task taskInfoChanged:taskInfo:changeReason];
                }
            }
        }];
    }
}

-(void)pauseTask:(int)taskID
{
    LLDaoModelFreeTask* lLDaoModelFreeTask = [self task:taskID];
    if (lLDaoModelFreeTask) {
        lLDaoModelFreeTask.taskStatus = @"1";
        __block BOOL result = NO;
        [[LLDAOBase shardLLDAOBase] updateInsertToDB:lLDaoModelFreeTask callback:^(BOOL b) {
            NSLog(@"任务暂停 更新数据库%d taskid=%d taskname=%@",b,lLDaoModelFreeTask.taskID,lLDaoModelFreeTask.taskName);
            result = b;
        }];
        if (result) {
            [self removeAliveTaskToDeleteList:taskID];
            [self reSetTasksFromDataBase];
        }
    }
}

-(void)continueTask:(int)taskID
{
    LLDaoModelFreeTask* lLDaoModelFreeTask = [self task:taskID];
    if (lLDaoModelFreeTask) {
        lLDaoModelFreeTask.taskStatus = @"0";
        __block BOOL result = NO;
        [[LLDAOBase shardLLDAOBase] updateInsertToDB:lLDaoModelFreeTask callback:^(BOOL b) {
            NSLog(@"任务继续 更新数据库%d taskid=%d taskname=%@",b,lLDaoModelFreeTask.taskID,lLDaoModelFreeTask.taskName);
            result = b;
        }];
        if (result) {
            [self reSetTasksFromDataBase];
        }
    }
}

-(void)setTask:(LLDaoModelFreeTask*)task
{
    for (int i = 0 ; i<[_tasks count]; i++) {
        LLDaoModelFreeTask* cell = [_tasks objectAtIndex:i];
        if (cell.taskID == task.taskID) {
            [_tasks replaceObjectAtIndex:i withObject:task];
            break;
        }
    }
}

-(LLDaoModelFreeTask*)task:(int)taskID
{
    __block LLDaoModelFreeTask* result = nil;
    for (LLDaoModelFreeTask* cell in _tasks) {
        if (cell.taskID == taskID) {
            result = cell;
            break;
        }
    }
    
    if (!result) {//也许超出一页,则从数据库取
        NSDictionary* dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:taskID] forKey:@"taskID"];
        [[LLDAOBase shardLLDAOBase] searchWhereDic:[[LLDaoModelFreeTask alloc]init] Dic:dic orderBy:nil offset:0 count:1 callback:^(NSArray *resultArray)
         {
             for (LLDaoModelFreeTask* cell in resultArray) {
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

-(void)removeAliveTaskToDeleteList:(int)taskID
{
    LLTaskBase* task = [self aLiveTask:taskID];
    if (task) {
        [_needDeleteTasks addObject:task];
        [_aLiveTaskList removeObject:task];
    }
}

-(void)stopTask:(int)taskID
{
    LLTaskBase* task = [self aLiveTask:taskID];
    if (task) {
        [task taskNeedDelete];
        [self removeAliveTaskToDeleteList:taskID];
    }
}

-(LLTaskBase*)aLiveTask:(int)taskID
{
    LLTaskBase* result = nil;
    for (LLTaskBase* cell in _aLiveTaskList) {
        if (cell.taskID == taskID) {
            result = cell;
            break;
        }
    }
    return result;
}

-(void)reSetAllTaskAlive
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"taskStatus", nil];
    [[LLDAOBase shardLLDAOBase] updateToDB:[LLDaoModelFreeTask class] dic:dic dic:nil callback:nil];
}

-(void)reSetAllTaskSleep
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"taskStatus", nil];
    [[LLDAOBase shardLLDAOBase] updateToDB:[LLDaoModelFreeTask class] dic:dic dic:nil callback:nil];
}

-(void)stopTask
{
    int count = _aLiveTaskList.count;
    for (int i = 0; i<count; i++) {
        if ([_aLiveTaskList count]>0) {
            LLTaskBase* cell = [_aLiveTaskList objectAtIndex:0];
            [self stopTask:cell.taskID];
        }
    }
}

//销毁单例
+(void)attemptDealloc
{
    SharedInstance = nil;
}
@end
